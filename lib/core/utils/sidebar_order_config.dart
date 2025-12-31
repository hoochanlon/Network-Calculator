import 'calculator_name_translator.dart' show CalculatorKeys;

/// 侧边栏默认排序配置类
/// 
/// 用于定义侧边栏项目的默认显示顺序。
/// 开发者可以通过修改 [defaultOrder] 来调整默认排序，不会影响用户自定义的排序。
/// 
/// 使用示例：
/// ```dart
/// // 获取默认顺序
/// final order = SidebarOrderConfig.defaultOrder;
/// 
/// // 自定义顺序（仅用于开发测试）
/// final customOrder = [
///   CalculatorKeys.ipCalculator,
///   CalculatorKeys.subnetCalculator,
///   // ... 其他项目
/// ];
/// ```
class SidebarOrderConfig {
  /// 默认侧边栏顺序
  /// 
  /// 修改此列表可以调整侧边栏项目的默认显示顺序。
  /// 注意：此顺序仅在用户未自定义排序时生效。
  /// 
  /// 顺序说明：
  /// 1. 计算器工具（按使用频率或逻辑顺序排列）
  /// 2. 特殊功能项（历史记录、参考资料、设置）
  static const List<String> defaultOrder = [

    CalculatorKeys.ipCalculator,           // IP地址计算器
    CalculatorKeys.ipInclusionChecker,      // IP包含检测器
    CalculatorKeys.baseConverter,           // IP进制转换器

    
    CalculatorKeys.subnetCalculator,       // 子网掩码计算器
    CalculatorKeys.networkMerge,            // 路由聚合计算器
    CalculatorKeys.networkSplit,            // 超网拆分计算器
    

    CalculatorKeys.history,                 // 历史记录
    CalculatorKeys.references,              // 参考资料
    CalculatorKeys.settings,               // 设置
  ];

  /// 获取默认顺序的副本
  /// 
  /// 返回一个新的列表，避免直接修改原始列表。
  static List<String> getDefaultOrder() {
    return List<String>.from(defaultOrder);
  }

  /// 验证顺序列表是否有效
  /// 
  /// 检查顺序列表中是否包含所有必需的项目。
  /// 返回 true 表示有效，false 表示无效。
  static bool isValidOrder(List<String> order) {
    // 检查是否包含所有必需的项目
    final requiredKeys = {
      CalculatorKeys.ipCalculator,
      CalculatorKeys.subnetCalculator,
      CalculatorKeys.baseConverter,
      CalculatorKeys.networkMerge,
      CalculatorKeys.networkSplit,
      CalculatorKeys.ipInclusionChecker,
      CalculatorKeys.history,
      CalculatorKeys.references,
      CalculatorKeys.settings,
    };

    final orderSet = order.toSet();
    return requiredKeys.every((key) => orderSet.contains(key));
  }

  /// 合并顺序列表，确保包含所有必需的项目
  /// 
  /// 如果顺序列表中缺少某些项目，会自动添加到末尾。
  /// 返回一个包含所有必需项目的完整顺序列表。
  static List<String> mergeOrder(List<String> order) {
    final allKeys = getDefaultOrder();
    final orderSet = order.toSet();
    final result = <String>[];

    // 先添加已存在的项目（保持原有顺序）
    for (final key in order) {
      if (allKeys.contains(key) && !result.contains(key)) {
        result.add(key);
      }
    }

    // 添加缺失的项目（按默认顺序）
    for (final key in allKeys) {
      if (!result.contains(key)) {
        result.add(key);
      }
    }

    return result;
  }
}

