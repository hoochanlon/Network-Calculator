# gui_main_layout.py
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import tkinter as tk
from tkinter import Menu, messagebox
import webbrowser
from gui.gui_ip_calc import ip_calculator
from gui.gui_subnet_calc import subnet_calculator
from gui.gui_base_converter import ip_base_converter
from gui.gui_menu import show_word, show_about,get_cheat_sheet_ipv4_en_pdf
from gui.gui_calc_history_manager import show_history

# 打开网页链接
def open_webpage(url):
    webbrowser.open(url)

# 创建主界面
def create_gui():
    root = tk.Tk()
    root.title("IP地址规划计算器v1.3.2")

    # 设置窗口大小为固定大小
    root.geometry("420x560")
    root.resizable(False, False)

    # 创建菜单
    menu = Menu(root)
    root.config(menu=menu)

    # 软件信息菜单
    info_menu = Menu(menu, tearoff=0)
    menu.add_cascade(label="信息", menu=info_menu)

    # 在信息菜单里添加功能和使用、历史记录、关于以及基础知识部分
    info_menu.add_command(label="历史记录", command=show_history)
    info_menu.add_command(label="开发日志", command=show_word)
    info_menu.add_command(label="关于", command=show_about)

    # 知识库菜单
    knowledge_base_menu = Menu(menu, tearoff=0)
    # 知识文章添加到知识库菜单
    post_menu = Menu(knowledge_base_menu, tearoff=0)
    knowledge_base_menu.add_cascade(label="查看精选IP与子网掩码解读文章", menu=post_menu)
    post_menu.add_command(label="hoochanlon - 一篇全文让你彻底理清IP地址、子网掩码、网关", command=lambda: open_webpage("https://hoochanlon.github.io/helpdesk-guide/enhance/net/neta.html"))
    post_menu.add_command(label="freecodecamp.org - 子网检查单", command=lambda: open_webpage("https://www.freecodecamp.org/chinese/news/subnet-cheat-sheet-24-subnet-mask-30-26-27-29-and-other-ip-address-cidr-network-references"))
    post_menu.add_command(label="MEP - 这五个计算题，彻底弄懂ip地址与子网掩码（转载）", command=lambda: open_webpage("http://mepconsultants.net/nd.jsp?id=4456"))
    # 添加在线工具
    menu.add_cascade(label="知识库", menu=knowledge_base_menu)
    knowledge_base_menu.add_command(label="PAESSLER - IPv4 子网速查表",command=lambda: open_webpage(f"file://{get_cheat_sheet_ipv4_en_pdf()}"))
    knowledge_base_menu.add_command(label="清华大学交叉信息研究院 - ip地址在线计算器", command=lambda: open_webpage("https://iiis.tsinghua.edu.cn/ip/"))
    knowledge_base_menu.add_command(label="calculator.io - 子网计算器", command=lambda: open_webpage("https://www.calculator.io/zh/%E5%AD%90%E7%BD%91%E8%AE%A1%E7%AE%97%E5%99%A8/"))
    knowledge_base_menu.add_command(label="webdemo.myscript.com - 手写数学公式算结果", command=lambda: open_webpage("https://webdemo.myscript.com/"))
    knowledge_base_menu.add_command(label="tool.browser.qq.com - 腾讯在线工具箱", command=lambda: open_webpage("https://tool.browser.qq.com/"))

    # 添加标题标签到主窗口的顶部
    title_label = tk.Label(root, text="网络和IP地址计算器", font=("仿宋", 14), pady=10)
    title_label.pack()

    # 创建一个单独的框架来放置RadioButtons
    radio_frame = tk.Frame(root)
    radio_frame.pack(pady=5)

    # 创建主界面框架
    frame = tk.Frame(root, relief=tk.GROOVE, borderwidth=2)
    frame.pack(padx=10, pady=15, fill=tk.BOTH, expand=True)

    # 默认显示IP地址计算器
    ip_calculator(frame)

    # 切换计算器的函数
    def switch_calculator():
        selected_option = calculator_var.get()
        for widget in frame.winfo_children():
            widget.destroy()

        if selected_option == "网络和IP地址计算器":
            title_label.config(text="网络和IP地址计算器")
            ip_calculator(frame)
        elif selected_option == "主机数与子网换算器":
            title_label.config(text="主机数与子网换算器")
            subnet_calculator(frame)
        elif selected_option == "IP及掩码进制转换器":
            title_label.config(text="IP及掩码进制转换器")
            ip_base_converter(frame)

    # 创建RadioButtons来选择计算器
    calculator_var = tk.StringVar()
    calculator_var.set("网络和IP地址计算器")  # 默认选项

    ip_radio = tk.Radiobutton(radio_frame, text="网络和IP地址计算器", variable=calculator_var, value="网络和IP地址计算器", command=switch_calculator)
    subnet_radio = tk.Radiobutton(radio_frame, text="主机数与子网换算器", variable=calculator_var, value="主机数与子网换算器", command=switch_calculator)
    base_converter_radio = tk.Radiobutton(radio_frame, text="IP及掩码进制转换器", variable=calculator_var, value="IP及掩码进制转换器", command=switch_calculator)

    ip_radio.pack(side=tk.LEFT, padx=1)
    subnet_radio.pack(side=tk.LEFT, padx=1)
    base_converter_radio.pack(side=tk.LEFT, padx=1)

    # 程序保持运行状态，不断监听用户的交互事件。
    root.mainloop()
