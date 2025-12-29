import 'dart:math';

class IpCalculatorService {
  static Map<String, dynamic>? calculateIpInfo(String ipAddress, String subnetMask) {
    try {
      // 处理CIDR格式
      int prefixLength = 24;
      if (subnetMask.startsWith('/')) {
        prefixLength = int.parse(subnetMask.substring(1));
        subnetMask = _cidrToSubnetMask(prefixLength);
      } else {
        prefixLength = _subnetMaskToCidr(subnetMask);
      }

      final ipParts = ipAddress.split('.');
      final maskParts = subnetMask.split('.');

      if (ipParts.length != 4 || maskParts.length != 4) {
        return {'error': 'Invalid IP or subnet mask format'};
      }

      final ip = _ipToInt(ipAddress);
      final mask = _ipToInt(subnetMask);
      final network = ip & mask;
      final broadcast = network | (~mask & 0xFFFFFFFF);
      final usableIps = pow(2, 32 - prefixLength).toInt() - 2;

      return {
        'ipAddress': ipAddress,
        'subnetMask': subnetMask,
        'cidr': '/$prefixLength',
        'networkAddress': _intToIp(network),
        'broadcastAddress': _intToIp(broadcast),
        'usableIps': usableIps > 0 ? usableIps : 0,
        'firstUsableIp': usableIps > 0 ? _intToIp(network + 1) : 'N/A',
        'lastUsableIp': usableIps > 0 ? _intToIp(broadcast - 1) : 'N/A',
        'networkClass': _getNetworkClass(ipAddress, prefixLength),
        'ipBinary': _ipToBinary(ipAddress),
        'subnetMaskBinary': _ipToBinary(subnetMask),
        'ipHexadecimal': _ipToHex(ipAddress),
        'subnetMaskHexadecimal': _ipToHex(subnetMask),
        'invertedMask': _intToIp(~mask & 0xFFFFFFFF),
      };
    } catch (e) {
      return {'error': 'Invalid input: ${e.toString()}'};
    }
  }

  static String _cidrToSubnetMask(int cidr) {
    final mask = ((0xFFFFFFFF << (32 - cidr)) & 0xFFFFFFFF);
    return _intToIp(mask);
  }

  static int _subnetMaskToCidr(String subnetMask) {
    final mask = _ipToInt(subnetMask);
    final binary = mask.toRadixString(2).padLeft(32, '0');
    // 计算连续1的个数
    int count = 0;
    for (int i = 0; i < 32; i++) {
      if (binary[i] == '1') {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  static int _ipToInt(String ip) {
    final parts = ip.split('.');
    return (int.parse(parts[0]) << 24) |
        (int.parse(parts[1]) << 16) |
        (int.parse(parts[2]) << 8) |
        int.parse(parts[3]);
  }

  static String _intToIp(int ip) {
    return '${(ip >> 24) & 0xFF}.${(ip >> 16) & 0xFF}.${(ip >> 8) & 0xFF}.${ip & 0xFF}';
  }

  static String _ipToBinary(String ip) {
    final parts = ip.split('.');
    return parts.map((p) => int.parse(p).toRadixString(2).padLeft(8, '0')).join('.');
  }

  static String _ipToHex(String ip) {
    final parts = ip.split('.');
    return parts.map((p) => int.parse(p).toRadixString(16).toUpperCase().padLeft(2, '0')).join('');
  }

  static String _getNetworkClass(String ip, int cidr) {
    final firstOctet = int.parse(ip.split('.')[0]);
    if (firstOctet >= 1 && firstOctet <= 126) return 'A';
    if (firstOctet >= 128 && firstOctet <= 191) return 'B';
    if (firstOctet >= 192 && firstOctet <= 223) return 'C';
    if (firstOctet >= 224 && firstOctet <= 239) return 'D';
    return 'E';
  }

  static bool validateIp(String ip) {
    final pattern = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    if (!pattern.hasMatch(ip)) return false;
    final parts = ip.split('.');
    return parts.every((p) {
      final num = int.tryParse(p);
      return num != null && num >= 0 && num <= 255;
    });
  }

  static bool validateSubnetMask(String mask) {
    if (mask.startsWith('/')) {
      final cidr = int.tryParse(mask.substring(1));
      return cidr != null && cidr >= 0 && cidr <= 32;
    }
    if (!validateIp(mask)) return false;
    final maskInt = _ipToInt(mask);
    final binary = maskInt.toRadixString(2).padLeft(32, '0');
    return !binary.contains('01');
  }
}

