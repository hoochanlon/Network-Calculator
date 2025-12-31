@echo off
setlocal enabledelayedexpansion

:: ============================================
:: 配置区域
:: ============================================
set "IMAGE_PATH=.\assets\images\demo\2025-12-31.png"
set "SCRIPT_PATH=.\scripts\add_image_metadata.py"
set "TITLE=Enigma Virtual Box SOP"

:: 设置 UTF-8 编码
chcp 65001 >nul 2>&1
title %TITLE%

:: 启用 ANSI 颜色支持（必须在最开始执行）
>nul 2>&1 (
    reg add "HKCU\Console" /v VirtualTerminalLevel /t REG_DWORD /d 1 /f
)

:: ============================================
:: 颜色定义（Windows 10+ 支持）
:: ============================================
:: 使用 PowerShell 输出 ANSI 转义字符
for /f %%a in ('powershell -Command "[char]27"') do set "ESC=%%a"
set "RESET=%ESC%[0m"
set "BOLD=%ESC%[1m"
set "RED=%ESC%[31m"
set "GREEN=%ESC%[32m"
set "YELLOW=%ESC%[33m"
set "BLUE=%ESC%[34m"
set "CYAN=%ESC%[36m"
set "MAGENTA=%ESC%[35m"

:: ============================================
:: 主程序
:: ============================================
call :print_header "Enigma Virtual Box 打包工具"
echo.

call :print_section "主要功能"
call :print_text "使用 Enigma Virtual Box 将项目打包成单个可执行文件"
echo.

call :print_section "核心操作步骤"
call :print_numbered "查看操作指南" "打开 %IMAGE_PATH%"
call :print_numbered "按照图片说明" "使用 Enigma Virtual Box 进行打包"
echo.

call :print_section "快速开始"
call :print_text "直接查看图片说明：双击打开 %IMAGE_PATH%"
call :print_text "或按任意键让程序打开..."
echo.

call :print_separator
call :pause_with_message "按任意键继续..." "nul"

:: 打开图片文件
call :open_image_file

echo.
call :print_separator
call :print_section "附加功能"
call :print_text "图片元数据配置工具（可选）"
echo.
call :print_text "脚本位置：%SCRIPT_PATH%"
call :print_text "功能说明：用于编辑图片的元数据信息"
call :print_text "使用场景：仅当需要编辑图片信息时才使用"
echo.

call :print_separator
call :pause_with_message "按任意键查看脚本详情（可选）..." "nul"

:: 显示脚本详情
call :show_script_details

echo.
call :print_separator
call :print_text "说明结束。按任意键退出..."
pause >nul

endlocal
exit /b 0

:: ============================================
:: 函数定义
:: ============================================


:print_header
setlocal
echo %CYAN%%BOLD%============================================%RESET%
echo %CYAN%%BOLD%      %~1%RESET%
echo %CYAN%%BOLD%============================================%RESET%
endlocal
exit /b

:print_section
setlocal
echo %CYAN%%BOLD%【%~1】%RESET%
endlocal
exit /b

:print_separator
echo %CYAN%============================================%RESET%
exit /b

:print_text
setlocal enabledelayedexpansion
set "text=%~1"
echo %YELLOW%  !text!%RESET%
endlocal
exit /b

:print_numbered
setlocal
set "num=%~1"
set "text=%~2"
echo %GREEN%  %num%.%RESET% %text%
endlocal
exit /b

:pause_with_message
setlocal enabledelayedexpansion
set "msg=%~1"
set "redirect=%~2"
if "!redirect!"=="" set "redirect=con"
echo %MAGENTA%!msg!%RESET%
pause >!redirect!
endlocal
exit /b

:open_image_file
setlocal enabledelayedexpansion
if exist "%IMAGE_PATH%" (
    echo.
    set "msg1=正在打开图片说明文件..."
    set "msg2=已打开图片说明，请按照图示操作！"
    echo %GREEN%[INFO]%RESET% !msg1!
    timeout /t 1 /nobreak >nul 2>&1
    start "" "%IMAGE_PATH%"
    echo %GREEN%[OK]%RESET% !msg2!
) else (
    echo.
    set "msg3=找不到图片说明文件！"
    set "msg4=请手动检查路径："
    echo %RED%[ERROR]%RESET% !msg3!
    echo %YELLOW%[WARN]%RESET% !msg4!%IMAGE_PATH%
)
endlocal
exit /b

:show_script_details
setlocal enabledelayedexpansion
call :print_separator
call :print_section "图片元数据脚本详情"
echo.
set "msg1=文件："
set "msg2=功能："
set "msg3=类型："
set "msg4=可选功能，用于编辑图片的元数据信息"
set "msg5=附加工具 / 小贴士 / 额外功能"
set "msg6=这不是打包的必要步骤！"
set "msg7=仅当您需要编辑图片信息时才使用此功能。"
echo %BLUE%!msg1!%RESET%%SCRIPT_PATH%
echo %BLUE%!msg2!%RESET%!msg4!
echo %BLUE%!msg3!%RESET%!msg5!
echo.
call :print_section "使用方式"
call :print_numbered "确保已安装 Python" "检查 Python 环境"
call :print_numbered "安装依赖" "pip install Pillow piexif"
call :print_numbered "运行 python 脚本" "%SCRIPT_PATH%"
call :print_numbered "图片元数据查询" "https://exifinfo.org/"
echo.
set "notice=这不是打包的必要步骤！"
set "tip=仅当您需要编辑图片信息时才使用此功能。"
echo %YELLOW%[注意]%RESET% !notice!
echo %YELLOW%[提示]%RESET% !tip!
call :print_separator
endlocal
exit /b
