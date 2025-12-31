import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'app_fonts.dart';
import 'custom_text_selection_controls.dart';

class AppTheme {
  // 网易云音乐风格的颜色
  static const Color defaultPrimaryColor = Color(0xFFEC4141); // 网易云红
  static const Color backgroundColor = Color(0xFF1E1E1E); // 深色背景
  static const Color surfaceColor = Color(0xFF2C2C2C); // 卡片背景
  static const Color cardColor = Color(0xFF333333); // 卡片颜色
  static const Color textPrimary = Color(0xFFFFFFFF); // 主文本
  static const Color textSecondary = Color(0xFFB3B3B3); // 次要文本
  static const Color dividerColor = Color(0xFF404040); // 分割线

  static ThemeData getDarkTheme(Color primaryColor) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppFonts.primaryFontFamily,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: textPrimary,
        selectionColor: primaryColor.withOpacity(0.3),
        selectionHandleColor: primaryColor,
      ),
      // 优化字体渲染，确保响应式文本也使用自定义字体
      typography: _createTypographyWithFont(),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
        surface: surfaceColor,
        error: const Color(0xFFE53935),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: dividerColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppFonts.createStyle(fontSize: 14),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppFonts.createStyle(color: textPrimary, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: AppFonts.createStyle(color: textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: AppFonts.createStyle(color: textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
        headlineMedium: AppFonts.createStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
        titleLarge: AppFonts.createStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        titleMedium: AppFonts.createStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w500),
        bodyLarge: AppFonts.createStyle(color: textPrimary, fontSize: 16),
        bodyMedium: AppFonts.createStyle(color: textPrimary, fontSize: 14),
        bodySmall: AppFonts.createStyle(color: textSecondary, fontSize: 12),
      ),
      dividerColor: dividerColor,
      splashColor: primaryColor.withOpacity(0.1), // 点击波纹效果颜色
      highlightColor: primaryColor.withOpacity(0.05), // 点击高亮颜色
      listTileTheme: ListTileThemeData(
        selectedTileColor: primaryColor.withOpacity(0.1), // 选中时的背景色
        selectedColor: primaryColor, // 选中时的图标和文本颜色
        iconColor: textSecondary, // 默认图标颜色
        textColor: textPrimary, // 默认文本颜色
        tileColor: Colors.transparent, // 默认背景色
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppFonts.createStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: AppFonts.createStyle(
          fontSize: 14,
          color: Colors.white, // 确保文字颜色为白色，在深色背景上可见
        ),
        backgroundColor: const Color(0xFF323232), // 深色背景
        behavior: SnackBarBehavior.floating, // 使用浮动样式，避免被遮挡
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static ThemeData getLightTheme(Color primaryColor) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppFonts.primaryFontFamily,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        labelStyle: AppFonts.createStyle(color: const Color(0xFF212121)),
        hintStyle: AppFonts.createStyle(color: const Color(0xFF757575)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      // 确保所有 TextField 的文本颜色都是深色
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: const Color(0xFF212121),
        selectionColor: primaryColor.withOpacity(0.3),
        selectionHandleColor: primaryColor,
      ),
      // 优化字体渲染，确保响应式文本也使用自定义字体
      typography: _createTypographyWithFont(),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: primaryColor,
        surface: Colors.white,
        error: const Color(0xFFE53935),
        onSurface: const Color(0xFF212121), // 输入框文本颜色
        onPrimary: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF212121),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppFonts.createStyle(fontSize: 14),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppFonts.createStyle(color: const Color(0xFF000000), fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: AppFonts.createStyle(color: const Color(0xFF000000), fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: AppFonts.createStyle(color: const Color(0xFF000000), fontSize: 24, fontWeight: FontWeight.bold),
        headlineMedium: AppFonts.createStyle(color: const Color(0xFF000000), fontSize: 20, fontWeight: FontWeight.w600),
        titleLarge: AppFonts.createStyle(color: const Color(0xFF000000), fontSize: 18, fontWeight: FontWeight.w600),
        titleMedium: AppFonts.createStyle(color: const Color(0xFF212121), fontSize: 16, fontWeight: FontWeight.w500),
        bodyLarge: AppFonts.createStyle(color: const Color(0xFF212121), fontSize: 16),
        bodyMedium: AppFonts.createStyle(color: const Color(0xFF212121), fontSize: 14),
        bodySmall: AppFonts.createStyle(color: const Color(0xFF424242), fontSize: 12),
        // 为 TextField 设置默认文本样式
        labelLarge: AppFonts.createStyle(color: const Color(0xFF212121), fontSize: 16),
      ),
      dividerColor: const Color(0xFFE0E0E0),
      splashColor: primaryColor.withOpacity(0.1), // 点击波纹效果颜色
      highlightColor: primaryColor.withOpacity(0.05), // 点击高亮颜色
      listTileTheme: ListTileThemeData(
        selectedTileColor: primaryColor.withOpacity(0.1), // 选中时的背景色
        selectedColor: primaryColor, // 选中时的图标和文本颜色
        iconColor: const Color(0xFF757575), // 默认图标颜色
        textColor: const Color(0xFF212121), // 默认文本颜色
        tileColor: Colors.transparent, // 默认背景色
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF212121)),
        titleTextStyle: AppFonts.createStyle(
          color: const Color(0xFF000000),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: AppFonts.createStyle(
          fontSize: 14,
          color: Colors.white, // 确保文字颜色为白色，在深色背景上可见
        ),
        backgroundColor: const Color(0xFF323232), // 深色背景
        behavior: SnackBarBehavior.floating, // 使用浮动样式，避免被遮挡
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // 保持向后兼容
  static ThemeData get darkTheme => getDarkTheme(defaultPrimaryColor);
  static ThemeData get lightTheme => getLightTheme(defaultPrimaryColor);

  /// 创建使用自定义字体的 Typography
  /// 确保响应式文本缩放时也使用 OPPO Sans 字体
  static Typography _createTypographyWithFont() {
    final baseTypography = Typography.material2021(
      platform: defaultTargetPlatform,
    );
    
    // 辅助函数：为 TextStyle 应用字体
    TextStyle? _applyFont(TextStyle? style) {
      return style?.copyWith(fontFamily: AppFonts.primaryFontFamily);
    }
    
    // 为所有文本样式应用自定义字体
    return Typography(
      black: TextTheme(
        displayLarge: _applyFont(baseTypography.black.displayLarge),
        displayMedium: _applyFont(baseTypography.black.displayMedium),
        displaySmall: _applyFont(baseTypography.black.displaySmall),
        headlineLarge: _applyFont(baseTypography.black.headlineLarge),
        headlineMedium: _applyFont(baseTypography.black.headlineMedium),
        headlineSmall: _applyFont(baseTypography.black.headlineSmall),
        titleLarge: _applyFont(baseTypography.black.titleLarge),
        titleMedium: _applyFont(baseTypography.black.titleMedium),
        titleSmall: _applyFont(baseTypography.black.titleSmall),
        bodyLarge: _applyFont(baseTypography.black.bodyLarge),
        bodyMedium: _applyFont(baseTypography.black.bodyMedium),
        bodySmall: _applyFont(baseTypography.black.bodySmall),
        labelLarge: _applyFont(baseTypography.black.labelLarge),
        labelMedium: _applyFont(baseTypography.black.labelMedium),
        labelSmall: _applyFont(baseTypography.black.labelSmall),
      ),
      white: TextTheme(
        displayLarge: _applyFont(baseTypography.white.displayLarge),
        displayMedium: _applyFont(baseTypography.white.displayMedium),
        displaySmall: _applyFont(baseTypography.white.displaySmall),
        headlineLarge: _applyFont(baseTypography.white.headlineLarge),
        headlineMedium: _applyFont(baseTypography.white.headlineMedium),
        headlineSmall: _applyFont(baseTypography.white.headlineSmall),
        titleLarge: _applyFont(baseTypography.white.titleLarge),
        titleMedium: _applyFont(baseTypography.white.titleMedium),
        titleSmall: _applyFont(baseTypography.white.titleSmall),
        bodyLarge: _applyFont(baseTypography.white.bodyLarge),
        bodyMedium: _applyFont(baseTypography.white.bodyMedium),
        bodySmall: _applyFont(baseTypography.white.bodySmall),
        labelLarge: _applyFont(baseTypography.white.labelLarge),
        labelMedium: _applyFont(baseTypography.white.labelMedium),
        labelSmall: _applyFont(baseTypography.white.labelSmall),
      ),
      englishLike: baseTypography.englishLike,
      dense: baseTypography.dense,
      tall: baseTypography.tall,
    );
  }
}

