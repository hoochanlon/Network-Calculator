import 'package:flutter/material.dart';
import '../../core/theme/app_fonts.dart';

/// 统一的计算器输入框组件
/// 
/// 提供统一的样式和行为，包括：
/// - 统一的文本选择控件
/// - 可配置的单行/多行输入
/// - 可配置的键盘类型
/// - 统一的装饰样式
class CalculatorTextField extends StatelessWidget {
  /// 文本控制器
  final TextEditingController controller;
  
  /// 标签文本
  final String labelText;
  
  /// 提示文本
  final String? hintText;
  
  /// 是否为多行输入
  final bool multiline;
  
  /// 最小行数（仅多行时有效）
  final int? minLines;
  
  /// 最大行数（仅多行时有效）
  final int? maxLines;
  
  /// 键盘类型
  final TextInputType? keyboardType;
  
  /// 提交回调（主要用于单行输入）
  final ValueChanged<String>? onSubmitted;
  
  /// 输入变化回调
  final ValueChanged<String>? onChanged;
  
  /// 是否启用
  final bool enabled;

  const CalculatorTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.multiline = false,
    this.minLines,
    this.maxLines,
    this.keyboardType,
    this.onSubmitted,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      ),
      maxLines: multiline ? (maxLines ?? 10) : 1,
      minLines: multiline ? (minLines ?? 5) : null,
      keyboardType: keyboardType,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      enabled: enabled,
      selectionControls: AppTextSelectionControls.customControls,
    );
  }
}

