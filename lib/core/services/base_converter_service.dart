class BaseConverterService {
  static Map<String, dynamic>? convertIp(String input) {
    try {
      input = input.trim().toUpperCase();

      // 处理32位二进制字符串（无点分隔）
      if (input.length == 32 && _isBinary(input)) {
        input = _formatBinaryWithDots(input);
      }

      final parts = input.split('.');

      if (parts.length == 4) {
        // 点分二进制格式
        if (parts.every((p) => p.length == 8 && _isBinary(p))) {
          return _convertFromBinary(parts);
        }
        // 点分十进制格式
        if (parts.every((p) => _isDecimal(p) && int.parse(p) >= 0 && int.parse(p) <= 255)) {
          return _convertFromDecimal(parts);
        }
        // 点分十六进制格式
        if (parts.every((p) => p.length == 2 && _isHex(p))) {
          return _convertFromHex(parts);
        }
      }

      // 无点分隔的十六进制（8位）
      if (input.length == 8 && _isHex(input)) {
        return _convertFromHexString(input);
      }

      // 无点分隔的十进制
      if (_isDecimal(input)) {
        final decimal = int.parse(input);
        if (decimal < 0 || decimal > 4294967295) {
          return {'error': 'Decimal value out of range'};
        }
        return _convertFromDecimalValue(decimal);
      }

      return {'error': 'Invalid IP address format'};
    } catch (e) {
      return {'error': 'Conversion failed: ${e.toString()}'};
    }
  }

  static Map<String, dynamic> _convertFromBinary(List<String> parts) {
    final decimal = parts.fold<int>(0, (sum, part) => (sum << 8) | int.parse(part, radix: 2));
    final decimalDotted = parts.map((p) => int.parse(p, radix: 2).toString()).join('.');
    final hex = parts.map((p) => int.parse(p, radix: 2).toRadixString(16).toUpperCase().padLeft(2, '0')).join('');
    final complement = _calculateComplementFromBinary(parts, decimal);

    return {
      'binary': parts.join('.'),
      'decimal': decimalDotted,
      'decimalNoDot': decimal,
      'hexadecimal': hex,
      'complement': complement,
    };
  }

  static Map<String, dynamic> _convertFromDecimal(List<String> parts) {
    final decimal = parts.fold<int>(0, (sum, part) => (sum << 8) | int.parse(part));
    final binary = parts.map((p) => int.parse(p).toRadixString(2).padLeft(8, '0')).join('.');
    final hex = parts.map((p) => int.parse(p).toRadixString(16).toUpperCase().padLeft(2, '0')).join('');
    final complement = _calculateComplementFromDecimal(parts, decimal);

    return {
      'decimal': parts.join('.'),
      'decimalNoDot': decimal,
      'binary': binary,
      'hexadecimal': hex,
      'complement': complement,
    };
  }

  static Map<String, dynamic> _convertFromHex(List<String> parts) {
    final decimal = parts.fold<int>(0, (sum, part) => (sum << 8) | int.parse(part, radix: 16));
    final decimalDotted = parts.map((p) => int.parse(p, radix: 16).toString()).join('.');
    final binary = parts.map((p) => int.parse(p, radix: 16).toRadixString(2).padLeft(8, '0')).join('.');
    final hex = parts.map((p) => p.toUpperCase()).join('');
    final complement = _calculateComplementFromDecimal(parts.map((p) => int.parse(p, radix: 16).toString()).toList(), decimal);

    return {
      'hexadecimal': hex,
      'decimal': decimalDotted,
      'decimalNoDot': decimal,
      'binary': binary,
      'complement': complement,
    };
  }

  static Map<String, dynamic> _convertFromHexString(String hex) {
    final decimal = int.parse(hex, radix: 16);
    final decimalDotted = _intToDottedDecimal(decimal);
    final binary = decimalDotted.split('.').map((p) => int.parse(p).toRadixString(2).padLeft(8, '0')).join('.');
    final complement = _calculateComplementFromInt(decimal);

    return {
      'hexadecimal': hex,
      'decimal': decimalDotted,
      'decimalNoDot': decimal,
      'binary': binary,
      'complement': complement,
    };
  }

  static Map<String, dynamic> _convertFromDecimalValue(int decimal) {
    final decimalDotted = _intToDottedDecimal(decimal);
    final binary = decimalDotted.split('.').map((p) => int.parse(p).toRadixString(2).padLeft(8, '0')).join('.');
    final hex = decimalDotted.split('.').map((p) => int.parse(p).toRadixString(16).toUpperCase().padLeft(2, '0')).join('');
    final complement = _calculateComplementFromInt(decimal);

    return {
      'decimal': decimalDotted,
      'decimalNoDot': decimal,
      'binary': binary,
      'hexadecimal': hex,
      'complement': complement,
    };
  }

  // 从二进制输入计算反码（按位取反）
  static Map<String, dynamic> _calculateComplementFromBinary(List<String> parts, int decimal) {
    // 对于二进制输入，反码的二进制表示是按位取反（0变1，1变0）
    final complementBinaryParts = parts.map((p) => p.split('').map((c) => c == '0' ? '1' : '0').join()).toList();
    
    // 反码的十进制点分格式：每个部分与255异或（等同于 255 - int(part, 2)）
    final complementDecimalDotted = parts.map((p) => (int.parse(p, radix: 2) ^ 255).toString()).join('.');
    
    // 反码的十六进制：每个部分与255异或后转十六进制
    final complementHex = parts.map((p) => (int.parse(p, radix: 2) ^ 255).toRadixString(16).toUpperCase().padLeft(2, '0')).join('');
    
    final complementDecimal = 4294967295 - decimal;

    return {
      'binary': complementBinaryParts.join('.'),
      'decimal': complementDecimalDotted,
      'decimalNoDot': complementDecimal,
      'hexadecimal': complementHex,
    };
  }

  // 从十进制输入计算反码（255 - num）
  static Map<String, dynamic> _calculateComplementFromDecimal(List<String> parts, int decimal) {
    // 对于十进制输入，反码的二进制表示是 255 - num 的二进制形式
    final complementBinaryParts = parts.map((p) {
      final num = int.parse(p);
      return (255 - num).toRadixString(2).padLeft(8, '0');
    }).toList();
    
    // 反码的十进制点分格式：255 - num
    final complementDecimalDotted = parts.map((p) => (255 - int.parse(p)).toString()).join('.');
    
    // 反码的十六进制：255 - num 后转十六进制
    final complementHex = parts.map((p) => (255 - int.parse(p)).toRadixString(16).toUpperCase().padLeft(2, '0')).join('');
    
    final complementDecimal = 4294967295 - decimal;

    return {
      'binary': complementBinaryParts.join('.'),
      'decimal': complementDecimalDotted,
      'decimalNoDot': complementDecimal,
      'hexadecimal': complementHex,
    };
  }

  static Map<String, dynamic> _calculateComplementFromInt(int decimal) {
    final complementDecimal = 4294967295 - decimal;
    final complementDotted = _intToDottedDecimal(complementDecimal);
    final complementBinary = complementDotted.split('.').map((p) => int.parse(p).toRadixString(2).padLeft(8, '0')).join('.');
    final complementHex = complementDotted.split('.').map((p) => int.parse(p).toRadixString(16).toUpperCase().padLeft(2, '0')).join('');

    return {
      'binary': complementBinary,
      'decimal': complementDotted,
      'decimalNoDot': complementDecimal,
      'hexadecimal': complementHex,
    };
  }

  static String _formatBinaryWithDots(String binary) {
    return '${binary.substring(0, 8)}.${binary.substring(8, 16)}.${binary.substring(16, 24)}.${binary.substring(24, 32)}';
  }

  static String _intToDottedDecimal(int value) {
    return '${(value >> 24) & 0xFF}.${(value >> 16) & 0xFF}.${(value >> 8) & 0xFF}.${value & 0xFF}';
  }

  static bool _isBinary(String s) => s.split('').every((c) => c == '0' || c == '1');
  static bool _isDecimal(String s) => int.tryParse(s) != null;
  static bool _isHex(String s) => int.tryParse(s, radix: 16) != null;
}

