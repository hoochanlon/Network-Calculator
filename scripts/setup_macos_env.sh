#!/usr/bin/env bash

##
## macOS 一键环境初始化脚本（除 Homebrew 和 Xcode 外）
## 用途：在新 Mac 上为本项目准备 Flutter / CocoaPods / 打包工具等依赖
##
## 使用方法：
##   cd /Users/chanlonhoo/Documents/GitHub/network-calculator
##   chmod +x scripts/setup_macos_env.sh
##   ./scripts/setup_macos_env.sh
##

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.."; pwd)"
cd "$PROJECT_ROOT"

echo "==> 1. 检查 Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  echo "错误：未检测到 Homebrew，请先手动安装：https://brew.sh"
  exit 1
fi

echo "==> 2. 检查 Xcode / Xcode Command Line Tools..."
if ! xcode-select -p >/dev/null 2>&1; then
  echo "提示：未检测到 Xcode Command Line Tools，将尝试安装..."
  echo "会弹出系统安装窗口，请按提示操作完成后重新运行本脚本。"
  xcode-select --install || true
  exit 0
fi

echo "==> 3. 安装 / 更新 Flutter（通过 Homebrew）..."
if ! command -v flutter >/dev/null 2>&1; then
  brew install --cask flutter
else
  echo "Flutter 已安装，跳过安装步骤。"
fi

echo "==> 4. 启用 macOS 桌面支持..."
flutter config --enable-macos-desktop || true

echo "==> 5. 安装 CocoaPods..."
if ! command -v pod >/dev/null 2>&1; then
  brew install cocoapods
  pod setup
else
  echo "CocoaPods 已安装，跳过安装步骤。"
fi

echo "==> 6. 安装 DMG 打包工具 create-dmg..."
if ! command -v create-dmg >/dev/null 2>&1; then
  brew install create-dmg
else
  echo "create-dmg 已安装，跳过安装步骤。"
fi

echo "==> 7. 为脚本添加执行权限..."
chmod +x "$PROJECT_ROOT/scripts/build_macos_dmg.sh" || true

echo "==> 8. 安装 Flutter 依赖..."
flutter clean
flutter pub get

echo
echo "全部完成 ✅"
echo "接下来可以："
echo "  1）运行调试版：flutter run -d macos"
echo "  2）一键打包 DMG：scripts/build_macos_dmg.sh"

