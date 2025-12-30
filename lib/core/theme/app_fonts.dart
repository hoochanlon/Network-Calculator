import 'package:flutter/foundation.dart' show kIsWeb;
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
  /// 针对桌面端和 Web 端进行了字体渲染优化
  static TextStyle createStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    // 根据平台优化字体渲染
    final List<FontFeature> fontFeatures = [
      const FontFeature.enable('kern'), // 启用字距调整
      const FontFeature.enable('liga'), // 启用连字
    ];
    
    // 桌面端添加更多字体特性（Web 端由 CSS 处理）
    if (!kIsWeb) {
      fontFeatures.add(const FontFeature.enable('dlig')); // 启用 discretionary连字
    }

    return TextStyle(
      fontFamily: primaryFontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height ?? 1.5, // 添加默认行高，改善文字可读性
      decoration: decoration,
      decorationColor: decorationColor,
      fontFeatures: fontFeatures,
      inherit: true,
      // 确保字体名称始终应用，特别是在 iOS Web 上
      package: null, // 明确指定不使用包字体
      // 桌面端优化：使用更精细的文本渲染
      // Web 端由 CSS 控制，这里不添加阴影以避免重复
      shadows: (!kIsWeb && fontSize != null && fontSize > 12) ? [
        Shadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 0.3,
          offset: const Offset(0, 0),
        ),
      ] : null,
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

