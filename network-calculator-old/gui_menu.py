# gui_menu.py
import tkinter as tk
from tkinter import messagebox
import webbrowser
import os
import sys
from PIL import Image, ImageTk, ImageDraw


def show_word():
    # 获取资源文件路径
    if hasattr(sys, '_MEIPASS'):  # 如果是打包后的环境
        current_dir = sys._MEIPASS
    else:
        Desktop_dir = os.path.join(os.path.expanduser("~"), "Desktop")
        current_dir = os.path.join(Desktop_dir, "Network-Calculator")

    doc_path = os.path.join(current_dir, "docs", "开发日志.txt")

    # 创建新的Toplevel窗口
    word_window = tk.Toplevel()
    word_window.title("开发日志")
    word_window.geometry("600x600")
    word_window.resizable(False, False)

    try:
        if os.path.exists(doc_path):
            with open(doc_path, 'r', encoding='utf-8') as file:
                content = file.read()

            # 创建滚动条和只读文本框
            scroll_bar = tk.Scrollbar(word_window)
            scroll_bar.pack(side=tk.RIGHT, fill=tk.Y)

            # 设置字体大小
            font_settings = ("仿宋", 11)  # 字体名称和大小

            text_area = tk.Text(word_window, wrap=tk.WORD, yscrollcommand=scroll_bar.set, state='normal', font=font_settings)
            text_area.insert(tk.END, content)
            text_area.config(state='disabled')  # 禁用编辑
            text_area.pack(expand=True, fill=tk.BOTH)

            scroll_bar.config(command=text_area.yview)
        else:
            raise FileNotFoundError(f"未找到文档: {doc_path}")
    except Exception as e:
        print(f"文档加载失败: {e}")
        messagebox.showerror("错误", f"无法加载文档: {e}")



