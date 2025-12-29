import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/calculator_name_translator.dart' show CalculatorKeys;

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
  static const int _defaultHistoryLimit = 8000;
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
  static const List<String> defaultSidebarOrder = [
    'ip_calculator',
    'subnet_calculator',
    'base_converter',
    'network_merge',
    'network_split',
    'ip_inclusion_checker',
    'history',
    'references',
    'settings',
  ];

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
      // 如果没有保存的侧边栏顺序，尝试从旧的计算器顺序迁移
      final calculatorOrder = await getCalculatorOrder();
      // 将旧的计算器顺序与默认的特殊项顺序合并
      order = <String>[];
      order.addAll(calculatorOrder);
      // 添加特殊项（如果还没有）
      for (final specialKey in ['history', 'references', 'settings']) {
        if (!order.contains(specialKey)) {
          order.add(specialKey);
        }
      }
    } else {
      try {
        final List<dynamic> orderList = json.decode(orderJson);
        order = orderList.map((e) => e.toString()).toList();
      } catch (e) {
        order = List<String>.from(defaultSidebarOrder);
      }
    }
    
    return order;
  }

  /// 设置侧边栏顺序
  static Future<void> setSidebarOrder(List<String> order) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySidebarOrder, json.encode(order));
    _orderNotifier.notifyOrderChanged();
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
    if (limit < 10) limit = 10; // 最小限制为10
    if (limit > 100000) limit = 100000; // 最大限制为100000
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
      // 首次使用，默认锁定"设置"项
      lockedItems = {CalculatorKeys.settings};
      await setLockedItems(lockedItems);
      return lockedItems;
    }
    
    try {
      final List<dynamic> lockedList = json.decode(lockedJson);
      lockedItems = lockedList.map((e) => e.toString()).toSet();
    } catch (e) {
      // 数据损坏，重置为默认（锁定"设置"项）
      lockedItems = {CalculatorKeys.settings};
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
    
    // 如果还没有设置过锁定项，默认锁定"设置"项
    if (lockedJson == null) {
      await setLockedItems({CalculatorKeys.settings});
      await prefs.setBool(initializedKey, true);
    } else if (!hasInitialized) {
      // 如果已经有锁定项但还没有标记为已初始化，检查是否需要初始化
      try {
        final List<dynamic> lockedList = json.decode(lockedJson);
        final lockedItems = lockedList.map((e) => e.toString()).toSet();
        // 如果锁定列表为空，默认锁定"设置"项
        if (lockedItems.isEmpty) {
          await setLockedItems({CalculatorKeys.settings});
        }
        await prefs.setBool(initializedKey, true);
      } catch (e) {
        // 数据损坏，重置为默认
        await setLockedItems({CalculatorKeys.settings});
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
}


