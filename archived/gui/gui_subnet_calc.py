# gui_ip_clac.py 
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import tkinter as tk
from core.calc_history_manager import save_to_history
from core.subnet_utils import hosts_to_subnet_mask_and_hosts, cidr_or_subnet_mask_to_info, validate_subnet_mask, validate_cidr
from gui.gui_right_menu import attach_result_right_click_menu
import re

# 定义全局状态字典，用于保存用户的输入和输出内容
subnet_calc_state = {
    "hosts_input": "",
    "subnet_input": "",
    "result": "",
    "default_hosts": "",
    "default_subnet": ""
}

def subnet_calculator(frame):
    global subnet_calc_state

    def calculate_info():
        # 清空结果区域
        result_text.delete(1.0, tk.END)

        hosts_input = hosts_entry.get().strip()
        subnet_input = subnet_entry.get().strip()

        # 更新状态字典中的输入内容
        subnet_calc_state["hosts_input"] = hosts_input
        subnet_calc_state["subnet_input"] = subnet_input

        # 检查是否同时输入主机数和子网掩码
        if hosts_input and subnet_input:
            result_text.insert(tk.END, "只能输入主机数\n或子网掩码/CIDR中的一个。\n", "error_font")
            subnet_calc_state["hosts_input"] = ""
            subnet_calc_state["subnet_input"] = ""
            # 检查 result 中是否包含特定的字符串
            if "输入的主机数" in subnet_calc_state["result"]:
                subnet_calc_state["hosts_input"] = subnet_calc_state["default_hosts"]
            elif "输入的子网掩码或CIDR" in subnet_calc_state["result"]:
                subnet_calc_state["subnet_input"] = subnet_calc_state["default_subnet"]
            hosts_entry.delete(0, tk.END)
            subnet_entry.delete(0, tk.END)
            return

        # 如果两个输入框都为空，不显示错误信息
        if not hosts_input and not subnet_input:
            return

        # 处理主机数输入
        if hosts_input:
            try:
                hosts = int(hosts_input)
                if hosts < 2:
                    result_text.insert(tk.END, "主机数必须大于等于2。\n", "error_font")
                    subnet_calc_state["hosts_input"] = ""
                    subnet_calc_state["hosts_input"] = subnet_calc_state["default_hosts"] 
                    return

                (
                    hosts,
                    subnet_mask,
                    cidr,
                    usable_hosts,
                    inverted_mask,
                    subnet_mask_binary,
                    inverted_mask_binary,
                    subnet_mask_hex,
                    inverted_mask_hex
                ) = hosts_to_subnet_mask_and_hosts(hosts)

                if isinstance(subnet_mask, str) and "主机数" in subnet_mask:
                    result_text.insert(tk.END, subnet_mask + "\n", "error_font")
                    subnet_calc_state["hosts_input"] = ""
                else:
                    output = (
                        f"输入的主机数: {hosts}\n"
                        f"推算得出子网掩码: {subnet_mask}（{cidr}）\n"
                        f"基于子网掩码的实际可用主机数: {usable_hosts}\n"
                        f"反掩码: {inverted_mask}\n\n"
                        f"子网掩码的二进制:\n{subnet_mask_binary}\n"
                        f"子网掩码的十六进制: {subnet_mask_hex}\n"
                    )
                    result_text.insert(tk.END, output, "big_font")
                    subnet_calc_state["result"] = output

                    # 提取并保存默认值
                    extracted_hosts = extract_hosts_value(output)
                    subnet_calc_state["default_hosts"] = extracted_hosts
                    print(f"提取的主机数: {extracted_hosts}")

                    # 保存历史记录
                    save_to_history("子网掩码计算器", {"hosts": hosts_input}, output)

            except ValueError:
                result_text.insert(tk.END, "请输入有效的主机数（数字）。\n", "error_font")
                # 删除字典中的主机数输入
                subnet_calc_state["hosts_input"] = ""
                subnet_calc_state["hosts_input"] = subnet_calc_state["default_hosts"] 
                return

        # 处理子网掩码输入
        elif subnet_input:
            if '/' in subnet_input:
                if not validate_cidr(subnet_input):
                    result_text.insert(tk.END, "CIDR格式无效，\n正确格式是 /0 到 /32 的数字。\n", "error_font")
                    subnet_calc_state["subnet_input"] = ""
                    subnet_calc_state["subnet_input"]= subnet_calc_state["default_subnet"] 
                    return
            elif not validate_subnet_mask(subnet_input):
                result_text.insert(tk.END, "子网掩码无效，请检查子网掩码格式。\n", "error_font")
                subnet_calc_state["subnet_input"] = ""
                subnet_calc_state["subnet_input"]= subnet_calc_state["default_subnet"] 
                return

            (
                cidr_or_mask,
                subnet_mask,
                cidr,
                usable_hosts,
                inverted_mask,
                subnet_mask_binary,
                inverted_mask_binary,
                subnet_mask_hex,
                inverted_mask_hex,
            ) = cidr_or_subnet_mask_to_info(subnet_input)

            output = (
                f"输入的子网掩码或CIDR: {cidr_or_mask}\n"
                f"可用主机数: {usable_hosts}\n"
                f"通过常规掩码算出的CIDR: {cidr}\n"
                f"通过CIDR算出的子网掩码: {subnet_mask}\n"
                f"反掩码: {inverted_mask}\n\n"
                f"子网掩码的二进制:\n{subnet_mask_binary}\n"
                f"子网掩码的十六进制: {subnet_mask_hex}\n"
            )
            result_text.insert(tk.END, output, "big_font")
            subnet_calc_state["result"] = output

            # 提取并保存默认值
            extracted_subnet = extract_subnet_value(output)
            subnet_calc_state["default_subnet"] = extracted_subnet
            print(f"提取的子网掩码: {extracted_subnet}")

            # 保存历史记录
            save_to_history("子网掩码计算器", {"subnet_input": subnet_input}, output)

    def clear_inputs():
        # 清空输入框和文本框
        hosts_entry.delete(0, tk.END)
        subnet_entry.delete(0, tk.END)
        result_text.delete(1.0, tk.END)

        # 清空状态
        subnet_calc_state["hosts_input"] = ""
        subnet_calc_state["subnet_input"] = ""
        subnet_calc_state["result"] = ""

    # 清空已有组件
    for widget in frame.winfo_children():
        widget.destroy()

    # 输入框
    tk.Label(frame, text="请输入子网掩码：").pack(pady=5)
    subnet_entry = tk.Entry(frame, width=30)
    subnet_entry.pack(pady=5)
    subnet_entry.insert(0, subnet_calc_state["subnet_input"])

    tk.Label(frame, text="或请输入主机数：").pack(pady=5)
    hosts_entry = tk.Entry(frame, width=30)
    hosts_entry.pack(pady=5)
    hosts_entry.insert(0, subnet_calc_state["hosts_input"])

    # 创建按钮框架
    button_frame = tk.Frame(frame)
    button_frame.pack(pady=10)

    # 计算和清空按钮
    calculate_button = tk.Button(button_frame, text=" 计算 ", command=calculate_info)
    calculate_button.pack(side=tk.LEFT, padx=5)

    clear_button = tk.Button(button_frame, text=" 清空 ", command=clear_inputs)
    clear_button.pack(side=tk.LEFT, padx=5)

    # 输出区域
    result_text = tk.Text(frame, width=55, height=20)
    result_text.pack(pady=5)

    result_text.tag_configure("big_font", font=("仿宋", 11))
    result_text.tag_configure(
        "error_font", 
        foreground="red", 
        font=("微软雅黑", 15, "bold"),  # 加粗字体
        justify="center"
    )
    result_text.insert(tk.END, subnet_calc_state["result"], "big_font")

    # 添加右键菜单
    attach_result_right_click_menu(result_text, frame)


# 提取主机数的函数
def extract_hosts_value(result_str):
    """
    从计算结果字符串中提取主机数。
    """
    hosts_match = re.search(r"输入的主机数: (\d+)", result_str)
    hosts_value = int(hosts_match.group(1)) if hosts_match else ""
    return hosts_value

# 提取子网掩码或CIDR的函数
def extract_subnet_value(result_str):
    """
    从计算结果字符串中提取子网掩码或CIDR。
    """
    # 提取子网掩码或CIDR
    subnet_match = re.search(r"输入的子网掩码或CIDR: ([^ \n]+)", result_str)
    subnet_value = subnet_match.group(1) if subnet_match else ""
    return subnet_value
