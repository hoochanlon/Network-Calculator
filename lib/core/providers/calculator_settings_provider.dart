import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/calculator_name_translator.dart' show CalculatorKeys;
import '../utils/sidebar_order_config.dart' show SidebarOrderConfig;
import '../config/app_config.dart';

class CalculatorOrderNotifier extends ChangeNotifier {
  void notifyOrderChanged() {
    notifyListeners();
  }
}

class CalculatorSettingsProvider {
  static const String _keyPreserveInputs = 'preserve_calculator_inputs';
  static const String _keyCalculatorOrder = 'calculator_order';
  static const String _keySidebarOrder = 'sidebar_order'; // 新的侧边栏排序键
  static const String _keyLockedItems = 'locked_items'; // 锁定的项目列表
  static const String _keySidebarDragEnabled = 'sidebar_drag_enabled'; // 侧边栏拖拽开关
  static const String _keyHistoryLimit = 'history_limit';
  static const String _keyHistoryStoragePath = 'history_storage_path';
  static const String _keyHistoryMigrated = 'history_migrated_to_file';
  static const String _keyWindowWidth = 'window_width';
  static const String _keyWindowHeight = 'window_height';
  
  // 使用 AppConfig 中的默认值
  static int get _defaultHistoryLimit => AppConfig.defaultHistoryLimit;
  static double get _defaultWindowWidth => AppConfig.defaultWindowWidth;
  static double get _defaultWindowHeight => AppConfig.defaultWindowHeight;
  static double get _minWindowWidth => AppConfig.minWindowWidth;
  static double get _minWindowHeight => AppConfig.minWindowHeight;
  static final CalculatorOrderNotifier _orderNotifier = CalculatorOrderNotifier();
  
  static CalculatorOrderNotifier get orderNotifier => _orderNotifier;

  /// 默认计算器顺序（按键值）
  static const List<String> defaultCalculatorOrder = [
    'ip_calculator',
    'subnet_calculator',
    'base_converter',
    'network_merge',
    'network_split',
    'ip_inclusion_checker',
  ];

  /// 默认侧边栏顺序（包括所有项）
  /// 
  /// 已迁移到 [SidebarOrderConfig.defaultOrder]，保留此属性以保持向后兼容。
  /// 新代码应使用 [SidebarOrderConfig.getDefaultOrder()] 获取默认顺序。
  @Deprecated('使用 SidebarOrderConfig.getDefaultOrder() 代替')
  static List<String> get defaultSidebarOrder => SidebarOrderConfig.getDefaultOrder();

