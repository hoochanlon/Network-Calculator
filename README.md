# 网络计算器 (Network Calculator)

![](./assets/images/demo/2025-12-31-12-17-06.png)

一个现代化的网络计算器应用，提供专业的 IP 地址计算、子网划分、路由聚合等功能，采用 Flutter 开发，支持 Windows 桌面和 Web 平台。

**语言 / Language / げんご**: [简体中文](README.md) | [English](README_EN.md) | [日本語](README_JA.md)

![Version](https://img.shields.io/badge/version-1.6.0-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## ✨ 功能特性

程序设计思路见：[Architecture-Diagrams](./docs/Architecture-Diagrams.md)

### 核心计算功能

- **IP 地址计算器** - 计算 IP 地址的网络信息、广播地址、可用主机数等
- **子网掩码计算器** - 根据主机数或子网掩码计算网络参数，支持二进制和十六进制显示
- **IP 进制转换器** - IP 地址在二进制、十进制、十六进制之间的转换
- **路由聚合计算器** - 合并多个子网为 CIDR 地址块，支持两种聚合算法
- **超网拆分计算器** - 将大地址块拆分为多个小网段
- **IP 包含检测器** - 检测 IP 地址或网段是否包含在另一个网段中

### 用户体验

- 🎨 **现代化 UI** - 采用网页文档风格界面设计
- 🌓 **主题切换** - 支持亮色/暗色主题，多种颜色主题可选
- 🌍 **多语言支持** - 简体中文、繁体中文、英文、日文
- 📝 **历史记录** - 自动保存计算历史，支持搜索、导入、导出
- 🔄 **状态保存** - 自动保存输入状态，切换页面不丢失数据
- 📱 **响应式设计** - 适配不同屏幕尺寸，侧边栏宽度自适应
- 🎯 **侧边栏排序** - 支持拖拽排序和项目锁定功能



## 🚀 快速开始

### 1. 克隆项目，安装依赖

```bash
git clone <repository-url> && cd Network-Calculator
flutter clean && flutter pub get
```

### 2. 运行项目

**桌面版 (Windows):**

```bash
flutter run -d windows
```

**Web 版:**

```bash
flutter run -d chrome
```

### 3. 常见问题修复

如果遇到 Windows 平台相关问题（符号链接错误、插件注册失败、构建缓存问题等），可以使用一键修复脚本：

**PowerShell (推荐):**

```powershell
.\scripts\fix_flutter_issues.ps1
```

该脚本会自动执行以下修复步骤：

- 删除损坏的符号链接目录
- 清理 CMake 缓存
- 清理 Flutter 构建缓存
- 重新获取依赖包
- 重新生成插件注册文件
- 验证构建配置

修复完成后即可正常运行应用。


## 📦 发布

### 1. 可执行程序制作

**构建 Windows 桌面应用:**

```bash
flutter build windows --release
```

运行如下批处理，查看 InnoSetup 打包成安装版说明

```powershell
InnoSetup.bat
```

运行如下批处理，查看 Enigma Virtual Box 打包成单个程序说明

```powershell
EnigmaVirtualBox.bat
```

### 2. web 部署

**构建 Web 应用:**
```bash
flutter build web --release
```

1. Setting > Pages > Build and deployment > Action 
2. 发布到 Github Pages

    ```bash
    # 见 Github Action 部署代码
    cat .github/deploy.yml
    ```


