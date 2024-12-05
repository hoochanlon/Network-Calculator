# gui_base_converter.py
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import tkinter as tk
from core.base_converter_utils import convert_ip
from core.calc_history_manager import save_to_history
from gui.gui_right_menu import attach_result_right_click_menu

# 定义全局状态字典，用于保存输入和输出内容
ip_base_converter_state = {
    "symbol": "",
    "result": "",
    "error": ""  # 错误信息字段
}

def ip_base_converter(frame):
    global ip_base_converter_state

    def convert_ip_gui():
        ip_input = ip_entry.get().strip()  # 获取输入的IP地址

        if not ip_input:  # 如果没有输入，则清空结果
            result_text.delete(1.0, tk.END)
            ip_base_converter_state["result"] = ""
            ip_base_converter_state["error"] = ""  # 清除错误信息
            return

        result = convert_ip(ip_input)

        if "转换失败" in result:  # 判断是否是错误信息
            ip_base_converter_state["error"] = result  # 保留错误信息
            result_text.delete(1.0, tk.END)
            result_text.insert(tk.END, result, "error_font")  # 显示错误信息
        else:
            # 更新状态字典中的结果
            ip_base_converter_state["result"] = result
            ip_base_converter_state["error"] = ""  # 清除错误信息
            result_text.delete(1.0, tk.END)  # 清空显示框
            result_text.insert(tk.END, result, "big_font")  # 显示转换结果，应用自定义字体样式

            # 保存历史记录
            save_to_history("IP及掩码进制转换器", {"symbol": ip_input}, result)

            # 更新状态字典中的输入内容
            ip_base_converter_state["symbol"] = ip_input

    def clear_inputs():
        # 清空输入框和文本框
        ip_entry.delete(0, tk.END)
        result_text.delete(1.0, tk.END)

        # 清空状态
        ip_base_converter_state["symbol"] = ""
        ip_base_converter_state["result"] = ""
        ip_base_converter_state["error"] = ""  # 清除错误信息

    # 清空已有组件
    for widget in frame.winfo_children():
        widget.destroy()

    # 输入框（单行输入）
    tk.Label(frame, text="请输入需要转换的字符：").pack(pady=10)
    ip_entry = tk.Entry(frame, width=40)  # 使用单行输入框
    ip_entry.insert(tk.END, ip_base_converter_state["symbol"])  # 恢复之前的输入
    ip_entry.pack(pady=5)

    # 创建按钮框架
    button_frame = tk.Frame(frame)
    button_frame.pack(pady=37)

    # 计算和清空按钮
    convert_button = tk.Button(button_frame, text=" 转换 ", command=convert_ip_gui)
    convert_button.pack(side=tk.LEFT, padx=10)

    clear_button = tk.Button(button_frame, text=" 清空 ", command=clear_inputs)
    clear_button.pack(side=tk.LEFT, padx=10)

    # 输出区域（调整文本框高度以便显示更多转换结果）
    result_text = tk.Text(frame, width=65, height=20)
    result_text.tag_configure("big_font", font=("仿宋", 11))  # 设置字体为仿宋，字号为11号
    result_text.insert(tk.END, ip_base_converter_state["result"], "big_font")  # 恢复之前的计算结果
    result_text.pack(pady=5)

    # 配置错误信息样式
    result_text.tag_configure(
        "error_font",
        foreground="red",
        font=("微软雅黑", 15, "bold"),
        justify="center"
    )

    # 如果有错误信息，则清空
    if ip_base_converter_state["error"]:
        result_text.delete(1.0, tk.END)

    # 添加右键菜单
    attach_result_right_click_menu(result_text, frame)
