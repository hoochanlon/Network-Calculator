# Flutter Windows 符号链接修复脚本
# 使用方法: .\fix_symlink_issue.ps1

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Flutter Windows 符号链接修复脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$symlinkPath = "windows\flutter\ephemeral\.plugin_symlinks"

# 检查并删除损坏的符号链接目录
if (Test-Path $symlinkPath) {
    Write-Host "[1/3] 删除损坏的符号链接目录..." -ForegroundColor Yellow
    try {
        Remove-Item -Path $symlinkPath -Recurse -Force
        Write-Host "已删除: $symlinkPath" -ForegroundColor Green
    } catch {
        Write-Host "警告: 删除符号链接时出错，但继续执行..." -ForegroundColor Yellow
        Write-Host $_.Exception.Message -ForegroundColor Gray
    }
} else {
    Write-Host "[1/3] 符号链接目录不存在，跳过删除步骤" -ForegroundColor Gray
}
Write-Host ""

# 删除 CMake 缓存（修复路径问题）
Write-Host "[2/4] 删除 CMake 缓存（修复路径问题）..." -ForegroundColor Yellow
if (Test-Path "build\windows") {
    Remove-Item -Path "build\windows" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "已删除 build\windows 目录" -ForegroundColor Green
} else {
    Write-Host "build\windows 目录不存在，跳过删除步骤" -ForegroundColor Gray
}
Write-Host ""

# 清理 Flutter 构建缓存
Write-Host "[3/4] 清理 Flutter 构建缓存..." -ForegroundColor Yellow
flutter clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "错误: flutter clean 失败" -ForegroundColor Red
    Read-Host "按 Enter 键退出"
    exit 1
}
Write-Host "完成！" -ForegroundColor Green
Write-Host ""

# 重新获取依赖并生成符号链接
Write-Host "[4/4] 重新获取依赖并生成符号链接..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "错误: flutter pub get 失败" -ForegroundColor Red
    Read-Host "按 Enter 键退出"
    exit 1
}
Write-Host "完成！" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "修复完成！符号链接问题已解决。" -ForegroundColor Green
Write-Host "现在可以运行应用了：" -ForegroundColor Yellow
Write-Host "  flutter run -d windows" -ForegroundColor White
Write-Host "或构建应用：" -ForegroundColor Yellow
Write-Host "  flutter build windows" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
Read-Host "按 Enter 键退出"

