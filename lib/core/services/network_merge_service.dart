class NetworkMergeService {
  static String? mergeNetworks(List<String> networks) {
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

      // 找到公共前缀
      final networkAddresses = parsedNetworks.map((n) => n.address).toList();
      final commonPrefix = _findCommonPrefix(networkAddresses);

      // 构建超网
      final supernet = _buildSupernet(networkAddresses[0], commonPrefix);

      return supernet;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  static Network? _parseNetwork(String network) {
    try {
      final parts = network.split('/');
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

