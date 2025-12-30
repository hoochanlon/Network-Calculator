import 'package:flutter/material.dart';
import 'custom_text_selection_controls.dart';

/// 全局字体配置
/// 统一管理应用中使用的字体，方便全局控制和修改
class AppFonts {
  /// 主字体家族名称
  static const String primaryFontFamily = 'OPPOSans';

  /// 获取带字体的文本样式
  /// 
  /// 为给定的文本样式添加主字体家族
  static TextStyle? withFont(TextStyle? style) {
    if (style == null) return null;
    return style.copyWith(fontFamily: primaryFontFamily);
  }

  /// 创建带字体的文本样式
  /// 
  /// 创建一个新的文本样式，包含主字体家族和其他指定属性
  static TextStyle createStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }

  /// 为文本样式添加字体（如果还没有设置）
  /// 
  /// 如果样式已经有字体，则保持不变；否则添加主字体
  static TextStyle ensureFont(TextStyle style) {
    if (style.fontFamily != null && style.fontFamily!.isNotEmpty) {
      return style;
    }
    return style.copyWith(fontFamily: primaryFontFamily);
  }

  /// 获取主题文本样式并应用字体
  /// 
  /// 从主题中获取文本样式，并确保使用主字体
  static TextStyle? getThemedTextStyle(
    BuildContext context,
    TextStyle? Function(TextTheme) textStyleGetter,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final style = textStyleGetter(textTheme);
    return withFont(style);
  }
}

/// 文本选择控件辅助类
/// 提供简洁的文本选择控件（仅包含全选和复制）
class AppTextSelectionControls {
  /// 简洁的文本选择控件实例
  /// 仅包含"全选"和"复制"功能，使用 OPPO Sans 字体
  static final customControls = CustomTextSelectionControls();
}

