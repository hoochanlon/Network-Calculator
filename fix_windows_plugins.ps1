# Flutter Windows 插件修复脚本 (PowerShell 版本)
# 使用方法: .\fix_windows_plugins.ps1

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Flutter Windows 插件修复脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/4] 清理项目..." -ForegroundColor Yellow
flutter clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "错误: flutter clean 失败" -ForegroundColor Red
    Read-Host "按 Enter 键退出"
    exit 1
}
Write-Host "完成！" -ForegroundColor Green
Write-Host ""

Write-Host "[2/4] 获取依赖包..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "错误: flutter pub get 失败" -ForegroundColor Red
    Read-Host "按 Enter 键退出"
    exit 1
}
Write-Host "完成！" -ForegroundColor Green
Write-Host ""

Write-Host "[3/4] 重新生成插件注册文件..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "错误: 重新获取依赖失败" -ForegroundColor Red
    Read-Host "按 Enter 键退出"
    exit 1
}
Write-Host "完成！" -ForegroundColor Green
Write-Host ""

Write-Host "[4/4] 构建 Windows 应用（调试模式）..." -ForegroundColor Yellow
flutter build windows --debug
if ($LASTEXITCODE -ne 0) {
    Write-Host "错误: 构建失败" -ForegroundColor Red
    Read-Host "按 Enter 键退出"
    exit 1
}
Write-Host "完成！" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "修复完成！现在可以运行应用了：" -ForegroundColor Green
Write-Host "flutter run -d windows" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Read-Host "按 Enter 键退出"

