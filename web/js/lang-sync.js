/**
 * 语言标识同步脚本
 * 根据 Flutter 应用的语言设置动态更新 HTML lang 属性
 * 这样 CSS 的 :lang() 选择器才能正确工作
 */

(function() {
  'use strict';
  
  // 语言代码映射：Flutter Locale -> HTML lang 属性
  const localeMap = {
    'zh': 'zh',
    'zh_HK': 'zh-HK',
    'zh-HK': 'zh-HK',
    'zh_TW': 'zh-HK',
    'zh-TW': 'zh-HK',
    'en': 'en',
    'ja': 'ja'
  };
  
  // 缓存当前语言，避免不必要的 DOM 更新
  let currentLang = null;
  
  /**
   * 从 localStorage 读取语言设置并更新 HTML lang 属性
   * Flutter SharedPreferences 在 Web 上使用 'flutter.' 前缀
   * 优化：只在语言真正改变时才更新 DOM
   */
  function updateHtmlLang() {
    try {
      // Flutter SharedPreferences 在 Web 上的键名格式
      // 检查是否跟随系统
      const followSystem = localStorage.getItem('flutter.follow_system_locale');
      const localeKey = localStorage.getItem('flutter.locale');
      
      let localeCode = null;
      let shouldUseSystem = followSystem === 'true' || followSystem === null;
      
      if (!shouldUseSystem && localeKey) {
        // 用户明确设置了语言
        localeCode = localeKey;
      } else if (shouldUseSystem) {
        // 跟随系统：从浏览器语言设置获取（缓存 navigator.language，避免重复访问）
        const browserLang = navigator.language || navigator.userLanguage;
        if (browserLang) {
          localeCode = browserLang.replace('-', '_');
        }
      }
      
      // 确定目标语言
      let targetLang = 'zh'; // 默认语言
      if (localeCode) {
        // 处理格式：可能是 "zh_HK" 或 "zh-HK" 或 "zh"（兼容历史的 zh_TW/zh-TW，统一映射为 zh-HK）
        const normalized = localeCode.replace('_', '-');
        targetLang = localeMap[localeCode] || localeMap[normalized] || normalized.split('-')[0];
      }
      
      // 只在语言真正改变时才更新 DOM（性能优化）
      if (targetLang && targetLang !== currentLang) {
        currentLang = targetLang;
        
        // 批量更新 DOM，减少重排
        if (document.documentElement.lang !== targetLang) {
          document.documentElement.lang = targetLang;
        }
        
        // 同时更新 body 的 lang 属性（如果存在）
        if (document.body && document.body.lang !== targetLang) {
          document.body.lang = targetLang;
        }
        
        // 触发语言变化事件，通知字体加载器立即加载字体
        window.dispatchEvent(new CustomEvent('languagechanged', {
          detail: { lang: targetLang }
        }));
      }
    } catch (e) {
      // 生产环境可以移除 console.warn，减少性能开销
      if (console && console.warn) {
        console.warn('Failed to update HTML lang attribute:', e);
      }
    }
  }
  
  /**
   * 防抖函数：避免频繁执行
   */
  function debounce(func, wait) {
    let timeout;
    return function() {
      clearTimeout(timeout);
      timeout = setTimeout(func, wait);
    };
  }
  
  /**
   * 使用 requestIdleCallback 优化非关键操作
   */
  function scheduleUpdate(callback, delay) {
    if (window.requestIdleCallback) {
      window.requestIdleCallback(callback, { timeout: delay || 1000 });
    } else {
      setTimeout(callback, delay || 100);
    }
  }
  
  /**
   * 监听 localStorage 变化（当 Flutter 更新语言设置时）
   * 优化：减少不必要的检查和执行
   */
  function initLangSync() {
    let lastLocale = null;
    let intervalId = null;
    
    // 优化的更新函数：只在真正需要时才执行
    const optimizedUpdate = debounce(function() {
      const currentLocale = localStorage.getItem('flutter.locale');
      const currentFollowSystem = localStorage.getItem('flutter.follow_system_locale');
      const currentState = (currentLocale || '') + '_' + (currentFollowSystem || '');
      
      // 只在状态真正改变时才更新
      if (currentState !== lastLocale) {
        lastLocale = currentState;
        scheduleUpdate(updateHtmlLang, 50);
      }
    }, 100);
    
    // 初始更新（使用 requestIdleCallback 避免阻塞渲染）
    scheduleUpdate(function() {
      updateHtmlLang();
      // 初始化 lastLocale
      const currentLocale = localStorage.getItem('flutter.locale');
      const currentFollowSystem = localStorage.getItem('flutter.follow_system_locale');
      lastLocale = (currentLocale || '') + '_' + (currentFollowSystem || '');
    }, 500);
    
    // 监听 storage 事件（跨标签页同步，性能开销很小）
    window.addEventListener('storage', function(e) {
      if (e.key && (e.key === 'flutter.locale' || e.key === 'flutter.follow_system_locale')) {
        scheduleUpdate(updateHtmlLang, 50);
      }
    });
    
    // 定期检查（作为备用方案，因为同标签页的 localStorage 变化不会触发 storage 事件）
    // 优化：增加间隔到 2 秒，减少检查频率
    // 使用 requestIdleCallback 确保不影响主线程
    function startPolling() {
      if (intervalId) return; // 避免重复启动
      
      intervalId = setInterval(function() {
        // 使用 requestIdleCallback 延迟执行，避免阻塞
        if (window.requestIdleCallback) {
          window.requestIdleCallback(optimizedUpdate, { timeout: 100 });
        } else {
          optimizedUpdate();
        }
      }, 2000); // 从 1 秒改为 2 秒，减少检查频率
    }
    
    // 延迟启动轮询，避免影响初始加载
    scheduleUpdate(startPolling, 2000);
    
    // 监听 DOM 变化，当 Flutter 应用加载后再次检查
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', function() {
        scheduleUpdate(updateHtmlLang, 1000);
      });
    } else {
      scheduleUpdate(updateHtmlLang, 1000);
    }
    
    // 页面加载完成后再次检查（使用 requestIdleCallback）
    window.addEventListener('load', function() {
      scheduleUpdate(updateHtmlLang, 2000);
    });
    
    // 页面隐藏时停止轮询，显示时恢复（节省资源）
    document.addEventListener('visibilitychange', function() {
      if (document.hidden) {
        if (intervalId) {
          clearInterval(intervalId);
          intervalId = null;
        }
      } else {
        if (!intervalId) {
          startPolling();
        }
        // 页面重新可见时立即检查一次
        scheduleUpdate(updateHtmlLang, 100);
      }
    });
  }
  
  // 初始化语言同步
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initLangSync);
  } else {
    initLangSync();
  }
})();

