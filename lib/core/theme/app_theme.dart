import 'package:flutter/material.dart';

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
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
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
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: textPrimary, fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'OPPOSans'),
        displayMedium: TextStyle(color: textPrimary, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'OPPOSans'),
        displaySmall: TextStyle(color: textPrimary, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'OPPOSans'),
        headlineMedium: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'OPPOSans'),
        titleLarge: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'OPPOSans'),
        titleMedium: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'OPPOSans'),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16, fontFamily: 'OPPOSans'),
        bodyMedium: TextStyle(color: textPrimary, fontSize: 14, fontFamily: 'OPPOSans'),
        bodySmall: TextStyle(color: textSecondary, fontSize: 12, fontFamily: 'OPPOSans'),
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
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'OPPOSans',
        ),
      ),
    );
  }

  static ThemeData getLightTheme(Color primaryColor) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
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
        labelStyle: const TextStyle(color: Color(0xFF212121), fontFamily: 'OPPOSans'),
        hintStyle: const TextStyle(color: Color(0xFF757575), fontFamily: 'OPPOSans'),
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
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xFF212121),
        selectionColor: Color(0xFFEC4141),
        selectionHandleColor: Color(0xFFEC4141),
      ),
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
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: const Color(0xFF000000), fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'OPPOSans'),
        displayMedium: TextStyle(color: const Color(0xFF000000), fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'OPPOSans'),
        displaySmall: TextStyle(color: const Color(0xFF000000), fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'OPPOSans'),
        headlineMedium: TextStyle(color: const Color(0xFF000000), fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'OPPOSans'),
        titleLarge: TextStyle(color: const Color(0xFF000000), fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'OPPOSans'),
        titleMedium: TextStyle(color: const Color(0xFF212121), fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'OPPOSans'),
        bodyLarge: TextStyle(color: const Color(0xFF212121), fontSize: 16, fontFamily: 'OPPOSans'),
        bodyMedium: TextStyle(color: const Color(0xFF212121), fontSize: 14, fontFamily: 'OPPOSans'),
        bodySmall: TextStyle(color: const Color(0xFF424242), fontSize: 12, fontFamily: 'OPPOSans'),
        // 为 TextField 设置默认文本样式
        labelLarge: TextStyle(color: const Color(0xFF212121), fontSize: 16, fontFamily: 'OPPOSans'),
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
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF212121)),
        titleTextStyle: TextStyle(
          color: Color(0xFF000000),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'OPPOSans',
        ),
      ),
    );
  }

  // 保持向后兼容
  static ThemeData get darkTheme => getDarkTheme(defaultPrimaryColor);
  static ThemeData get lightTheme => getLightTheme(defaultPrimaryColor);
}

