#!/usr/bin/env bash
set -e

# 工程根目录
PROJECT_ROOT="$(cd "$(dirname "$0")/.."; pwd)"
APP_NAME="Network Calculator"
DMG_NAME="Network-Calculator"

cd "$PROJECT_ROOT"

echo "1) 构建 macOS Release 版本..."
flutter build macos --release

APP_PATH="$PROJECT_ROOT/build/macos/Build/Products/Release/${APP_NAME}.app"
DIST_DIR="$PROJECT_ROOT/dist"

mkdir -p "$DIST_DIR"
rm -f "$DIST_DIR/${DMG_NAME}.dmg"

echo "2) 复制 .app 到 dist 目录..."
cp -R "$APP_PATH" "$DIST_DIR/"

echo "3) 生成 DMG 安装包..."
create-dmg \
  --volname "${DMG_NAME}" \
  --window-size 800 400 \
  --icon "${APP_NAME}.app" 200 200 \
  --app-drop-link 600 200 \
  "${DIST_DIR}/${DMG_NAME}.dmg" \
  "$DIST_DIR/${APP_NAME}.app"

echo "完成：${DIST_DIR}/${DMG_NAME}.dmg"

