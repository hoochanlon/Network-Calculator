import '../models/network_info.dart';

class NetworkSplitService {
  static List<String>? splitNetwork(String supernet, int targetPrefixLength) {
    try {
      final parsed = _parseNetwork(supernet);
      if (parsed == null) {
        return null;
      }

      if (targetPrefixLength <= parsed.prefixLength || targetPrefixLength > 32) {
        return null;
      }

      final subnets = <String>[];
      final subnetCount = 1 << (targetPrefixLength - parsed.prefixLength);
      final subnetSize = 1 << (32 - targetPrefixLength);

      for (int i = 0; i < subnetCount; i++) {
        final subnetAddress = parsed.networkAddress + (i * subnetSize);
        final subnetIp = _intToIp(subnetAddress);
        subnets.add('$subnetIp/$targetPrefixLength');
      }

      return subnets;
    } catch (e) {
      return null;
    }
  }

  static NetworkInfo? _parseNetwork(String network) {
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

