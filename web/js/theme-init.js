// 在 Flutter 启动前同步读取并应用主题和语言设置
// 避免页面加载时的闪烁问题
//
// 注意：默认值应该与 lib/core/config/app_config.dart 中的配置保持一致
// 如果修改了 AppConfig，请同步更新此文件中的默认值

(function() {
  'use strict';
  
  // ========== 默认配置（与 AppConfig 保持一致）==========
  // 注意：Web端的默认主题模式与桌面端不同
  // - 桌面端默认：浅色模式（light）
  // - Web端默认：夜间模式（dark）
  const DEFAULT_COLOR_THEME_ID = 'bilibili_pink';
  const DEFAULT_THEME_MODE = 'dark'; // Web端默认夜间模式
  const DEFAULT_THEME_COLOR = '#FF6699';
  const DARK_MODE_BACKGROUND = '#121212';
  const LIGHT_MODE_BACKGROUND = '#FFFFFF';
  // ====================================================
  
  // 同步读取 localStorage（在 Flutter 启动前执行）
  // SharedPreferences 在 Web 上使用 'flutter.' 前缀
  function getLocalStorageItem(key) {
    try {
      // 先尝试带 'flutter.' 前缀的键（Web 平台）
      const flutterKey = 'flutter.' + key;
      const value = window.localStorage.getItem(flutterKey);
      if (value !== null) {
        return value;
      }
      // 回退到不带前缀的键（兼容性）
      return window.localStorage.getItem(key);
    } catch (e) {
      return null;
    }
  }
  
  // 获取主题模式
  function getThemeMode() {
    const themeMode = getLocalStorageItem('theme_mode') || DEFAULT_THEME_MODE;
    return themeMode;
  }
  
  // 获取颜色主题ID
  function getColorThemeId() {
    return getLocalStorageItem('current_color_theme_id') || DEFAULT_COLOR_THEME_ID;
  }
  
  // 获取语言设置
  function getLocale() {
    const followSystem = getLocalStorageItem('follow_system_locale');
    
    if (followSystem === 'false') {
      const locale = getLocalStorageItem('locale');
      if (locale) {
        return locale;
      }
    }
    
    // 跟随系统：从浏览器语言获取
    const browserLang = navigator.language || navigator.userLanguage || 'en';
    return browserLang;
  }
  
  // 预设颜色主题映射
  const colorThemes = {
    'netease_red': { primary: '#EC4141' },
    'facebook_blue': { primary: '#1877F2' },
    'spotify_green': { primary: '#1DB954' },
    'qq_music_yellow': { primary: '#FFD700' },
    'bilibili_pink': { primary: '#FF6699' }
  };
  
  // 应用初始主题
  function applyInitialTheme() {
    const themeMode = getThemeMode();
    const colorThemeId = getColorThemeId();
    const colorTheme = colorThemes[colorThemeId] || colorThemes[DEFAULT_COLOR_THEME_ID];
    
    // 设置 body 的背景色和主题类
    const body = document.body;
    const html = document.documentElement;
    
    if (themeMode === 'dark') {
      body.style.backgroundColor = DARK_MODE_BACKGROUND;
      body.style.color = '#FFFFFF';
      html.setAttribute('data-theme', 'dark');
    } else {
      body.style.backgroundColor = LIGHT_MODE_BACKGROUND;
      body.style.color = '#000000';
      html.setAttribute('data-theme', 'light');
    }
    
    // 设置主题色
    html.style.setProperty('--primary-color', colorTheme.primary);
    
    // 设置 meta theme-color（用于移动端状态栏）
    let themeColorMeta = document.querySelector('meta[name="theme-color"]');
    if (!themeColorMeta) {
      themeColorMeta = document.createElement('meta');
      themeColorMeta.name = 'theme-color';
      document.head.appendChild(themeColorMeta);
    }
    themeColorMeta.content = themeMode === 'dark' ? DARK_MODE_BACKGROUND : colorTheme.primary;
  }
  
  // 应用初始语言
  function applyInitialLocale() {
    const locale = getLocale();
    if (locale) {
      document.documentElement.lang = locale.split('_')[0];
    }
  }
  
  // 立即执行（在 DOMContentLoaded 之前）
  applyInitialTheme();
  applyInitialLocale();
  
  // 在 DOMContentLoaded 时再次确保应用（防止脚本执行顺序问题）
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      applyInitialTheme();
      applyInitialLocale();
    });
  } else {
    // DOM 已经加载完成，立即应用
    applyInitialTheme();
    applyInitialLocale();
  }
})();

