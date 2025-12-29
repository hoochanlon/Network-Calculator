import 'dart:math';

class SubnetCalculatorService {
  static Map<String, dynamic>? calculateFromHosts(int hosts) {
    if (hosts < 2) {
      return {'error': 'Host count must be at least 2'};
    }

    final bitsNeeded = (log(hosts + 2) / ln2).ceil();
    final subnetMaskBits = 32 - bitsNeeded;
    final subnetMask = _cidrToSubnetMask(subnetMaskBits);
    final usableHosts = pow(2, 32 - subnetMaskBits).toInt() - 2;
    final invertedMask = _intToIp(~_ipToInt(subnetMask) & 0xFFFFFFFF);

    return {
      'hosts': hosts,
      'subnetMask': subnetMask,
      'cidr': '/$subnetMaskBits',
      'usableHosts': usableHosts,
      'invertedMask': invertedMask,
      'subnetMaskBinary': _ipToBinary(subnetMask),
      'invertedMaskBinary': _ipToBinary(invertedMask),
      'subnetMaskHex': _ipToHex(subnetMask),
      'invertedMaskHex': _ipToHex(invertedMask),
    };
  }

  static Map<String, dynamic>? calculateFromSubnet(String subnetInput) {
    try {
      int prefixLength;
      String subnetMask;

      if (subnetInput.startsWith('/')) {
        prefixLength = int.parse(subnetInput.substring(1));
        if (prefixLength < 0 || prefixLength > 32) {
          return {'error': 'Invalid CIDR, must be between /0 and /32'};
        }
        subnetMask = _cidrToSubnetMask(prefixLength);
      } else {
        if (!_validateSubnetMask(subnetInput)) {
          return {'error': 'Invalid subnet mask format'};
        }
        subnetMask = subnetInput;
        prefixLength = _subnetMaskToCidr(subnetMask);
      }

      final usableHosts = pow(2, 32 - prefixLength).toInt() - 2;
      final invertedMask = _intToIp(~_ipToInt(subnetMask) & 0xFFFFFFFF);

      return {
        'subnetInput': subnetInput,
        'subnetMask': subnetMask,
        'cidr': '/$prefixLength',
        'usableHosts': usableHosts,
        'invertedMask': invertedMask,
        'subnetMaskBinary': _ipToBinary(subnetMask),
        'invertedMaskBinary': _ipToBinary(invertedMask),
        'subnetMaskHex': _ipToHex(subnetMask),
        'invertedMaskHex': _ipToHex(invertedMask),
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

  static bool _validateSubnetMask(String mask) {
    final pattern = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    if (!pattern.hasMatch(mask)) return false;
    final parts = mask.split('.');
    if (!parts.every((p) {
      final num = int.tryParse(p);
      return num != null && num >= 0 && num <= 255;
    })) return false;

    final maskInt = _ipToInt(mask);
    final binary = maskInt.toRadixString(2).padLeft(32, '0');
    return !binary.contains('01');
  }
}

