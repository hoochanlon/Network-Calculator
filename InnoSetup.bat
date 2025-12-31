@echo off
chcp 65001 >nul
echo ========================================
echo Inno Setup 打包脚本 - 一键构建和打包
echo ========================================
echo.

REM 切换到脚本所在目录（项目根目录）
cd /d "%~dp0"

echo 当前工作目录: %CD%
echo.

echo 步骤 1: 检查 Flutter 构建文件...
if not exist "build\windows\x64\runner\Release\network_calculator.exe" (
    echo [提示] 未找到构建文件，开始自动构建...
    echo.
    echo 正在运行: flutter build windows --release
    echo 这可能需要几分钟时间，请耐心等待...
    echo.
    
    REM 确保在项目根目录
    if not exist "pubspec.yaml" (
        echo [错误] 未找到 pubspec.yaml 文件！
        echo 请确保脚本在项目根目录下运行。
        echo.
        pause
        exit /b 1
    )
    
    flutter build windows --release
    
    if %errorlevel% neq 0 (
        echo.
        echo [错误] Flutter 构建失败！
        echo 请检查错误信息并重试。
        echo.
        pause
        exit /b 1
    )
    
    echo.
    echo [√] Flutter 构建完成！
    echo.
) else (
    echo [√] 构建文件已存在，跳过构建步骤
    echo.
)

echo 步骤 2: 检查 Inno Setup 脚本...
if not exist "innosetup_script.iss" (
    echo [错误] 未找到 innosetup_script.iss 文件！
    pause
    exit /b 1
)

echo [√] 脚本文件已找到
echo.

echo ========================================
echo 下一步操作：
echo ========================================
echo.
echo 0. 软件在 https://github.com/jrsoftware/issrc 处下载
echo 1. 打开 Inno Setup Compiler
echo 2. 选择 File ^> Open
echo 3. 打开项目根目录下的 innosetup_script.iss
echo 4. 按 F9 编译，或点击 Build ^> Compile
echo 5. 安装程序将生成在 installer 文件夹中
echo.
pause

