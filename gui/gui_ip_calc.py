# gui_ip_clac.py 
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import tkinter as tk
from tkinter import messagebox
from core.calc_history_manager import save_to_history, load_history
from core.ip_utils import calculate_ip_info, cidr_to_subnet_mask, validate_ip_and_mask
from gui.gui_right_menu import attach_result_right_click_menu

# 定义全局状态字典，用于保存用户的输入和输出内容
ip_calc_state = {
    "ip_address": "",
    "subnet_mask": "",
    "result": ""
}

def ip_calculator(frame):
    global ip_calc_state

    def on_calculate():
        ip_address = ip_entry.get().strip()
        subnet_mask = subnet_entry.get().strip()

        # 清空之前的输出
        result_text.delete(1.0, tk.END)
        result_text.tag_configure("error_font", foreground="red", font=("微软雅黑", 15,"bold"),justify="center")

        # 检查输入是否为空
        if not ip_address and not subnet_mask:
            # 如果两个输入框都为空，直接返回，不执行计算
            return
        elif not ip_address:
            result_text.insert(tk.END, "请输入IP地址！\n", "error_font")
            return
        elif not subnet_mask:
            result_text.insert(tk.END, "请输入子网掩码！\n", "error_font")
            return

        # 校验IP和子网掩码
        validation_result = validate_ip_and_mask(ip_address, subnet_mask)
        if validation_result != "valid":
            result_text.insert(tk.END, f"错误: {validation_result}\n", "error_font")
            return

        # 如果是CIDR格式，转换成子网掩码
        if subnet_mask.startswith('/'):
            subnet_mask = cidr_to_subnet_mask(subnet_mask)
            if subnet_mask == "无效的CIDR":
                result_text.insert(tk.END, "错误: 无效的CIDR\n", "error_font")
                return

        # 获取网络信息
        result = calculate_ip_info(ip_address, subnet_mask)

        # 如果计算结果是字符串（即错误），显示错误消息
        if isinstance(result, str):
            result_text.insert(tk.END, f"错误: {result}\n", "error_font")
        else:
            # 获取反掩码：子网掩码按位取反
            inverted_mask = '.'.join(str(255 - int(octet)) for octet in subnet_mask.split('.'))

            # 显示计算结果
            output = (
                f"IP地址: {ip_address}\n"
                f"子网掩码: {subnet_mask}（CIDR: {result['cidr']}）\n"
                f"反掩码: {inverted_mask}\n"
                f"网络地址: {result['network_address']}\n"
                f"广播地址: {result['broadcast_address']}\n"
                f"可用IP数量: {result['usable_ips']}\n"
                f"第一可用IP: {result['first_usable_ip']}\n"
                f"最后可用IP: {result['last_usable_ip']}\n"
                f"网络类别: {result['network_class']}\n\n"

                f"IP地址的二进制:\n{result['ip_binary']}\n"
                f"子网掩码的二进制:\n{result['subnet_mask_binary']}\n\n"
                f"IP地址的十六进制: {result['ip_hexadecimal']}\n"
                f"子网掩码的十六进制: {result['subnet_mask_hexadecimal']}\n"
            )

            result_text.insert(tk.END, output, "big_font")
            ip_calc_state["result"] = output  # 保存输出结果

            # 保存历史记录
            save_to_history("IP地址计算器", {"ip": ip_address, "mask": subnet_mask}, output)

        # 更新状态字典中的输入内容
        ip_calc_state["ip_address"] = ip_address
        ip_calc_state["subnet_mask"] = subnet_mask



    def clear_inputs():
        # 清空输入框和文本框
        ip_entry.delete(0, tk.END)
        subnet_entry.delete(0, tk.END)
        result_text.delete(1.0, tk.END)

        # 清空状态
        ip_calc_state["ip_address"] = ""
        ip_calc_state["subnet_mask"] = ""
        ip_calc_state["result"] = ""

    # 清空已有组件
    for widget in frame.winfo_children():
        widget.destroy()

    # 输入框
    tk.Label(frame, text="请输入IP地址：").pack(pady=5)
    ip_entry = tk.Entry(frame, width=30)
    ip_entry.pack(pady=5)
    ip_entry.insert(0, ip_calc_state["ip_address"])

    tk.Label(frame, text="请输入子网掩码：").pack(pady=5)
    subnet_entry = tk.Entry(frame, width=30)
    subnet_entry.pack(pady=5)
    subnet_entry.insert(0, ip_calc_state["subnet_mask"])

    # 创建按钮框架
    button_frame = tk.Frame(frame)
    button_frame.pack(pady=10)

    # 计算和清空按钮
    calculate_button = tk.Button(button_frame, text=" 计算 ", command=on_calculate)
    calculate_button.pack(side=tk.LEFT, padx=5)

    clear_button = tk.Button(button_frame, text=" 清空 ", command=clear_inputs)
    clear_button.pack(side=tk.LEFT, padx=5)

    # 输出区域
    result_text = tk.Text(frame, width=65, height=20)
    result_text.pack(pady=5)

    result_text.tag_configure("big_font", font=("仿宋", 11))
    result_text.insert(tk.END, ip_calc_state["result"], "big_font")

    # 添加右键菜单
    attach_result_right_click_menu(result_text, frame)
