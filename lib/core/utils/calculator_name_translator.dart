import '../../l10n/app_localizations.dart';

/// 计算器键值常量
class CalculatorKeys {
  static const String ipCalculator = 'ip_calculator';
  static const String subnetCalculator = 'subnet_calculator';
  static const String baseConverter = 'base_converter';
  static const String networkMerge = 'network_merge';
  static const String networkSplit = 'network_split';
  static const String ipInclusionChecker = 'ip_inclusion_checker';
}

/// 计算器名称翻译器
/// 用于在历史记录中保存键值，显示时根据当前语言环境翻译
class CalculatorNameTranslator {
  /// 将本地化的计算器名称转换为键值
  static String toKey(String localizedName, AppLocalizations l10n) {
    if (localizedName == l10n.ipCalculator) {
      return CalculatorKeys.ipCalculator;
    } else if (localizedName == l10n.subnetCalculator) {
      return CalculatorKeys.subnetCalculator;
    } else if (localizedName == l10n.baseConverter) {
      return CalculatorKeys.baseConverter;
    } else if (localizedName == l10n.networkMerge) {
      return CalculatorKeys.networkMerge;
    } else if (localizedName == l10n.networkSplit) {
      return CalculatorKeys.networkSplit;
    } else if (localizedName == l10n.ipInclusionChecker) {
      return CalculatorKeys.ipInclusionChecker;
    }
    // 向后兼容：如果已经是键值，直接返回
    if (_isKey(localizedName)) {
      return localizedName;
    }
    // 向后兼容：处理旧格式的英文名称
    return _legacyNameToKey(localizedName);
  }

  /// 将键值转换为本地化的计算器名称
  static String translate(String key, AppLocalizations l10n) {
    switch (key) {
      case CalculatorKeys.ipCalculator:
        return l10n.ipCalculator;
      case CalculatorKeys.subnetCalculator:
        return l10n.subnetCalculator;
      case CalculatorKeys.baseConverter:
        return l10n.baseConverter;
      case CalculatorKeys.networkMerge:
        return l10n.networkMerge;
      case CalculatorKeys.networkSplit:
        return l10n.networkSplit;
      case CalculatorKeys.ipInclusionChecker:
        return l10n.ipInclusionChecker;
      default:
        // 向后兼容：如果不是键值，尝试作为旧格式处理
        return _legacyKeyToName(key, l10n);
    }
  }

  /// 检查字符串是否是键值
  static bool isKey(String str) {
    return str == CalculatorKeys.ipCalculator ||
        str == CalculatorKeys.subnetCalculator ||
        str == CalculatorKeys.baseConverter ||
        str == CalculatorKeys.networkMerge ||
        str == CalculatorKeys.networkSplit ||
        str == CalculatorKeys.ipInclusionChecker;
  }

  /// 内部使用的检查方法
  static bool _isKey(String str) => isKey(str);

  /// 向后兼容：将旧格式的英文名称转换为键值
  static String _legacyNameToKey(String name) {
    if (name.contains('IP Calculator') || name == 'IP地址计算器') {
      return CalculatorKeys.ipCalculator;
    } else if (name.contains('Subnet Calculator') || name == '子网掩码计算器') {
      return CalculatorKeys.subnetCalculator;
    } else if (name.contains('Base Converter') || name == 'IP进制转换器') {
      return CalculatorKeys.baseConverter;
    } else if (name.contains('Network Merge') || name == '路由聚合计算器') {
      return CalculatorKeys.networkMerge;
    } else if (name.contains('Network Split') || name == '超网拆分计算器') {
      return CalculatorKeys.networkSplit;
    } else if (name.contains('IP Inclusion Checker') || name == 'IP包含检测器') {
      return CalculatorKeys.ipInclusionChecker;
    }
    return name; // 如果无法识别，返回原值
  }

  /// 向后兼容：将键值或旧格式名称转换为本地化名称
  static String _legacyKeyToName(String key, AppLocalizations l10n) {
    // 先尝试作为键值处理
    if (_isKey(key)) {
      return translate(key, l10n);
    }
    // 如果不是键值，尝试作为旧格式处理，转换为键值后再翻译
    final convertedKey = _legacyNameToKey(key);
    if (convertedKey != key && _isKey(convertedKey)) {
      return translate(convertedKey, l10n);
    }
    // 如果无法识别，返回原值
    return key;
  }
}

