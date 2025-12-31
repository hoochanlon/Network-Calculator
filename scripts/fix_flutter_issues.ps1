# Flutter Windows 一键修复脚本
# 修复符号链接、插件注册、构建缓存等问题
# 使用方法: .\scripts\fix_flutter_issues.ps1

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Flutter Windows 一键修复脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$step = 1
$totalSteps = 6

# 步骤 1: 删除损坏的符号链接目录
Write-Host "[$step/$totalSteps] 删除损坏的符号链接目录..." -ForegroundColor Yellow
$symlinkPath = "windows\flutter\ephemeral\.plugin_symlinks"
if (Test-Path $symlinkPath) {
    try {
        Remove-Item -Path $symlinkPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  已删除: $symlinkPath" -ForegroundColor Green
    } catch {
        Write-Host "  警告: 删除符号链接时出错，但继续执行..." -ForegroundColor Yellow
    }
} else {
    Write-Host "  符号链接目录不存在，跳过" -ForegroundColor Gray
}
$step++
Write-Host ""

# 步骤 2: 删除 CMake 缓存
Write-Host "[$step/$totalSteps] 删除 CMake 缓存..." -ForegroundColor Yellow
if (Test-Path "build\windows") {
    Remove-Item -Path "build\windows" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "  已删除 build\windows 目录" -ForegroundColor Green
} else {
    Write-Host "  build\windows 目录不存在，跳过" -ForegroundColor Gray
}
$step++
Write-Host ""

# 步骤 3: 清理 Flutter 构建缓存
Write-Host "[$step/$totalSteps] 清理 Flutter 构建缓存..." -ForegroundColor Yellow
flutter clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "  错误: flutter clean 失败" -ForegroundColor Red
    Read-Host "按 Enter 键退出"
    exit 1
}
Write-Host "  完成！" -ForegroundColor Green
$step++
Write-Host ""

# 步骤 4: 获取依赖包
Write-Host "[$step/$totalSteps] 获取依赖包..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "  错误: flutter pub get 失败" -ForegroundColor Red
    Read-Host "按 Enter 键退出"
    exit 1
}
Write-Host "  完成！" -ForegroundColor Green
$step++
Write-Host ""

# 步骤 5: 重新生成插件注册文件
Write-Host "[$step/$totalSteps] 重新生成插件注册文件..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "  错误: 重新获取依赖失败" -ForegroundColor Red
    Read-Host "按 Enter 键退出"
    exit 1
}
Write-Host "  完成！" -ForegroundColor Green
$step++
Write-Host ""

# 步骤 6: 验证构建（可选，可以注释掉以加快速度）
Write-Host "[$step/$totalSteps] 验证构建配置..." -ForegroundColor Yellow
Write-Host "  跳过构建验证（如需完整验证，请取消注释构建步骤）" -ForegroundColor Gray
# flutter build windows --debug
# if ($LASTEXITCODE -ne 0) {
#     Write-Host "  警告: 构建验证失败，但基本修复已完成" -ForegroundColor Yellow
# } else {
#     Write-Host "  构建验证成功！" -ForegroundColor Green
# }
Write-Host "  完成！" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "修复完成！" -ForegroundColor Green
Write-Host ""
Write-Host "现在可以运行应用了：" -ForegroundColor Yellow
Write-Host "  flutter run -d windows" -ForegroundColor White
Write-Host ""
Write-Host "或构建应用：" -ForegroundColor Yellow
Write-Host "  flutter build windows --release" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
Read-Host "按 Enter 键退出"

