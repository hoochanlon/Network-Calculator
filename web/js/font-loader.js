/**
 * 字体主动加载脚本
 * 在语言切换时立即加载字体，减少"豆腐块"显示时间
 */

(function() {
  'use strict';
  
  // 字体家族名称（与 CSS 中定义的保持一致）
  const FONT_FAMILIES = ['OPPO Sans 4.0', 'OPPOSans'];
  
  /**
   * 主动加载字体
   * 使用 document.fonts.load API 强制加载字体
   */
  function loadFonts() {
    if (!document.fonts || !document.fonts.load) {
      return Promise.resolve();
    }
    
    // 加载常用字重
    const fontWeights = ['400', '500', '600', '700'];
    const loadPromises = [];
    
    FONT_FAMILIES.forEach(function(fontFamily) {
      fontWeights.forEach(function(weight) {
        // 加载字体
        loadPromises.push(
          document.fonts.load(weight + ' 1em "' + fontFamily + '"')
            .catch(function(err) {
              console.warn('Font load failed:', fontFamily, weight, err);
            })
        );
      });
    });
    
    return Promise.all(loadPromises);
  }
  
  /**
   * 检查字体是否已加载
   */
  function checkFontsLoaded() {
    if (!document.fonts || !document.fonts.check) {
      return false;
    }
    
    // 检查主要字重是否已加载
    return document.fonts.check('400 1em "OPPO Sans 4.0"') ||
           document.fonts.check('400 1em "OPPOSans"');
  }
  
  /**
   * 强制应用字体（针对 Flutter 视图）
   */
  function applyFonts() {
    // 确保 Flutter 视图使用正确的字体
    const flutterViews = document.querySelectorAll('flutter-view');
    flutterViews.forEach(function(view) {
      // 触发字体重新计算
      const style = window.getComputedStyle(view);
      view.style.fontFamily = style.fontFamily;
    });
    
    // 强制重新渲染
    if (document.body) {
      document.body.style.fontFamily = document.body.style.fontFamily;
    }
  }
  
  /**
   * 初始化字体加载
   */
  function initFontLoader() {
    // 立即尝试加载字体
    loadFonts().then(function() {
      applyFonts();
      
      // 通知字体已加载
      window.dispatchEvent(new CustomEvent('fontsloaded'));
    });
    
    // 监听语言变化（通过 lang-sync.js 触发）
    window.addEventListener('languagechanged', function() {
      // 语言切换时立即加载字体
      loadFonts().then(function() {
        applyFonts();
      });
    });
    
    // 监听 localStorage 变化（语言设置变化）
    window.addEventListener('storage', function(e) {
      if (e.key === 'flutter.locale' || e.key === 'flutter.follow_system_locale') {
        // 延迟一小段时间，确保语言已更新
        setTimeout(function() {
          loadFonts().then(function() {
            applyFonts();
          });
        }, 100);
      }
    });
    
    // 定期检查字体加载状态（用于检测语言切换）
    let lastLocale = localStorage.getItem('flutter.locale');
    setInterval(function() {
      const currentLocale = localStorage.getItem('flutter.locale');
      if (currentLocale !== lastLocale) {
        lastLocale = currentLocale;
        // 语言变化，立即加载字体
        loadFonts().then(function() {
          applyFonts();
        });
      }
    }, 500); // 每 500ms 检查一次
    
    // 监听 Flutter 应用初始化完成
    if (window.flutter) {
      window.flutter.addEventListener('appready', function() {
        loadFonts().then(function() {
          applyFonts();
        });
      });
    }
  }
  
  // 在 DOM 加载完成后初始化
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initFontLoader);
  } else {
    // 立即初始化
    initFontLoader();
  }
  
  // 页面可见性变化时重新加载字体（从后台返回时）
  document.addEventListener('visibilitychange', function() {
    if (!document.hidden && !checkFontsLoaded()) {
      loadFonts().then(function() {
        applyFonts();
      });
    }
  });
})();

