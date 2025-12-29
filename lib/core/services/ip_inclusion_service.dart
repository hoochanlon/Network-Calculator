import '../models/network_info.dart';

class IpInclusionService {
  static Map<String, dynamic>? checkInclusion(String cidr1, String cidr2) {
    try {
      final network1 = _parseNetwork(cidr1);
      final network2 = _parseNetwork(cidr2);

      if (network1 == null || network2 == null) {
        return {'error': 'Invalid CIDR format'};
      }

      // 检查network1是否在network2中
      final isIncluded = _isNetworkInNetwork(network1, network2);

      if (isIncluded) {
        final totalIps = 1 << (32 - network2.prefixLength);
        final usableIps = totalIps > 2 ? totalIps - 2 : 0;
        final firstUsable = totalIps > 2 ? _intToIp(network2.networkAddress + 1) : null;
        final lastUsable = totalIps > 2 ? _intToIp(network2.networkAddress + totalIps - 2) : null;

        return {
          'result': true,
          'networkAddress': _intToIp(network2.networkAddress),
          'broadcastAddress': _intToIp(network2.networkAddress + totalIps - 1),
          'usableIps': usableIps,
          'firstUsableIp': firstUsable,
          'lastUsableIp': lastUsable,
        };
      } else {
        return {'result': false};
      }
    } catch (e) {
      return {'error': 'Check failed: ${e.toString()}'};
    }
  }

  static bool _isNetworkInNetwork(NetworkInfo network1, NetworkInfo network2) {
    // network1必须在network2中，意味着：
    // 1. network1的网络地址必须在network2的范围内
    // 2. network1的前缀长度必须大于等于network2的前缀长度（更具体）
    if (network1.prefixLength < network2.prefixLength) {
      return false;
    }

    final mask2 = ((0xFFFFFFFF << (32 - network2.prefixLength)) & 0xFFFFFFFF);
    final network2Base = network2.networkAddress & mask2;
    final network1Base = network1.networkAddress & mask2;

    return network1Base == network2Base;
  }

  static NetworkInfo? _parseNetwork(String network) {
    try {
      String ipPart;
      int prefixLength;

      if (network.contains('/')) {
        final parts = network.split('/');
        ipPart = parts[0];
        prefixLength = int.parse(parts[1]);
      } else {
        // 如果只是IP地址，假设是/32
        ipPart = network;
        prefixLength = 32;
      }

      final ipParts = ipPart.split('.');
      if (ipParts.length != 4) return null;

      final address = (int.parse(ipParts[0]) << 24) |
          (int.parse(ipParts[1]) << 16) |
          (int.parse(ipParts[2]) << 8) |
          int.parse(ipParts[3]);

      if (prefixLength < 0 || prefixLength > 32) return null;

      final mask = ((0xFFFFFFFF << (32 - prefixLength)) & 0xFFFFFFFF);
      final networkAddress = address & mask;

      return NetworkInfo(networkAddress, prefixLength);
    } catch (e) {
      return null;
    }
  }

  static String _intToIp(int ip) {
    return '${(ip >> 24) & 0xFF}.${(ip >> 16) & 0xFF}.${(ip >> 8) & 0xFF}.${ip & 0xFF}';
  }
}

