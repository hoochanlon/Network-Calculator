import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorOrderNotifier extends ChangeNotifier {
  void notifyOrderChanged() {
    notifyListeners();
  }
}

class CalculatorSettingsProvider {
  static const String _keyPreserveInputs = 'preserve_calculator_inputs';
  static const String _keyCalculatorOrder = 'calculator_order';
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

  /// 获取计算器顺序
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

  /// 设置计算器顺序
  static Future<void> setCalculatorOrder(List<String> order) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCalculatorOrder, json.encode(order));
    _orderNotifier.notifyOrderChanged();
  }

  /// 重置计算器顺序为默认
  static Future<void> resetCalculatorOrder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCalculatorOrder);
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
}

