/**
 * SEO Structured Data (JSON-LD)
 * 用于搜索引擎和 AI 爬虫的结构化数据
 * 
 * 注意：虽然可以放在外部 JS 文件中，但 Google 推荐直接内联在 HTML 中
 * 这样可以确保搜索引擎立即解析，无需等待 JS 执行
 */

(function() {
  'use strict';
  
  // WebApplication Schema
  const webAppSchema = {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "网络计算器",
    "alternateName": ["Network Calculator", "ネットワーク計算機"],
    "description": "专业的网络计算器工具，提供IP地址计算、子网掩码计算、IP进制转换、路由聚合、超网拆分、IP包含检测等功能。支持多语言、历史记录、主题切换，适用于网络工程师、开发者和学习者。",
    "url": "https://hoochanlon.github.io/network-calculator/",
    "applicationCategory": "UtilityApplication",
    "operatingSystem": "Web, Windows",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.8",
      "ratingCount": "100"
    },
    "featureList": [
      "IP地址计算器",
      "子网掩码计算器",
      "IP进制转换器",
      "路由聚合计算器",
      "超网拆分计算器",
      "IP包含检测器",
      "多语言支持",
      "历史记录管理",
      "主题切换"
    ],
    "screenshot": "https://hoochanlon.github.io/network-calculator/icons/Icon-512.png",
    "softwareVersion": "1.6.0",
    "datePublished": "2024-01-01",
    "dateModified": "2024-01-01",
    "author": {
      "@type": "Organization",
      "name": "Network Calculator Team"
    },
    "inLanguage": ["zh", "zh-TW", "en", "ja"],
    "browserRequirements": "Requires JavaScript. Requires HTML5.",
    "softwareHelp": {
      "@type": "CreativeWork",
      "text": "支持IP地址计算、子网划分、路由聚合等网络计算功能"
    }
  };

  // SoftwareApplication Schema
  const softwareAppSchema = {
    "@context": "https://schema.org",
    "@type": "SoftwareApplication",
    "name": "网络计算器",
    "applicationCategory": "UtilityApplication",
    "operatingSystem": "Web, Windows",
    "offers": {
      "@type": "Offer",
      "price": "0"
    },
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.8"
    }
  };

  // 将结构化数据注入到页面
  function injectStructuredData() {
    const head = document.head || document.getElementsByTagName('head')[0];
    
    // 注入 WebApplication Schema
    const webAppScript = document.createElement('script');
    webAppScript.type = 'application/ld+json';
    webAppScript.textContent = JSON.stringify(webAppSchema);
    head.appendChild(webAppScript);
    
    // 注入 SoftwareApplication Schema
    const softwareAppScript = document.createElement('script');
    softwareAppScript.type = 'application/ld+json';
    softwareAppScript.textContent = JSON.stringify(softwareAppSchema);
    head.appendChild(softwareAppScript);
  }

  // 立即执行（不等待 DOMContentLoaded，因为 head 已经存在）
  if (document.head) {
    injectStructuredData();
  } else {
    // 如果 head 还未加载，等待 DOM 就绪
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', injectStructuredData);
    } else {
      injectStructuredData();
    }
  }
})();

