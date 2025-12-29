# gui_supernet_split_calc.py
import tkinter as tk
from tkinter import messagebox
import ipaddress
import re
from gui.gui_right_menu import attach_result_right_click_menu
from core.calc_history_manager import save_to_history
# https://docs.vmware.com/cn/VMware-SD-WAN/5.2/VMware-SD-WAN-Administration-Guide/GUID-72405FEF-C3B9-47E9-A332-869FB35DB1DC.html

# 全局状态变量，用于保存当前输入和结果
network_split_state = {
    "input": "",
    "result": "",
    "error": ""
}

def network_split_calculator(parent_frame):
    # 清空旧的内容
    for widget in parent_frame.winfo_children():
        widget.destroy()

    # 超网标签和输入框
    supernet_frame = tk.Frame(parent_frame)
    supernet_frame.pack(pady=5, fill=tk.X)

    supernet_label = tk.Label(supernet_frame, text="请输入需拆分的超网（CIDR格式）：", anchor="e")
    supernet_label.pack(side=tk.TOP, padx=5)
    supernet_input = tk.Entry(supernet_frame, width=30)
    supernet_input.pack(side=tk.TOP, padx=5)

    # 子网掩码标签和输入框
    subnet_mask_frame = tk.Frame(parent_frame)
    subnet_mask_frame.pack(pady=5, fill=tk.X)

    subnet_mask_label = tk.Label(subnet_mask_frame, text="请输入目标子网掩码长度（1~32）：", anchor="e")
    subnet_mask_label.pack(side=tk.TOP, padx=5)
    subnet_mask_input = tk.Entry(subnet_mask_frame, width=30)
    subnet_mask_input.pack(side=tk.TOP, padx=5)

    # 按钮框架
    button_frame = tk.Frame(parent_frame)
    button_frame.pack(pady=10)

    # 结果框架
    result_frame = tk.Frame(parent_frame)
    result_frame.pack(pady=10, fill=tk.BOTH, expand=True)

    result_text = tk.Text(result_frame, height=13, width=40, wrap=tk.WORD, font=("仿宋", 11))  # 设置了宽度为40
    result_text.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

    scroll_y = tk.Scrollbar(result_frame, orient=tk.VERTICAL, command=result_text.yview)
    scroll_y.pack(side=tk.RIGHT, fill=tk.Y)
    result_text.config(yscrollcommand=scroll_y.set)

    # 配置错误样式
    def configure_tags():
        result_text.tag_configure("error", font=("微软雅黑", 15, "bold"), foreground="red", justify='center')

    configure_tags()

    # 清空输入与结果
    def clear_input():
        supernet_input.delete(0, tk.END)
        subnet_mask_input.delete(0, tk.END)
        result_text.delete("1.0", tk.END)

        # 清除全局状态
        network_split_state["input"] = ""
        network_split_state["result"] = ""
        network_split_state["error"] = ""

    # 拆分超网逻辑
    def split_network():
        result_text.delete("1.0", tk.END)  # 清空之前的结果
        supernet = supernet_input.get().strip()
        target_mask = subnet_mask_input.get().strip()

        # 如果输入为空，直接返回
        # if not supernet or not target_mask:
        #     return
        if not supernet:
            result_text.insert("1.0", "错误：超网输入不能为空！\n", "error")
            network_split_state["error"] = "超网输入不能为空"
            return
        if not target_mask:
            result_text.insert("1.0", "错误：目标子网掩码输入不能为空！\n", "error")
            network_split_state["error"] = "目标子网掩码输入不能为空"
            return

        try:
            # 验证超网输入
            cidr_pattern = re.compile(
                r"^(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\."
                r"(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\."
                r"(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\."
                r"(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})"
                r"/(3[0-2]|[1-2]?[0-9])$"
            )

            if not cidr_pattern.match(supernet):
                raise ValueError("无效的超网格式，请确保输入符合 CIDR 格式，如 172.16.64.0/21")

            # 验证目标子网掩码长度
            if not target_mask.isdigit() or not (0 <= int(target_mask) <= 32):
                raise ValueError("目标子网掩码长度无效，请输入一个介于 1 到 32 之间的数字")

            target_mask = int(target_mask)
            supernet_network = ipaddress.IPv4Network(supernet, strict=False)

            if target_mask <= supernet_network.prefixlen:
                raise ValueError(
                    f"目标子网掩码长度（/{target_mask}）必须大于超网掩码长度（/{supernet_network.prefixlen}）！"
                )

            # 拆分网络
            subnets = list(supernet_network.subnets(new_prefix=target_mask))
            if not subnets:
                raise ValueError("无法进行拆分，请检查输入的超网和子网掩码！")

            # 显示结果
            for subnet in subnets:
                result_text.insert(tk.END, f"{subnet}\n")

            # 更新全局状态
            network_split_state["input"] = supernet, target_mask
            network_split_state["result"] = "\n".join(str(subnet) for subnet in subnets)
            network_split_state["error"] = ""

            # 保存历史记录
            save_to_history("超网拆分计算器", {"supernet_split_input": network_split_state["input"]}, network_split_state["result"])

        except ValueError as e:
            result_text.insert("1.0", f"错误：{e}\n", "error")
            network_split_state["error"] = str(e)

    # 拆分按钮
    split_button = tk.Button(button_frame, text="拆分网络", command=split_network)
    split_button.pack(side=tk.LEFT, padx=5)

    # 清空按钮
    clear_button = tk.Button(button_frame, text="清空", command=clear_input)
    clear_button.pack(side=tk.LEFT, padx=5)

    # 添加右键菜单
    attach_result_right_click_menu(result_text, result_frame)

    # 在初始化时，检查全局状态是否有有效输入和结果，如果有则恢复
    if network_split_state["input"]:
        supernet_input.insert(0, network_split_state["input"][0])  # 超网输入
        subnet_mask_input.insert(0, network_split_state["input"][1])  # 子网掩码输入
    if network_split_state["result"]:
        result_text.insert("1.0", network_split_state["result"])  # 恢复结果
