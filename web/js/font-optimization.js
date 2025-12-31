/**
 * 字体和 Canvas 渲染优化脚本
 * 针对 iOS Safari 和高 DPR 设备进行优化
 */

(function() {
  'use strict';
  
  // iOS 设备检测
  const isIOS = /iPad|iPhone|iPod/.test(navigator.userAgent) || 
                (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1);
  
  /**
   * 字体加载检测和强制应用（iOS Safari 需要）
   * 优化：使用 requestIdleCallback 避免阻塞主线程
   */
  function ensureFontLoaded() {
    if (document.fonts && document.fonts.check) {
      // 使用 requestIdleCallback 延迟执行，避免阻塞渲染
      const scheduleFontLoad = function() {
        if (window.requestIdleCallback) {
          window.requestIdleCallback(function() {
            loadFonts();
          }, { timeout: 2000 });
        } else {
          // 降级方案：使用 setTimeout
          setTimeout(loadFonts, 100);
        }
      };
      
      const loadFonts = function() {
        // 只加载当前需要的字重，减少初始加载时间
        const fontWeights = ['400', '500'];
        const loadPromises = fontWeights.map(function(weight) {
          return document.fonts.load(weight + ' 1em OPPOSans');
        });
        
        Promise.all(loadPromises).then(function() {
          // iOS 上需要强制重新渲染
          if (isIOS) {
            document.body.style.fontFamily = 'OPPOSans, -apple-system, sans-serif';
            // 使用 requestAnimationFrame 优化重绘
            requestAnimationFrame(function() {
              // 重新优化所有 Canvas
              optimizeCanvases();
            });
          }
        }).catch(function(err) {
          console.warn('Font load failed:', err);
        });
      };
      
      scheduleFontLoad();
    }
  }
  
  /**
   * 优化 Canvas 字体渲染（针对 CanvasKit）
   */
  function optimizeCanvases() {
    const canvases = document.querySelectorAll('canvas');
    const dpr = window.devicePixelRatio || 1;
    
    canvases.forEach(function(canvas) {
      const ctx = canvas.getContext('2d');
      if (ctx) {
        // 针对高 DPR 设备优化 Canvas 尺寸
        if (dpr >= 2) {
          const rect = canvas.getBoundingClientRect();
          // 确保 Canvas 在高 DPR 设备上使用正确的尺寸
          if (canvas.width !== rect.width * dpr || canvas.height !== rect.height * dpr) {
            canvas.width = rect.width * dpr;
            canvas.height = rect.height * dpr;
            ctx.scale(dpr, dpr);
          }
        }
        
        // 启用 Canvas 的高质量图像平滑
        ctx.imageSmoothingEnabled = true;
        ctx.imageSmoothingQuality = 'high';
        
        // 优化文本渲染
        ctx.textBaseline = 'alphabetic';
        ctx.textAlign = 'left';
        
        // iOS 特定优化 - 高 DPR 设备字体渲染优化
        if (isIOS) {
          // 根据设备像素比调整字体渲染
          ctx.font = '14px OPPOSans, -apple-system, sans-serif';
          
          // 高 DPR 设备使用更高质量的渲染
          if (dpr >= 2) {
            ctx.imageSmoothingEnabled = true;
            ctx.imageSmoothingQuality = 'high';
            
            // 针对超高 DPR（3x）设备
            if (dpr >= 3) {
              // 使用最高质量渲染设置
              ctx.imageSmoothingEnabled = true;
              ctx.imageSmoothingQuality = 'high';
              // 确保文本渲染清晰
              ctx.textRenderingOptimization = 'optimizeQuality';
            }
          }
          
          // 强制重新绘制以确保优化生效
          canvas.style.willChange = 'contents';
        }
      }
    });
  }
  
  /**
   * 初始化优化
   * 优化：大幅延迟非关键优化，优先保证首屏渲染性能
   */
  function initOptimizations() {
    // 延迟所有优化操作，避免阻塞首屏渲染
    const delayOptimization = function() {
      if (window.requestIdleCallback) {
        window.requestIdleCallback(function() {
          optimizeCanvases();
          ensureFontLoaded();
        }, { timeout: 3000 }); // 延迟到 3 秒后，确保首屏已渲染
      } else {
        // 降级方案：延迟更长时间
        setTimeout(function() {
          optimizeCanvases();
          ensureFontLoaded();
        }, 2000);
      }
    };
    
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', delayOptimization);
    } else {
      delayOptimization();
    }
    
    // Flutter 初始化后再次优化（使用 MutationObserver 监听 Canvas 创建）
    // 使用防抖优化，大幅降低检查频率，减少性能开销
    let observerTimeout;
    let lastCheckTime = 0;
    const CHECK_INTERVAL = 2000; // 从 200ms 增加到 2 秒，大幅减少检查频率
    
    const observer = new MutationObserver(function(mutations) {
      const now = Date.now();
      // 限制检查频率，避免频繁触发
      if (now - lastCheckTime < CHECK_INTERVAL) {
        return;
      }
      lastCheckTime = now;
      
      clearTimeout(observerTimeout);
      observerTimeout = setTimeout(function() {
        if (window.requestIdleCallback) {
          window.requestIdleCallback(optimizeCanvases, { timeout: 1000 });
        } else {
          setTimeout(optimizeCanvases, 500);
        }
        // iOS 上定期检查字体应用（大幅降低频率）
        if (isIOS && Math.random() < 0.05) { // 从 10% 降低到 5%
          if (window.requestIdleCallback) {
            window.requestIdleCallback(ensureFontLoaded, { timeout: 1000 });
          } else {
            setTimeout(ensureFontLoaded, 500);
          }
        }
      }, 500); // 增加防抖延迟
    });
    
    // 观察 body 的变化，以便捕获动态创建的 Canvas
    if (document.body) {
      observer.observe(document.body, {
        childList: true,
        subtree: true
      });
    } else {
      window.addEventListener('load', function() {
        if (document.body) {
          observer.observe(document.body, {
            childList: true,
            subtree: true
          });
        }
        // 延迟执行
        if (window.requestIdleCallback) {
          window.requestIdleCallback(ensureFontLoaded);
        } else {
          setTimeout(ensureFontLoaded, 200);
        }
      });
    }
    
    // iOS 上额外等待 Flutter 初始化（大幅延迟执行，避免影响性能）
    if (isIOS) {
      window.addEventListener('load', function() {
        // 延迟到页面完全加载后 3 秒再执行，确保不影响用户体验
        if (window.requestIdleCallback) {
          window.requestIdleCallback(function() {
            ensureFontLoaded();
            optimizeCanvases();
          }, { timeout: 5000 }); // 从 1 秒增加到 5 秒
        } else {
          setTimeout(function() {
            ensureFontLoaded();
            optimizeCanvases();
          }, 3000); // 从 500ms 增加到 3 秒
        }
      });
    }
  }
  
  // 大幅延迟初始化，避免阻塞首屏渲染
  // 使用 requestIdleCallback 确保在浏览器空闲时执行
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      // 延迟执行，确保首屏渲染完成
      if (window.requestIdleCallback) {
        window.requestIdleCallback(initOptimizations, { timeout: 2000 });
      } else {
        setTimeout(initOptimizations, 1000);
      }
    });
  } else {
    // 如果 DOM 已加载，延迟执行
    if (window.requestIdleCallback) {
      window.requestIdleCallback(initOptimizations, { timeout: 2000 });
    } else {
      setTimeout(initOptimizations, 1000);
    }
  }
})();

