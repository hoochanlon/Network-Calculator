@echo off
chcp 65001 >nul
echo ========================================
echo Flutter Windows 插件修复脚本
echo ========================================
echo.

echo [1/4] 清理项目...
call flutter clean
if %errorlevel% neq 0 (
    echo 错误: flutter clean 失败
    pause
    exit /b 1
)
echo 完成！
echo.

echo [2/4] 获取依赖包...
call flutter pub get
if %errorlevel% neq 0 (
    echo 错误: flutter pub get 失败
    pause
    exit /b 1
)
echo 完成！
echo.

echo [3/4] 重新生成插件注册文件...
call flutter pub get
if %errorlevel% neq 0 (
    echo 错误: 重新获取依赖失败
    pause
    exit /b 1
)
echo 完成！
echo.

echo [4/4] 构建 Windows 应用（调试模式）...
call flutter build windows --debug
if %errorlevel% neq 0 (
    echo 错误: 构建失败
    pause
    exit /b 1
)
echo 完成！
echo.

echo ========================================
echo 修复完成！现在可以运行应用了：
echo flutter run -d windows
echo ========================================
pause

