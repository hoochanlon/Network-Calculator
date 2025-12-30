import 'package:flutter/material.dart';

/// 统一的计算器操作按钮组件
/// 
/// 提供统一的样式和加载状态显示
class CalculatorActionButton extends StatelessWidget {
  /// 按钮文本
  final String text;
  
  /// 点击回调
  final VoidCallback? onPressed;
  
  /// 是否正在加载
  final bool isLoading;
  
  /// 按钮样式（可选）
  final ButtonStyle? style;

  const CalculatorActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style ??
          ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            minimumSize: const Size(100, 48),
          ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(text),
    );
  }
}

/// 统一的计算器清除按钮组件
/// 
/// 提供统一的样式
class CalculatorClearButton extends StatelessWidget {
  /// 按钮文本
  final String text;
  
  /// 点击回调
  final VoidCallback? onPressed;
  
  /// 按钮样式（可选）
  final ButtonStyle? style;

  const CalculatorClearButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: style ??
          OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            minimumSize: const Size(100, 48),
            side: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
      child: Text(text),
    );
  }
}

/// 统一的按钮行组件
/// 
/// 包含操作按钮和清除按钮，提供统一的布局
class CalculatorButtonRow extends StatelessWidget {
  /// 操作按钮文本
  final String actionText;
  
  /// 清除按钮文本
  final String clearText;
  
  /// 操作按钮点击回调
  final VoidCallback? onActionPressed;
  
  /// 清除按钮点击回调
  final VoidCallback? onClearPressed;
  
  /// 是否正在加载
  final bool isLoading;
  
  /// 按钮间距
  final double spacing;

  const CalculatorButtonRow({
    super.key,
    required this.actionText,
    required this.clearText,
    this.onActionPressed,
    this.onClearPressed,
    this.isLoading = false,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CalculatorActionButton(
            text: actionText,
            onPressed: onActionPressed,
            isLoading: isLoading,
          ),
          SizedBox(width: spacing),
          CalculatorClearButton(
            text: clearText,
            onPressed: onClearPressed,
          ),
        ],
      ),
    );
  }
}

