import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class LocaleProvider with ChangeNotifier {
  Locale? _locale; // null 表示跟随系统
  bool _followSystem = true;

  /// 获取当前实际使用的语言（如果跟随系统则返回系统语言）
  Locale get locale {
    if (_followSystem || _locale == null) {
      return _getSystemLocale();
    }
    return _locale!;
  }

  /// 获取用户设置的语言（可能为null，表示跟随系统）
  Locale? get userLocale => _locale;

  /// 是否跟随系统
  bool get followSystem => _followSystem;

  LocaleProvider() {
    _loadLocale();
  }

  /// 获取系统默认语言
  Locale _getSystemLocale() {
    final systemLocales = ui.PlatformDispatcher.instance.locales;
    if (systemLocales.isNotEmpty) {
      final systemLocale = systemLocales.first;
      // 如果系统语言是中文
      if (systemLocale.languageCode == 'zh') {
        // 如果是繁体中文地区，返回繁体中文
        if (systemLocale.countryCode == 'TW' || systemLocale.countryCode == 'HK' || systemLocale.countryCode == 'MO') {
          return const Locale('zh', 'TW');
        }
        // 其他中文地区返回简体中文
        return const Locale('zh');
      }
      // 如果系统语言是日语
      if (systemLocale.languageCode == 'ja') {
        return const Locale('ja');
      }
    }
    // 其他语言默认返回英文
    return const Locale('en');
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final followSystemSetting = prefs.getBool('follow_system_locale');
    final localeCode = prefs.getString('locale');
    
    if (followSystemSetting == false && localeCode != null) {
      // 用户明确设置了语言
      _followSystem = false;
      // 解析语言代码（支持 zh_TW 格式）
      final parts = localeCode.split('_');
      if (parts.length == 2) {
        _locale = Locale(parts[0], parts[1]);
      } else {
        _locale = Locale(localeCode);
      }
    } else {
      // 默认跟随系统
      _followSystem = true;
      _locale = null;
    }
    notifyListeners();
  }

  /// 设置语言（传入null表示跟随系统）
  Future<void> setLocale(Locale? locale) async {
    if (_locale == locale && _followSystem == (locale == null)) return;
    
    _locale = locale;
    _followSystem = locale == null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('follow_system_locale', _followSystem);
    if (locale != null) {
      // 保存完整的语言代码（包括国家代码，如 zh_TW）
      final localeString = locale.countryCode != null 
          ? '${locale.languageCode}_${locale.countryCode}'
          : locale.languageCode;
      await prefs.setString('locale', localeString);
    } else {
      await prefs.remove('locale');
    }
    
    notifyListeners();
  }
}