def show_about():
    # 创建新的Toplevel窗口
    about_window = tk.Toplevel()
    about_window.title("关于")

    # 设置窗口大小
    about_window.geometry("330x500")  # 增加一些高度以便容纳头像
    # 防止窗口被调整大小
    about_window.resizable(False, False)

    # 获取资源文件路径
    if hasattr(sys, '_MEIPASS'):  # 如果是打包后的环境
        current_dir = sys._MEIPASS
    else:
        Desktop_dir = os.path.join(os.path.expanduser("~"), "Desktop")
        current_dir = os.path.join(Desktop_dir, "Network-Calculator")

    # 图标路径
    email_img_path = os.path.join(current_dir, "images", "p5r.png")  
    github_img_path = os.path.join(current_dir, "images", "github.png")  
    wechat_img_path = os.path.join(current_dir, "images", "wechat.png")  
    avatar_path = os.path.join(current_dir, "images", "avatar.png")  
    
    # 加载邮箱图标
    try:
        email_img = Image.open(email_img_path)  # 加载拼接后的路径
        email_img = email_img.resize((70, 40))  # 调整图片大小
        email_img_tk = ImageTk.PhotoImage(email_img)  # 转换为Tkinter可识别的格式
    except Exception as e:
        print(f"邮箱图标加载失败: {e}")
        email_img_tk = None  # 如果图片加载失败，则不显示图片

    # 加载GitHub图标
    try:
        github_img = Image.open(github_img_path)  # 加载拼接后的路径
        github_img = github_img.resize((40, 40))  # 调整图片大小
        github_img_tk = ImageTk.PhotoImage(github_img)  # 转换为Tkinter可识别的格式
    except Exception as e:
        print(f"GitHub图标加载失败: {e}")
        github_img_tk = None  # 如果图片加载失败，则不显示图片

    # 加载wechat图标
    try:
        wechat_img = Image.open(wechat_img_path)  # 加载拼接后的路径
        wechat_img = wechat_img.resize((40, 40))  # 调整图片大小
        wechat_img_tk = ImageTk.PhotoImage(wechat_img)  # 转换为Tkinter可识别的格式
    except Exception as e:
        print(f"wechat图标加载失败: {e}")
        wechat_img_tk = None  # 如果图片加载失败，则不显示图片

    # 加载头像并裁剪为圆形
    try:
        img = Image.open(avatar_path)
        # 创建一个圆形遮罩
        mask = Image.new("L", img.size, 0)
        draw = ImageDraw.Draw(mask)
        draw.ellipse((0, 0, img.size[0], img.size[1]), fill=255)
        
        # 使用遮罩裁剪图像
        img.putalpha(mask)
        img = img.resize((100, 100))  # 调整头像大小为 100x100
        img_tk = ImageTk.PhotoImage(img)  # 转换为Tkinter可识别的格式
    except Exception as e:
        print(f"头像加载失败: {e}")
        img_tk = None  # 如果图片加载失败，则不显示头像

    # 显示圆形头像并居中
    if img_tk:
        avatar_label = tk.Label(about_window, image=img_tk)
        avatar_label.image = img_tk  # 保持对图片的引用
        avatar_label.pack(pady=20)  # 在顶部居中显示头像

    # ---------------- 关于部分 ----------------
    about_text = "IP地址规划计算器 v1.3"
    author_text = "Author: Hoochanlon"
    desc_text = (
        "这是一个功能强大的工具，帮助用户进行IP地址规划和计算。\n\n"
        "主要功能包括：\n"
        "- 子网划分\n"
        "- 主机数推算子网\n"
        "- IP地址进制转换\n"
        "- 计算历史记录管理\n\n"
        "该工具适合网络工程师、开发者和学习者。\n"
        "当前版本已优化用户界面并修复了一些问题。\n"
    )

    # 关于标题
    text_label = tk.Label(about_window, text=about_text, justify=tk.LEFT, padx=10)
    text_label.pack(pady=5)

    # 作者信息
    author_label = tk.Label(about_window, text=author_text, justify=tk.LEFT, padx=10)
    author_label.pack(pady=5)

    # 描述信息
    desc_label = tk.Label(
        about_window, 
        text=desc_text, 
        justify=tk.LEFT, 
        padx=10, 
        wraplength=280  # 自动换行的宽度
    )
    desc_label.pack(pady=5)



    # ---------------- 联系方式部分 ----------------
    contact_frame = tk.Frame(about_window)
    contact_frame.pack(pady=5)

    # 使用 grid 方法确保图标都在同一行
    # 如果 GitHub 图片存在，将其显示并设置为可点击
    if github_img_tk:
        def open_homepage(event):
            webbrowser.open("https://github.com/hoochanlon")
        github_image_label = tk.Label(contact_frame, image=github_img_tk, cursor="hand2")
        github_image_label.image = github_img_tk  # 保持对图片的引用
        github_image_label.bind("<Button-1>", open_homepage)  # 绑定点击事件
        github_image_label.grid(row=0, column=0, padx=5)  # 放在第0行，第1列，左右间距5
   
    # 如果邮箱图片存在，将其显示并设置为可点击
    if email_img_tk:
        def open_email(event):
            webbrowser.open("mailto:hoochanlon@outlook.com") 
        email_image_label = tk.Label(contact_frame, image=email_img_tk, cursor="hand2")
        email_image_label.image = email_img_tk  # 保持对图片的引用
        email_image_label.bind("<Button-1>", open_email)  # 绑定点击事件
        email_image_label.grid(row=0, column=1, padx=5)  # 放在第0行，第0列，左右间距5


    if wechat_img_tk:
        def show_wechat_qr():
            # 创建新的Toplevel窗口
            wechat_window = tk.Toplevel()
            wechat_window.title("微信二维码")
            
            # 设置窗口大小和防止调整大小
            wechat_window.geometry("250x300")
            wechat_window.resizable(False, False)
            
            # 获取 QR 图片路径
            qr_img_path = os.path.join(current_dir, "images", "wechat_qr.png")  
            
            try:
                qr_img = Image.open(qr_img_path)
                qr_img = qr_img.resize((200, 200))  # 调整图片大小
                qr_img_tk = ImageTk.PhotoImage(qr_img)
            except Exception as e:
                print(f"微信二维码加载失败: {e}")
                qr_img_tk = None
            
            # 显示二维码图片
            if qr_img_tk:
                qr_label = tk.Label(wechat_window, image=qr_img_tk)
                qr_label.image = qr_img_tk  # 保持对图片的引用
                qr_label.pack(pady=20)
            
            # 提示文本
            message_label = tk.Label(wechat_window, text="扫一扫上方二维码添加微信", font=("微软雅黑", 11))
            message_label.pack(pady=10)
        
        # 创建微信图标按钮
        wechat_image_label = tk.Label(contact_frame, image=wechat_img_tk, cursor="hand2")
        wechat_image_label.image = wechat_img_tk  # 保持对图片的引用
        wechat_image_label.bind("<Button-1>", lambda event: show_wechat_qr())  # 绑定点击事件
        wechat_image_label.grid(row=0, column=2, padx=5)  # 放在第0行，第2列，左右间距5

