enum MergeAlgorithm {
  summarization, // 最大化覆盖的汇总
  merge, // 基于路由器性能的合并最优解
}

class NetworkMergeService {
  static String? mergeNetworks(List<String> networks, {MergeAlgorithm algorithm = MergeAlgorithm.summarization}) {
    try {
      if (networks.isEmpty) {
        return 'No networks provided';
      }

      // 验证并解析所有网络
      final parsedNetworks = <Network>[];
      for (final network in networks) {
        final parsed = _parseNetwork(network);
        if (parsed == null) {
          return 'Invalid network format: $network';
        }
        parsedNetworks.add(parsed);
      }

      if (algorithm == MergeAlgorithm.summarization) {
        return _summarization(parsedNetworks);
      } else {
        return _merge(parsedNetworks);
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  // Summarization算法：找到所有网络的公共前缀，构建一个超网（最大化覆盖的汇总）
  static String _summarization(List<Network> networks) {
    final networkAddresses = networks.map((n) => n.address).toList();
    final commonPrefix = _findCommonPrefix(networkAddresses);
    final supernet = _buildSupernet(networkAddresses[0], commonPrefix);
    return supernet;
  }

  // Merge算法：合并相邻或重叠的CIDR范围，返回最小集合（基于路由器性能的合并最优解）
  static String _merge(List<Network> networks) {
    // 第一步：规范化所有网络并去重
    final normalized = <String, Network>{};
    for (final network in networks) {
      final norm = _normalizeNetwork(network);
      final key = _networkToString(norm);
      if (!normalized.containsKey(key)) {
        normalized[key] = norm;
      }
    }

    // 第二步：去除被包含的网络（如果A包含B，删除B）
    final filtered = <Network>[];
    final networkList = normalized.values.toList();
    for (final network in networkList) {
      bool isContained = false;
      for (final other in networkList) {
        if (network != other && _contains(other, network)) {
          isContained = true;
          break;
        }
      }
      if (!isContained) {
        filtered.add(network);
      }
    }

    // 第三步：按网络地址和前缀长度排序
    filtered.sort((a, b) {
      if (a.address != b.address) {
        return a.address.compareTo(b.address);
      }
      return a.prefixLength.compareTo(b.prefixLength);
    });

    // 第四步：合并相邻且前缀长度相同的网络
    // 只有当两个网络可以合并成一个CIDR块，且这个CIDR块只包含这两个网络时，才能合并
    bool changed = true;
    int iterations = 0;
    var merged = List<Network>.from(filtered);
    
    while (changed && iterations < 20) {
      iterations++;
      changed = false;
      final newMerged = <Network>[];
      final used = <int>{};
      
      for (int i = 0; i < merged.length; i++) {
        if (used.contains(i)) continue;
        
        Network? current = merged[i];
        bool foundMerge = false;
        
        // 尝试与后续网络合并（只检查相邻的网络）
        for (int j = i + 1; j < merged.length; j++) {
          if (used.contains(j)) continue;
          
          final other = merged[j];
          final mergeResult = _canMergeAdjacent(current!, other);
          
          if (mergeResult != null) {
            // 检查合并后的网络是否只包含这两个网络
            // 计算合并后的网络应该包含哪些子网（使用原始网络的prefixLength）
            final originalPrefix = merged[i].prefixLength;
            final subnetsInMerged = _getSubnetsInRange(mergeResult, originalPrefix);
            
            // 检查合并后的网络是否只包含被合并的两个网络
            // 合并后的网络应该正好包含2个子网，且这两个子网就是被合并的两个网络
            if (subnetsInMerged.length == 2) {
              final net1 = merged[i];
              final net2 = merged[j];
              final subnet1 = subnetsInMerged[0];
              final subnet2 = subnetsInMerged[1];
              
              // 检查这两个子网是否正好是被合并的两个网络
              final matches1 = (_networkEquals(subnet1, net1) && _networkEquals(subnet2, net2)) ||
                             (_networkEquals(subnet1, net2) && _networkEquals(subnet2, net1));
              
              if (matches1) {
                // 可以合并
                current = mergeResult;
                used.add(i);
                used.add(j);
                foundMerge = true;
                changed = true;
                break;
              }
            }
          }
        }
        
        if (!foundMerge && !used.contains(i)) {
          newMerged.add(current!);
        } else if (foundMerge) {
          newMerged.add(current!);
        }
      }
      
      // 再次去除被包含的网络
      final finalMerged = <Network>[];
      for (final network in newMerged) {
        bool isContained = false;
        for (final other in newMerged) {
          if (network != other && _contains(other, network)) {
            isContained = true;
            break;
          }
        }
        if (!isContained) {
          finalMerged.add(network);
        }
      }
      
      merged = finalMerged
        ..sort((a, b) {
          if (a.address != b.address) {
            return a.address.compareTo(b.address);
          }
          return a.prefixLength.compareTo(b.prefixLength);
        });
    }

    // 转换为字符串
    final result = merged.map((n) => _networkToString(n)).join('\n');
    return result;
  }

  // 获取一个网络范围内所有指定前缀长度的子网
  static List<Network> _getSubnetsInRange(Network network, int subnetPrefixLength) {
    final subnets = <Network>[];
    final mask = ((0xFFFFFFFF << (32 - network.prefixLength)) & 0xFFFFFFFF);
    final networkStart = network.address & mask;
    final networkSize = 1 << (32 - network.prefixLength);
    final subnetSize = 1 << (32 - subnetPrefixLength);
    final subnetMask = ((0xFFFFFFFF << (32 - subnetPrefixLength)) & 0xFFFFFFFF);
    
    for (int addr = networkStart; addr < networkStart + networkSize; addr += subnetSize) {
      final subnetAddr = addr & subnetMask;
      subnets.add(Network(subnetAddr, subnetPrefixLength));
    }
    
    return subnets;
  }

  // 检查两个网络是否相等
  static bool _networkEquals(Network a, Network b) {
    return a.address == b.address && a.prefixLength == b.prefixLength;
  }

  // 规范化网络地址
  static Network _normalizeNetwork(Network network) {
    final mask = ((0xFFFFFFFF << (32 - network.prefixLength)) & 0xFFFFFFFF);
    final networkAddress = network.address & mask;
    return Network(networkAddress, network.prefixLength);
  }

  // 检查两个网络是否可以合并为相邻网络（仅用于相同前缀长度的相邻网络）
  static Network? _canMergeAdjacent(Network a, Network b) {
    // 两个网络必须前缀长度相同
    if (a.prefixLength != b.prefixLength || a.prefixLength == 0) {
      return null;
    }

    final mask = ((0xFFFFFFFF << (32 - a.prefixLength)) & 0xFFFFFFFF);
    final aNetwork = a.address & mask;
    final bNetwork = b.address & mask;
    
    // 如果地址相同，返回任意一个（去重）
    if (aNetwork == bNetwork) {
      return a;
    }
    
    // 计算网络大小
    final networkSize = 1 << (32 - a.prefixLength);
    
    // 检查是否真正相邻（一个网络的结束地址+1等于另一个网络的开始地址）
    final aEnd = aNetwork + networkSize - 1;
    final bEnd = bNetwork + networkSize - 1;
    
    // a在b之前，且a的结束地址+1等于b的开始地址
    if (aNetwork < bNetwork && aEnd + 1 == bNetwork) {
      // 可以合并，前缀长度减1
      final newPrefix = a.prefixLength - 1;
      final newMask = ((0xFFFFFFFF << (32 - newPrefix)) & 0xFFFFFFFF);
      final normalizedAddress = aNetwork & newMask;
      return Network(normalizedAddress, newPrefix);
    }
    
    // b在a之前，且b的结束地址+1等于a的开始地址
    if (bNetwork < aNetwork && bEnd + 1 == aNetwork) {
      // 可以合并，前缀长度减1
      final newPrefix = a.prefixLength - 1;
      final newMask = ((0xFFFFFFFF << (32 - newPrefix)) & 0xFFFFFFFF);
      final normalizedAddress = bNetwork & newMask;
      return Network(normalizedAddress, newPrefix);
    }

    return null;
  }

  // 检查网络a是否包含网络b
  static bool _contains(Network a, Network b) {
    if (a.prefixLength > b.prefixLength) {
      return false; // a的前缀更长，不可能包含b
    }
    final aMask = ((0xFFFFFFFF << (32 - a.prefixLength)) & 0xFFFFFFFF);
    final aNetwork = a.address & aMask;
    final bNetwork = b.address & aMask;
    return aNetwork == bNetwork;
  }

  // 将Network转换为字符串
  static String _networkToString(Network network) {
    final ip = _intToIp(network.address);
    return '$ip/${network.prefixLength}';
  }

  static Network? _parseNetwork(String network) {
    try {
      final trimmed = network.trim();
      
      // 检查是否包含 CIDR 后缀
      if (trimmed.contains('/')) {
        final parts = trimmed.split('/');
        if (parts.length != 2) return null;

        final ipParts = parts[0].split('.');
        if (ipParts.length != 4) return null;

        final address = (int.parse(ipParts[0]) << 24) |
            (int.parse(ipParts[1]) << 16) |
            (int.parse(ipParts[2]) << 8) |
            int.parse(ipParts[3]);

        final prefixLength = int.parse(parts[1]);
        if (prefixLength < 0 || prefixLength > 32) return null;

        return Network(address, prefixLength);
      } else {
        // 没有 CIDR 后缀，视为单个 IP 地址，使用 /32
        final ipParts = trimmed.split('.');
        if (ipParts.length != 4) return null;

        final address = (int.parse(ipParts[0]) << 24) |
            (int.parse(ipParts[1]) << 16) |
            (int.parse(ipParts[2]) << 8) |
            int.parse(ipParts[3]);

        // 单个 IP 地址使用 /32（单个主机）
        return Network(address, 32);
      }
    } catch (e) {
      return null;
    }
  }

  static int _findCommonPrefix(List<int> addresses) {
    if (addresses.isEmpty) return 0;

    int commonBits = 0;
    for (int bit = 0; bit < 32; bit++) {
      final mask = 1 << (31 - bit);
      final firstBit = (addresses[0] & mask) != 0;
      if (addresses.every((addr) => ((addr & mask) != 0) == firstBit)) {
        commonBits++;
      } else {
        break;
      }
    }

    return commonBits;
  }

  static String _buildSupernet(int address, int prefixLength) {
    final mask = ((0xFFFFFFFF << (32 - prefixLength)) & 0xFFFFFFFF);
    final networkAddress = address & mask;
    final ip = _intToIp(networkAddress);
    return '$ip/$prefixLength';
  }

  static String _intToIp(int ip) {
    return '${(ip >> 24) & 0xFF}.${(ip >> 16) & 0xFF}.${(ip >> 8) & 0xFF}.${ip & 0xFF}';
  }
}

class Network {
  final int address;
  final int prefixLength;

  Network(this.address, this.prefixLength);
}

