@echo off
chcp 65001 >nul
echo ========================================
echo Flutter Windows 符号链接修复脚本
echo ========================================
echo.

set SYMLINK_PATH=windows\flutter\ephemeral\.plugin_symlinks

echo [1/3] 删除损坏的符号链接目录...
if exist "%SYMLINK_PATH%" (
    rd /s /q "%SYMLINK_PATH%" 2>nul
    if %errorlevel% equ 0 (
        echo 已删除: %SYMLINK_PATH%
    ) else (
        echo 警告: 删除符号链接时出错，但继续执行...
    )
) else (
    echo 符号链接目录不存在，跳过删除步骤
)
echo.

echo [2/4] 删除 CMake 缓存（修复路径问题）...
if exist "build\windows" (
    rd /s /q "build\windows" 2>nul
    echo 已删除 build\windows 目录
) else (
    echo build\windows 目录不存在，跳过删除步骤
)
echo.

echo [3/4] 清理 Flutter 构建缓存...
call flutter clean
if %errorlevel% neq 0 (
    echo 错误: flutter clean 失败
    pause
    exit /b 1
)
echo 完成！
echo.

echo [4/4] 重新获取依赖并生成符号链接...
call flutter pub get
if %errorlevel% neq 0 (
    echo 错误: flutter pub get 失败
    pause
    exit /b 1
)
echo 完成！
echo.

echo ========================================
echo 修复完成！符号链接问题已解决。
echo 现在可以运行应用了：
echo   flutter run -d windows
echo 或构建应用：
echo   flutter build windows
echo ========================================
pause