  /// 是否保留计算器的输入和结果
  static Future<bool> getPreserveInputs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyPreserveInputs) ?? true; // 默认为开启
  }

  /// 设置是否保留计算器的输入和结果
  static Future<void> setPreserveInputs(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPreserveInputs, value);
  }

  /// 获取计算器顺序（向后兼容）
  static Future<List<String>> getCalculatorOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final orderJson = prefs.getString(_keyCalculatorOrder);
    if (orderJson == null) {
      return List<String>.from(defaultCalculatorOrder);
    }
    try {
      final List<dynamic> orderList = json.decode(orderJson);
      return orderList.map((e) => e.toString()).toList();
    } catch (e) {
      return List<String>.from(defaultCalculatorOrder);
    }
  }

  /// 设置计算器顺序（向后兼容）
  static Future<void> setCalculatorOrder(List<String> order) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCalculatorOrder, json.encode(order));
    _orderNotifier.notifyOrderChanged();
  }

  /// 重置计算器顺序为默认（向后兼容）
  static Future<void> resetCalculatorOrder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCalculatorOrder);
    _orderNotifier.notifyOrderChanged();
  }

  /// 获取侧边栏顺序（包括所有项）
  static Future<List<String>> getSidebarOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final orderJson = prefs.getString(_keySidebarOrder);
    List<String> order;
    
    if (orderJson == null) {
      // 如果没有保存的侧边栏顺序，直接使用默认顺序
      // 这样修改 SidebarOrderConfig.defaultOrder 后可以立即生效
      order = SidebarOrderConfig.getDefaultOrder();
    } else {
      try {
        final List<dynamic> orderList = json.decode(orderJson);
        order = orderList.map((e) => e.toString()).toList();
        // 验证并合并顺序，确保包含所有必需的项目
        if (!SidebarOrderConfig.isValidOrder(order)) {
          order = SidebarOrderConfig.mergeOrder(order);
        }
      } catch (e) {
        // 解析失败时使用默认顺序
        order = SidebarOrderConfig.getDefaultOrder();
      }
    }
    
    return order;
  }

  /// 设置侧边栏顺序
  static Future<void> setSidebarOrder(List<String> order, {bool silent = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySidebarOrder, json.encode(order));
    if (!silent) {
      _orderNotifier.notifyOrderChanged();
    }
  }

  /// 重置侧边栏顺序为默认
  static Future<void> resetSidebarOrder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySidebarOrder);
    _orderNotifier.notifyOrderChanged();
  }

  /// 获取历史记录限制数量
  static Future<int> getHistoryLimit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyHistoryLimit) ?? _defaultHistoryLimit;
  }

  /// 设置历史记录限制数量
  static Future<void> setHistoryLimit(int limit) async {
    // 使用 AppConfig 中的限制值
    if (limit < AppConfig.minHistoryLimit) limit = AppConfig.minHistoryLimit;
    if (limit > AppConfig.maxHistoryLimit) limit = AppConfig.maxHistoryLimit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyHistoryLimit, limit);
  }

  /// 获取历史记录存储路径
  static Future<String?> getHistoryStoragePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyHistoryStoragePath);
  }

  /// 设置历史记录存储路径
  static Future<void> setHistoryStoragePath(String? path) async {
    final prefs = await SharedPreferences.getInstance();
    if (path == null || path.isEmpty) {
      await prefs.remove(_keyHistoryStoragePath);
    } else {
      await prefs.setString(_keyHistoryStoragePath, path);
    }
  }

  /// 检查是否已迁移到文件存储
  static Future<bool> isHistoryMigrated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHistoryMigrated) ?? false;
  }

  /// 标记已迁移到文件存储
  static Future<void> markHistoryMigrated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHistoryMigrated, true);
  }

  /// 获取锁定的项目列表（默认锁定"设置"项）
  static Future<Set<String>> getLockedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final lockedJson = prefs.getString(_keyLockedItems);
    Set<String> lockedItems;
    
    if (lockedJson == null) {
      // 首次使用，不再默认锁定任何项目，保持和 Windows 客户端一致
      lockedItems = {};
      await setLockedItems(lockedItems);
      return lockedItems;
    }
    
    try {
      final List<dynamic> lockedList = json.decode(lockedJson);
      lockedItems = lockedList.map((e) => e.toString()).toSet();
    } catch (e) {
      // 数据损坏时，重置为不锁定任何项目
      lockedItems = {};
      await setLockedItems(lockedItems);
      return lockedItems;
    }
    
    return lockedItems;
  }
  
  /// 初始化锁定状态（仅在首次使用时，确保"设置"项默认被锁定）
  static Future<void> initializeLockedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final lockedJson = prefs.getString(_keyLockedItems);
    final initializedKey = 'locked_items_initialized';
    
    // 检查是否已经初始化过
    final hasInitialized = prefs.getBool(initializedKey) ?? false;
    
    // 如果还没有设置过锁定项，默认不锁定任何项目
    if (lockedJson == null) {
      await setLockedItems({});
      await prefs.setBool(initializedKey, true);
    } else if (!hasInitialized) {
      // 如果已经有锁定项但还没有标记为已初始化，检查是否需要初始化
      try {
        final List<dynamic> lockedList = json.decode(lockedJson);
        final lockedItems = lockedList.map((e) => e.toString()).toSet();
        // 如果锁定列表为空，保持不锁定任何项目
        if (lockedItems.isEmpty) {
          await setLockedItems({});
        }
        await prefs.setBool(initializedKey, true);
      } catch (e) {
        // 数据损坏，重置为不锁定任何项目
        await setLockedItems({});
        await prefs.setBool(initializedKey, true);
      }
    }
    // 如果已经初始化过，不再修改锁定状态，尊重用户的选择
  }

  /// 设置锁定的项目列表
  static Future<void> setLockedItems(Set<String> lockedItems) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLockedItems, json.encode(lockedItems.toList()));
    _orderNotifier.notifyOrderChanged();
  }

  /// 切换项目的锁定状态
  static Future<void> toggleItemLock(String itemKey) async {
    final lockedItems = await getLockedItems();
    if (lockedItems.contains(itemKey)) {
      lockedItems.remove(itemKey);
    } else {
      lockedItems.add(itemKey);
    }
    await setLockedItems(lockedItems);
  }

  /// 检查项目是否被锁定
  static Future<bool> isItemLocked(String itemKey) async {
    final lockedItems = await getLockedItems();
    return lockedItems.contains(itemKey);
  }

  /// 获取侧边栏拖拽开关状态
  static Future<bool> getSidebarDragEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySidebarDragEnabled) ?? false; // 默认关闭
  }

  /// 设置侧边栏拖拽开关状态
  static Future<void> setSidebarDragEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySidebarDragEnabled, enabled);
    _orderNotifier.notifyOrderChanged();
  }

  /// 获取窗口宽度
  static Future<double> getWindowWidth() async {
    final prefs = await SharedPreferences.getInstance();
    final width = prefs.getDouble(_keyWindowWidth) ?? _defaultWindowWidth;
    // 确保不小于最小宽度
    return width < _minWindowWidth ? _minWindowWidth : width;
  }

  /// 获取窗口高度
  static Future<double> getWindowHeight() async {
    final prefs = await SharedPreferences.getInstance();
    final height = prefs.getDouble(_keyWindowHeight) ?? _defaultWindowHeight;
    // 确保不小于最小高度
    return height < _minWindowHeight ? _minWindowHeight : height;
  }

  /// 设置窗口尺寸
  static Future<void> setWindowSize(double width, double height) async {
    final prefs = await SharedPreferences.getInstance();
    // 确保不小于最小尺寸
    final finalWidth = width < _minWindowWidth ? _minWindowWidth : width;
    final finalHeight = height < _minWindowHeight ? _minWindowHeight : height;
    await prefs.setDouble(_keyWindowWidth, finalWidth);
    await prefs.setDouble(_keyWindowHeight, finalHeight);
  }

  /// 获取最小窗口宽度
  static double get minWindowWidth => _minWindowWidth;

  /// 获取最小窗口高度
  static double get minWindowHeight => _minWindowHeight;
}


