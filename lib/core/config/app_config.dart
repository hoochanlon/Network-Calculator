import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/color_theme.dart';

/// 应用默认配置
/// 集中管理默认主题、颜色、窗口大小、历史记录等设置，方便统一修改
class AppConfig {
  AppConfig._(); // 私有构造函数，防止实例化

  // ========== 主题和颜色配置 ==========
  
  /// 默认颜色主题
  /// 修改这里可以统一更改应用的默认颜色主题
  static const ColorTheme defaultColorTheme = ColorTheme.bilibiliPink;
  
  /// 默认颜色主题ID（用于存储和Web初始化）
  static const String defaultColorThemeId = 'bilibili_pink';
  
  // ========== 主题模式配置（按平台区分）==========
  
  /// 桌面端默认主题模式（浅色/深色/跟随系统）
  /// 注意：桌面端（Windows、macOS、Linux）使用此配置
  static const ThemeMode defaultDesktopThemeMode = ThemeMode.light;
  
  /// 桌面端默认主题模式字符串（用于存储）
  static const String defaultDesktopThemeModeString = 'light';
  
  /// Web端默认主题模式（浅色/深色/跟随系统）
  /// 注意：Web平台使用此配置
  static const ThemeMode defaultWebThemeMode = ThemeMode.dark;
  
  /// Web端默认主题模式字符串（用于存储）
  static const String defaultWebThemeModeString = 'dark';
  
  /// 获取当前平台的默认主题模式
  /// 根据运行平台自动返回桌面端或Web端的默认值
  static ThemeMode getDefaultThemeMode() {
    return kIsWeb ? defaultWebThemeMode : defaultDesktopThemeMode;
  }
  
  /// 获取当前平台的默认主题模式字符串
  /// 根据运行平台自动返回桌面端或Web端的默认值
  static String getDefaultThemeModeString() {
    return kIsWeb ? defaultWebThemeModeString : defaultDesktopThemeModeString;
  }
  
  // ========== 已废弃的配置（保留以保持向后兼容）==========
  
  /// @deprecated 使用 [getDefaultThemeMode()] 代替
  /// 原来的统一默认主题模式，现在已按平台分开设置
  /// 桌面端：使用 [defaultDesktopThemeMode]
  /// Web端：使用 [defaultWebThemeMode]
  @Deprecated('使用 getDefaultThemeMode() 代替，已按平台分开设置')
  static const ThemeMode defaultThemeMode = ThemeMode.light;
  
  /// @deprecated 使用 [getDefaultThemeModeString()] 代替
  /// 原来的统一默认主题模式字符串，现在已按平台分开设置
  /// 桌面端：使用 [defaultDesktopThemeModeString]
  /// Web端：使用 [defaultWebThemeModeString]
  @Deprecated('使用 getDefaultThemeModeString() 代替，已按平台分开设置')
  static const String defaultThemeModeString = 'light';
  
  /// 默认主题色（用于Web meta标签等）
  /// 应该与 defaultColorTheme 的 primaryColor 保持一致
  static const String defaultThemeColor = '#FF6699';
  
  /// 深色模式背景色
  static const String darkModeBackgroundColor = '#121212';
  
  /// 浅色模式背景色
  static const String lightModeBackgroundColor = '#FFFFFF';
  
  // ========== 语言配置 ==========
  
  /// 默认语言是否跟随系统
  static const bool defaultFollowSystemLocale = true;
  
  // ========== 窗口大小配置 ==========
  
  /// 默认窗口宽度（像素）
  static const double defaultWindowWidth = 800.0;
  
  /// 默认窗口高度（像素）
  static const double defaultWindowHeight = 700.0;
  
  /// 最小窗口宽度（像素）
  static const double minWindowWidth = 800.0;
  
  /// 最小窗口高度（像素）
  static const double minWindowHeight = 700.0;
  
  // ========== 历史记录配置 ==========
  
  /// 默认历史记录数量限制
  static const int defaultHistoryLimit = 8000;
  
  /// 历史记录最小限制
  static const int minHistoryLimit = 10;
  
  /// 历史记录最大限制
  static const int maxHistoryLimit = 100000;
  
  // ========== 数据存储配置 ==========
  
  /// 历史记录存储目录名称（相对于应用文档目录）
  static const String historyStorageDirectoryName = 'network_calculator';
  
  /// 历史记录文件名
  static const String historyFileName = 'history.json';
  
  /// Web 平台存储提示文本
  static const String webStorageText = 'Web Storage';
}

