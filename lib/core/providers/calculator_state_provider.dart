import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'calculator_settings_provider.dart';

/// 计算器状态提供者
/// 用于保存和恢复每个计算器的输入和结果
class CalculatorStateProvider with ChangeNotifier {
  static const String _keyPrefix = 'calculator_state_';
  
  // 各个计算器的状态
  final Map<String, Map<String, dynamic>> _states = {};
  
  /// 获取指定计算器的状态
  Future<Map<String, dynamic>?> getState(String calculatorKey) async {
    // 先检查设置是否启用保留功能
    final preserveInputs = await CalculatorSettingsProvider.getPreserveInputs();
    if (!preserveInputs) {
      // 如果未启用，清除内存中的状态
      _states.remove(calculatorKey);
      return null;
    }
    
    // 检查内存中的状态
    if (_states.containsKey(calculatorKey)) {
      return _states[calculatorKey];
    }
    
    // 从 SharedPreferences 加载
    try {
      final prefs = await SharedPreferences.getInstance();
      final stateJson = prefs.getString('$_keyPrefix$calculatorKey');
      if (stateJson != null) {
        final state = json.decode(stateJson) as Map<String, dynamic>;
        _states[calculatorKey] = Map<String, dynamic>.from(state);
        return _states[calculatorKey];
      }
    } catch (e) {
      // 忽略错误
    }
    
    return null;
  }
  
  /// 保存指定计算器的状态
  Future<void> saveState(String calculatorKey, Map<String, dynamic> state) async {
    // 检查设置是否启用保留功能
    final preserveInputs = await CalculatorSettingsProvider.getPreserveInputs();
    if (!preserveInputs) {
      // 如果未启用，清除内存和持久化中的状态
      _states.remove(calculatorKey);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_keyPrefix$calculatorKey');
      return;
    }
    
    // 保存到内存
    _states[calculatorKey] = state;
    
    // 保存到 SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_keyPrefix$calculatorKey', json.encode(state));
    } catch (e) {
      // 忽略错误
    }
  }
  
  /// 清除指定计算器的状态
  Future<void> clearState(String calculatorKey) async {
    _states.remove(calculatorKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_keyPrefix$calculatorKey');
  }
  
  /// 清除所有计算器的状态
  Future<void> clearAllStates() async {
    _states.clear();
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_keyPrefix)) {
        await prefs.remove(key);
      }
    }
    // 通知所有监听者状态已清除
    notifyListeners();
  }
  
  /// 通知状态已变化（用于外部触发刷新）
  void notifyStateChanged() {
    notifyListeners();
  }
}

