import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/color_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  ColorTheme _currentColorTheme = ColorTheme.neteaseRed;

  ThemeMode get themeMode => _themeMode;
  ColorTheme get currentColorTheme => _currentColorTheme;

  ThemeProvider() {
    _loadTheme();
    _loadColorTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('theme_mode') ?? 'dark';
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
    
    // 加载当前颜色主题
    final currentThemeId = prefs.getString('current_color_theme_id') ?? 'netease_red';
    _currentColorTheme = ColorTheme.presets.firstWhere(
      (theme) => theme.id == currentThemeId,
      orElse: () => ColorTheme.neteaseRed,
    );

    notifyListeners();
  }

  Future<void> setColorTheme(ColorTheme theme) async {
    if (_currentColorTheme.id == theme.id) return;
    _currentColorTheme = theme;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_color_theme_id', theme.id);
  }

  Future<void> resetToDefault() async {
    _currentColorTheme = ColorTheme.neteaseRed;
    
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_color_theme_id', 'netease_red');
  }
}

