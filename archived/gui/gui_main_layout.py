# gui_main_layout.py
import sys
import os
import tkinter as tk
from tkinter import Menu, messagebox
import webbrowser

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from gui.gui_ip_calc import ip_calculator
from gui.gui_subnet_calc import subnet_calculator
from gui.gui_base_converter import ip_base_converter
from gui.gui_menu import show_word, show_about, get_cheat_sheet_ipv4_en_pdf, get_agilent_netzwerk_pdf
from gui.gui_calc_history_manager import show_history
from gui.gui_supernet_calc import network_merge_calculator
from gui.gui_supernet_split_calc import network_split_calculator
from gui.gui_ip_inclusion_checker import ip_inclusion_checker  # 导入新的IP包含检测器模块


# 打开网页链接
def open_webpage(url):
    webbrowser.open(url)


# 创建主界面
def create_gui():
    root = tk.Tk()
    root.title("多功能IP地址计算器v1.5")

    # 设置窗口大小为固定大小
    root.geometry("420x560")
    root.resizable(False, False)

    # 创建菜单
    menu = Menu(root)
    root.config(menu=menu)

    # 软件信息菜单
    info_menu = Menu(menu, tearoff=0)
    menu.add_cascade(label="信息", menu=info_menu)
    info_menu.add_command(label="历史记录", command=show_history)
    info_menu.add_command(label="开发日志", command=show_word)
    info_menu.add_command(label="关于", command=show_about)

    # 知识库菜单
    knowledge_base_menu = Menu(menu, tearoff=0)
    post_menu = Menu(knowledge_base_menu, tearoff=0)
    knowledge_base_menu.add_cascade(label="查看精选IP与子网掩码解读文章", menu=post_menu)
    post_menu.add_command(label="hoochanlon - 一篇全文让你彻底理清IP地址、子网掩码、网关",
                          command=lambda: open_webpage("https://hoochanlon.github.io/helpdesk-guide/enhance/net/neta.html"))
    post_menu.add_command(label="freecodecamp.org - 子网检查单",
                          command=lambda: open_webpage("https://www.freecodecamp.org/chinese/news/subnet-cheat-sheet-24-subnet-mask-30-26-27-29-and-other-ip-address-cidr-network-references"))
    post_menu.add_command(label="MEP - 这五个计算题，彻底弄懂ip地址与子网掩码（转载）",
                          command=lambda: open_webpage("http://mepconsultants.net/nd.jsp?id=4456"))
    post_menu.add_command(label="csdn - 计算机网络-路由聚合（超网）聚合（子网合并）",
                          command=lambda: open_webpage("https://blog.csdn.net/qq_43781399/article/details/117194455"))
    post_menu.add_command(label="csdn - 路由汇总与路由聚合的区别",
                          command=lambda: open_webpage("https://blog.csdn.net/qq_43492336/article/details/114298916"))

    menu.add_cascade(label="知识库", menu=knowledge_base_menu)
    knowledge_base_menu.add_command(label="PAESSLER - IPv4 子网速查表",
                                    command=lambda: open_webpage(f"file://{get_cheat_sheet_ipv4_en_pdf()}"))
    knowledge_base_menu.add_command(label="Agilent_Netzwerk - 网络协议图",
                                    command=lambda: open_webpage(f"file://{get_agilent_netzwerk_pdf()}"))
    knowledge_base_menu.add_command(label="清华大学交叉信息研究院 - ip地址在线计算器",
                                    command=lambda: open_webpage("https://iiis.tsinghua.edu.cn/ip/"))
    knowledge_base_menu.add_command(label="subnet-calculator.org - supernets",
                                    command=lambda: open_webpage("https://www.subnet-calculator.org/supernets.php"))
    knowledge_base_menu.add_command(label="webdemo.myscript.com - 手写数学公式算结果",
                                    command=lambda: open_webpage("https://webdemo.myscript.com/"))


    # 添加标题标签到主窗口的顶部
    title_label = tk.Label(root, text="IP地址计算器", font=("仿宋", 14), pady=10)
    title_label.pack()

    # 创建一个框架来放置RadioButtons
    radio_frame_top = tk.Frame(root)
    radio_frame_bottom = tk.Frame(root)
    radio_frame_top.pack(pady=10, anchor="w")  # 顶部框架靠左对齐
    radio_frame_bottom.pack(pady=10)          # 底部框架居中对齐

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

        if selected_option == "IP地址计算器":
            title_label.config(text="IP地址计算器")
            ip_calculator(frame)
        elif selected_option == "子网掩码换算器":
            title_label.config(text="子网掩码换算器")
            subnet_calculator(frame)
        elif selected_option == "IP进制转换器":
            title_label.config(text="IP进制转换器")
            ip_base_converter(frame)
        elif selected_option == "路由聚合计算器":
            title_label.config(text="路由聚合计算器")
            network_merge_calculator(frame)
        elif selected_option == "超网拆分计算器":  
            title_label.config(text="超网拆分计算器")
            network_split_calculator(frame)
        elif selected_option == "IP包含检测器":  # 新增选项
            title_label.config(text="IP包含检测器")
            ip_inclusion_checker(frame)  # 调用IP包含检测器

    # 设置统一按钮宽度
    button_width = 15

    # 创建 RadioButtons
    calculator_var = tk.StringVar()
    calculator_var.set("IP地址计算器")  # 默认选项

    # 顶部选项：靠左对齐
    ip_radio = tk.Radiobutton(radio_frame_top, text="IP地址计算器", width=button_width, variable=calculator_var,
                              value="IP地址计算器", command=switch_calculator)

    base_converter_radio = tk.Radiobutton(radio_frame_top, text="IP进制转换器", width=button_width,
                                          variable=calculator_var, value="IP进制转换器", command=switch_calculator)
    ip_inclusion_radio = tk.Radiobutton(radio_frame_top, text="IP包含检测器", width=button_width,
                                         variable=calculator_var, value="IP包含检测器", command=switch_calculator)  
    # 底部选项：居中对齐
    network_merge_radio = tk.Radiobutton(radio_frame_bottom, text="路由聚合计算器", width=button_width,
                                         variable=calculator_var, value="路由聚合计算器", command=switch_calculator)
    network_split_radio = tk.Radiobutton(radio_frame_bottom, text="超网拆分计算器", width=button_width,
                                         variable=calculator_var, value="超网拆分计算器", command=switch_calculator)
    subnet_radio = tk.Radiobutton(radio_frame_bottom, text="子网掩码计算器", width=button_width, variable=calculator_var,
                                  value="子网掩码换算器", command=switch_calculator)


    # 添加到框架中
    ip_radio.pack(side=tk.LEFT, padx=5)
    subnet_radio.pack(side=tk.LEFT, padx=5)
    base_converter_radio.pack(side=tk.LEFT, padx=5)
    network_merge_radio.pack(side=tk.LEFT, padx=5)
    network_split_radio.pack(side=tk.LEFT, padx=5)  # 新增的单选按钮
    ip_inclusion_radio.pack(side=tk.LEFT, padx=5)  # 新增的单选按钮

    # 程序保持运行状态，不断监听用户的交互事件
    root.mainloop()


# # 调用主界面
# if __name__ == "__main__":
#     create_gui()
# https://www.cisco.com/web/offer/emea/7193/docs/Agilent_Netzwerk.pdf