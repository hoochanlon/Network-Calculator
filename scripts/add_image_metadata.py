#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
图片元数据管理脚本
支持分别设置/删除 Comment、Description、Source、URL 字段
支持 JPEG (EXIF) 和 PNG (文本块) 格式
完全支持中文
"""

import os
import sys
from pathlib import Path
from PIL import Image
from PIL.PngImagePlugin import PngInfo

# 修复 Windows 控制台编码问题
if sys.platform == 'win32':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
        sys.stderr.reconfigure(encoding='utf-8')
    except:
        os.environ['PYTHONIOENCODING'] = 'utf-8'
    
    # 启用 Windows ANSI 颜色支持（Windows 10 1607+ 和 Windows Terminal）
    try:
        import ctypes
        from ctypes import wintypes
        kernel32 = ctypes.windll.kernel32
        STD_OUTPUT_HANDLE = -11
        ENABLE_VIRTUAL_TERMINAL_PROCESSING = 0x0004
        
        handle = kernel32.GetStdHandle(STD_OUTPUT_HANDLE)
        mode = wintypes.DWORD()
        if kernel32.GetConsoleMode(handle, ctypes.byref(mode)):
            mode.value |= ENABLE_VIRTUAL_TERMINAL_PROCESSING
            kernel32.SetConsoleMode(handle, mode)
    except:
        pass

try:
    import piexif
    HAS_PIEXIF = True
except ImportError:
    HAS_PIEXIF = False
    print("警告: 未安装 piexif 库，JPEG 的 EXIF 处理可能受限。")
    print("建议安装: pip install piexif")


def read_metadata(image_path):
    """
    读取图片的元数据
    返回字典: {'Comment': '', 'Description': '', 'Source': '', 'URL': ''}
    """
    image_path = Path(image_path)
    metadata = {'Comment': '', 'Description': '', 'Source': '', 'URL': ''}
    
    try:
        ext = image_path.suffix.lower()
        
        if ext in ['.jpg', '.jpeg']:
            # JPEG - 读取 EXIF
            if HAS_PIEXIF:
                try:
                    exif_dict = piexif.load(str(image_path))
                    # 读取 UserComment
                    if "Exif" in exif_dict and piexif.ExifIFD.UserComment in exif_dict["Exif"]:
                        user_comment = exif_dict["Exif"][piexif.ExifIFD.UserComment]
                        if isinstance(user_comment, bytes):
                            if user_comment.startswith(b"UNICODE\0"):
                                metadata['Comment'] = user_comment[8:].decode('utf-8', errors='ignore')
                            else:
                                metadata['Comment'] = user_comment.decode('utf-8', errors='ignore')
                    
                    # 读取 ImageDescription
                    if "0th" in exif_dict and piexif.ImageIFD.ImageDescription in exif_dict["0th"]:
                        desc = exif_dict["0th"][piexif.ImageIFD.ImageDescription]
                        if isinstance(desc, bytes):
                            metadata['Description'] = desc.decode('utf-8', errors='ignore')
                except:
                    pass
        elif ext == '.png':
            # PNG - 读取文本块
            try:
                img = Image.open(image_path)
                if hasattr(img, 'text') and img.text:
                    for key in ['Comment', 'Description', 'Source', 'URL']:
                        if key in img.text:
                            metadata[key] = img.text[key]
            except:
                pass
    except Exception as e:
        print(f"[WARN] 读取元数据时出错: {e}")
    
    return metadata


def update_metadata_jpeg(image_path, metadata):
    """
    更新 JPEG 图片的 EXIF 元数据
    metadata: {'Comment': '', 'Description': '', 'Source': '', 'URL': ''}
    """
    try:
        if HAS_PIEXIF:
            exif_dict = {}
            
            # 读取现有 EXIF 数据
            try:
                exif_dict = piexif.load(str(image_path))
            except:
                exif_dict = {"0th": {}, "Exif": {}, "GPS": {}, "1st": {}, "thumbnail": None}
            
            # 确保必要的字典存在
            if "Exif" not in exif_dict:
                exif_dict["Exif"] = {}
            if "0th" not in exif_dict:
                exif_dict["0th"] = {}
            
            # 更新 Comment (UserComment)
            if metadata['Comment']:
                unicode_comment = b"UNICODE\0" + metadata['Comment'].encode('utf-8')
                exif_dict["Exif"][piexif.ExifIFD.UserComment] = unicode_comment
            else:
                # 删除 Comment
                exif_dict["Exif"].pop(piexif.ExifIFD.UserComment, None)
            
            # 更新 Description (ImageDescription)
            if metadata['Description']:
                exif_dict["0th"][piexif.ImageIFD.ImageDescription] = metadata['Description'].encode('utf-8')
            else:
                exif_dict["0th"].pop(piexif.ImageIFD.ImageDescription, None)
            
            # 注意：JPEG EXIF 不支持 Source 和 URL 字段，我们使用其他字段存储
            # 使用 Artist 存储 Source
            if metadata['Source']:
                exif_dict["0th"][piexif.ImageIFD.Artist] = metadata['Source'].encode('utf-8')
            else:
                exif_dict["0th"].pop(piexif.ImageIFD.Artist, None)
            
            # 使用 Copyright 存储 URL
            if metadata['URL']:
                exif_dict["0th"][piexif.ImageIFD.Copyright] = metadata['URL'].encode('utf-8')
            else:
                exif_dict["0th"].pop(piexif.ImageIFD.Copyright, None)
            
            # 清理空的字典
            if not exif_dict["Exif"]:
                exif_dict.pop("Exif", None)
            if not exif_dict["0th"]:
                exif_dict.pop("0th", None)
            
            exif_bytes = piexif.dump(exif_dict) if exif_dict.get("0th") or exif_dict.get("Exif") else None
            
            img = Image.open(image_path)
            img.save(image_path, exif=exif_bytes, quality=95)
            return True
        else:
            # 使用 PIL 的基础方法
            img = Image.open(image_path)
            exif = img.getexif()
            
            if metadata['Description']:
                exif[0x010E] = metadata['Description']
            else:
                exif.pop(0x010E, None)
            
            img.save(image_path, exif=exif, quality=95)
            return True
            
    except Exception as e:
        print(f"[ERROR] 更新 JPEG 元数据时出错: {e}")
        return False


def update_metadata_png(image_path, metadata):
    """
    更新 PNG 图片的文本元数据
    metadata: {'Comment': '', 'Description': '', 'Source': '', 'URL': ''}
    """
    try:
        img = Image.open(image_path)
        pnginfo = PngInfo()
        
        # 检查是否有非 ASCII 字符
        has_non_ascii = any(any(ord(c) > 127 for c in value) for value in metadata.values() if value)
        
        # 添加或更新各个字段
        for key, value in metadata.items():
            if value:
                # 有值则添加
                try:
                    if has_non_ascii:
                        pnginfo.add_text(key, value, zip=True)
                    else:
                        pnginfo.add_text(key, value)
                except:
                    # 如果失败，尝试不压缩
                    try:
                        pnginfo.add_text(key, value)
                    except:
                        pass
            # 如果值为空，不添加到 pnginfo 中，即删除该字段
        
        img.save(image_path, pnginfo=pnginfo, format='PNG', optimize=False)
        return True
        
    except Exception as e:
        print(f"[ERROR] 更新 PNG 元数据时出错: {e}")
        return False


def update_metadata(image_path, metadata):
    """
    更新图片元数据
    metadata: {'Comment': '', 'Description': '', 'Source': '', 'URL': ''}
    """
    image_path = Path(image_path)
    
    if not image_path.exists():
        print(f"[ERROR] 文件不存在: {image_path}")
        return False
    
    ext = image_path.suffix.lower()
    
    if ext in ['.jpg', '.jpeg']:
        return update_metadata_jpeg(image_path, metadata)
    elif ext == '.png':
        return update_metadata_png(image_path, metadata)
    else:
        print(f"[ERROR] 不支持的图片格式: {ext}")
        return False


def select_file_gui():
    """
    使用图形界面选择文件
    """
    try:
        import tkinter as tk
        from tkinter import filedialog
        
        root = tk.Tk()
        root.withdraw()
        root.attributes('-topmost', True)
        
        file_path = filedialog.askopenfilename(
            title="选择图片文件",
            filetypes=[
                ("图片文件", "*.jpg *.jpeg *.png *.JPG *.JPEG *.PNG"),
                ("JPEG 文件", "*.jpg *.jpeg *.JPG *.JPEG"),
                ("PNG 文件", "*.png *.PNG"),
                ("所有文件", "*.*")
            ]
        )
        root.destroy()
        return file_path if file_path else None
    except ImportError:
        print("[ERROR] 需要 tkinter 库，请安装: pip install tk")
        return None
    except Exception as e:
        print(f"[ERROR] 图形界面选择失败: {e}")
        return None


# ANSI 颜色代码和样式
class Colors:
    """ANSI 颜色和样式代码"""
    # 基础重置
    RESET = '\033[0m'
    
    # 文本样式
    BOLD = '\033[1m'
    DIM = '\033[2m'
    ITALIC = '\033[3m'
    UNDERLINE = '\033[4m'
    BLINK = '\033[5m'
    REVERSE = '\033[7m'
    HIDDEN = '\033[8m'
    
    # 前景色 - 标准
    BLACK = '\033[30m'
    RED = '\033[31m'
    GREEN = '\033[32m'
    YELLOW = '\033[33m'
    BLUE = '\033[34m'
    MAGENTA = '\033[35m'
    CYAN = '\033[36m'
    WHITE = '\033[37m'
    
    # 前景色 - 明亮
    BRIGHT_BLACK = '\033[90m'
    BRIGHT_RED = '\033[91m'
    BRIGHT_GREEN = '\033[92m'
    BRIGHT_YELLOW = '\033[93m'
    BRIGHT_BLUE = '\033[94m'
    BRIGHT_MAGENTA = '\033[95m'
    BRIGHT_CYAN = '\033[96m'
    BRIGHT_WHITE = '\033[97m'
    
    # 背景色 - 标准
    BG_BLACK = '\033[40m'
    BG_RED = '\033[41m'
    BG_GREEN = '\033[42m'
    BG_YELLOW = '\033[43m'
    BG_BLUE = '\033[44m'
    BG_MAGENTA = '\033[45m'
    BG_CYAN = '\033[46m'
    BG_WHITE = '\033[47m'
    
    # 背景色 - 明亮
    BG_BRIGHT_BLACK = '\033[100m'
    BG_BRIGHT_RED = '\033[101m'
    BG_BRIGHT_GREEN = '\033[102m'
    BG_BRIGHT_YELLOW = '\033[103m'
    BG_BRIGHT_BLUE = '\033[104m'
    BG_BRIGHT_MAGENTA = '\033[105m'
    BG_BRIGHT_CYAN = '\033[106m'
    BG_BRIGHT_WHITE = '\033[107m'


def supports_color():
    """检测终端是否支持颜色"""
    if sys.platform == 'win32':
        try:
            import ctypes
            from ctypes import wintypes
            kernel32 = ctypes.windll.kernel32
            handle = kernel32.GetStdHandle(-11)
            mode = wintypes.DWORD()
            if kernel32.GetConsoleMode(handle, ctypes.byref(mode)):
                return bool(mode.value & 0x0004)  # ENABLE_VIRTUAL_TERMINAL_PROCESSING
            return False
        except:
            return False
    else:
        return True  # Linux/Mac 通常支持


SUPPORTS_COLOR = supports_color()





def colorize(text, color_code):
    """为文本添加颜色（如果支持）"""
    if SUPPORTS_COLOR:
        return f"{color_code}{text}{Colors.RESET}"
    return text


def print_header(title):
    """打印标题"""
    print()
    print(colorize(f"| {title}", Colors.BRIGHT_CYAN + Colors.BOLD))
    print()


def print_section(title):
    """打印章节标题"""
    print()
    print(colorize(f"| {title}", Colors.CYAN + Colors.BOLD))
    print()


def print_success(msg):
    """打印成功消息"""
    print(colorize(f" [OK] {msg}", Colors.BRIGHT_GREEN + Colors.BOLD))


def print_error(msg):
    """打印错误消息"""
    print(colorize(f" [ERROR] {msg}", Colors.BRIGHT_RED + Colors.BOLD))


def print_info(msg):
    """打印信息消息"""
    print(colorize(f" [INFO] {msg}", Colors.BRIGHT_CYAN))


def print_warning(msg):
    """打印警告消息"""
    print(colorize(f" [WARN] {msg}", Colors.BRIGHT_YELLOW + Colors.BOLD))


def print_tip(msg):
    """打印提示消息"""
    print(colorize(f" [TIP] {msg}", Colors.MAGENTA))


def get_user_input(prompt, default=None, allow_empty=False):
    """获取用户输入"""
    default_text = f" [默认: {default}]" if default else ""
    full_prompt = colorize(f"{prompt}{default_text}: ", Colors.BRIGHT_CYAN + Colors.BOLD)
    
    while True:
        user_input = input(full_prompt).strip()
        if not user_input:
            if default:
                return default
            elif allow_empty:
                return ""
            else:
                print_error("输入不能为空，请重新输入")
                continue
        return user_input


def display_metadata(metadata):
    """显示当前元数据"""
    print_section("当前元数据")
    
    field_config = {
        'Comment': Colors.BRIGHT_CYAN,
        'Description': Colors.BRIGHT_BLUE,
        'Source': Colors.BRIGHT_MAGENTA,
        'URL': Colors.BRIGHT_YELLOW
    }
    
    for key, value in metadata.items():
        color = field_config.get(key, Colors.WHITE)
        field_name = colorize(key, color + Colors.BOLD)
        display_value = value if value else colorize("(空)", Colors.DIM)
        print(colorize(f"| {field_name}: {display_value}", color))


def main():
    """
    主函数 - 交互式元数据管理
    """
    print_header("图片元数据管理工具")
    
    # 1. 选择文件
    print_info("请选择图片文件...")
    file_path = select_file_gui()
    
    if not file_path:
        print_warning("未选择文件，已退出")
        return
    
    file_path = Path(file_path)
    
    # 显示文件信息
    print_section("文件信息")
    
    file_size = file_path.stat().st_size
    if file_size >= 1024 * 1024:
        file_size_str = f"{file_size / (1024 * 1024):.2f} MB"
    elif file_size >= 1024:
        file_size_str = f"{file_size / 1024:.2f} KB"
    else:
        file_size_str = f"{file_size} B"
    
    file_type = file_path.suffix.upper()[1:] if file_path.suffix else "未知"
    
    details = [
        ("文件路径", str(file_path)),
        ("文件名", file_path.name),
        ("文件大小", file_size_str),
        ("文件类型", file_type),
        ("文件位置", str(file_path.parent))
    ]
    
    for label, value in details:
        print(colorize(f"| {label}: {value}", Colors.BRIGHT_CYAN))
    
    print_success("文件已成功加载！")
    
    # 2. 读取现有元数据
    metadata = read_metadata(file_path)
    
    # 主循环
    while True:
        display_metadata(metadata)
        
        print_section("操作菜单")
        
        # 设置操作组
        print(colorize("| 设置操作", Colors.BRIGHT_CYAN + Colors.BOLD))
        menu_items = [
            ("1", "设置 Comment", Colors.BRIGHT_CYAN),
            ("2", "设置 Description", Colors.BRIGHT_BLUE),
            ("3", "设置 Source", Colors.BRIGHT_MAGENTA),
            ("4", "设置 URL", Colors.BRIGHT_YELLOW),
        ]
        for key, desc, color in menu_items:
            print(colorize(f"|   {key}. {desc}", color))
        
        # 删除操作组
        print(colorize("| 删除操作", Colors.BRIGHT_CYAN + Colors.BOLD))
        menu_items = [
            ("5", "删除 Comment", Colors.BRIGHT_RED),
            ("6", "删除 Description", Colors.BRIGHT_RED),
            ("7", "删除 Source", Colors.BRIGHT_RED),
            ("8", "删除 URL", Colors.BRIGHT_RED),
            ("9", "删除所有元数据", Colors.BRIGHT_RED + Colors.BOLD),
        ]
        for key, desc, color in menu_items:
            print(colorize(f"|   {key}. {desc}", color))
        
        # 快捷操作组
        print(colorize("| 快捷操作", Colors.BRIGHT_CYAN + Colors.BOLD))
        menu_items = [
            ("d", "快捷添加 Description", Colors.BRIGHT_GREEN),
            ("s", "保存并退出", Colors.BRIGHT_GREEN + Colors.BOLD),
            ("q", "退出（不保存）", Colors.DIM),
        ]
        for key, desc, color in menu_items:
            print(colorize(f"|   {key}. {desc}", color))
        
        print()
        
        choice = get_user_input("请选择操作选项", allow_empty=False).lower()
        
        if choice == '1':
            # 设置 Comment
            value = get_user_input("请输入 Comment", allow_empty=True)
            metadata['Comment'] = value
            if value:
                print_success(f"Comment 已设置为: {colorize(value, Colors.CYAN)}")
            else:
                print_success("Comment 已清空")
        
        elif choice == '2':
            # 设置 Description
            value = get_user_input("请输入 Description", allow_empty=True)
            metadata['Description'] = value
            if value:
                print_success(f"Description 已设置为: {colorize(value, Colors.BLUE)}")
            else:
                print_success("Description 已清空")
        
        elif choice == '3':
            # 设置 Source
            value = get_user_input("请输入 Source", allow_empty=True)
            metadata['Source'] = value
            if value:
                print_success(f"Source 已设置为: {colorize(value, Colors.MAGENTA)}")
            else:
                print_success("Source 已清空")
        
        elif choice == '4':
            # 设置 URL
            value = get_user_input("请输入 URL", allow_empty=True)
            metadata['URL'] = value
            if value:
                print_success(f"URL 已设置为: {colorize(value, Colors.YELLOW)}")
            else:
                print_success("URL 已清空")
        
        elif choice == '5':
            # 删除 Comment
            metadata['Comment'] = ''
            print_success("Comment 已删除")
        
        elif choice == '6':
            # 删除 Description
            metadata['Description'] = ''
            print_success("Description 已删除")
        
        elif choice == '7':
            # 删除 Source
            metadata['Source'] = ''
            print_success("Source 已删除")
        
        elif choice == '8':
            # 删除 URL
            metadata['URL'] = ''
            print_success("URL 已删除")
        
        elif choice == '9':
            # 删除所有元数据
            print_warning("此操作将删除所有元数据！")
            confirm = get_user_input("确认删除? (y/n)", default="n")
            if confirm.lower() == 'y':
                metadata = {'Comment': '', 'Description': '', 'Source': '', 'URL': ''}
                print_success("所有元数据已清空")
            else:
                print_info("操作已取消")
        
        elif choice == 'd':
            # 快捷添加 Description
            value = get_user_input("请输入 Description", allow_empty=False)
            metadata['Description'] = value
            print_success(f"Description 已设置为: {colorize(value, Colors.GREEN)}")
        
        elif choice == 's':
            # 保存并退出
            print()
            print_info("正在保存元数据...")
            if update_metadata(file_path, metadata):
                print_success(f"元数据已成功保存到: {colorize(str(file_path), Colors.CYAN)}")
                print()
                print_section("提示信息")
                print(colorize("| 可以使用以下工具查看元数据:", Colors.CYAN))
                exifinfo_url = colorize("https://exifinfo.org", Colors.BLUE)
                print(colorize(f"| 在线工具: {exifinfo_url}", Colors.CYAN))
            else:
                print_error("保存失败")
            break
        
        elif choice == 'q':
            # 退出不保存
            print_warning("未保存的更改将丢失！")
            confirm = get_user_input("确认退出? (y/n)", default="n")
            if confirm.lower() == 'y':
                print_info("已退出，未保存更改")
                break
            else:
                print_info("操作已取消")
        
        else:
            print_error(f"无效的选项: {choice}")


if __name__ == "__main__":
    main()
