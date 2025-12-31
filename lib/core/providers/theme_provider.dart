import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/color_theme.dart';
import '../config/app_config.dart';

class ThemeProvider with ChangeNotifier {
  // 使用 AppConfig 中根据平台自动选择的默认值
  ThemeMode _themeMode = AppConfig.getDefaultThemeMode();
  ColorTheme _currentColorTheme = AppConfig.defaultColorTheme;

  ThemeMode get themeMode => _themeMode;
  ColorTheme get currentColorTheme => _currentColorTheme;

  ThemeProvider() {
    // theme-init.js 已经在 HTML 中处理了初始样式，避免闪烁
    // 这里异步加载确保数据正确
    _loadTheme();
    _loadColorTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // 使用 AppConfig 中根据平台自动选择的默认值
    // SharedPreferences 在 Web 上会自动处理 'flutter.' 前缀
    final themeModeString = prefs.getString('theme_mode') ?? AppConfig.getDefaultThemeModeString();
    _themeMode = themeModeString == 'light'
        ? ThemeMode.light
        : themeModeString == 'dark'
            ? ThemeMode.dark
            : ThemeMode.system;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.toString().split('.').last);
  }

  Future<void> _loadColorTheme() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 加载当前颜色主题，使用 AppConfig 中的默认值
    // SharedPreferences 在 Web 上会自动处理 'flutter.' 前缀
    final currentThemeId = prefs.getString('current_color_theme_id') ?? AppConfig.defaultColorThemeId;
    _currentColorTheme = ColorTheme.presets.firstWhere(
      (theme) => theme.id == currentThemeId,
      orElse: () => AppConfig.defaultColorTheme,
    );

    notifyListeners();
  }

  Future<void> setColorTheme(ColorTheme theme) async {
    if (_currentColorTheme.id == theme.id) return;
    
    // 先更新状态，立即通知UI（不等待保存完成）
    _currentColorTheme = theme;
    notifyListeners();
    
    // 异步保存到本地存储，不阻塞UI
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('current_color_theme_id', theme.id);
    });
  }

  Future<void> resetToDefault() async {
    _currentColorTheme = AppConfig.defaultColorTheme;
    
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_color_theme_id', AppConfig.defaultColorThemeId);
  }
}

