# gui_network_merge.py
import tkinter as tk
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from tkinter import messagebox
import ipaddress  # 用于处理IP地址和网段
import re  # 用于处理正则表达式
from gui.gui_right_menu import attach_result_right_click_menu
from core.calc_history_manager import save_to_history


# 定义全局状态字典
network_merge_state = {
    "input": "",
    "result": "",
    "error": ""
}

def network_merge_calculator(parent_frame):
    # 创建输入框和标签
    label = tk.Label(parent_frame, text="请输入网段（CIDR 格式）进行合并（以逗号、空格或换行符分隔）：")
    label.pack(pady=5)

    # 创建一个框架来放置Text框和滚动条
    input_frame = tk.Frame(parent_frame)
    input_frame.pack(pady=10, fill=tk.X)

    # 使用Text小部件创建多行输入框
    text = tk.Text(input_frame, height=13, width=30, font=("仿宋", 11))  # 设置字体为仿宋，大小为11
    text.pack(side=tk.LEFT, fill=tk.X, expand=True)  # 使用fill=tk.X以适应父容器宽度

    # 添加垂直滚动条
    scroll_y = tk.Scrollbar(input_frame, orient=tk.VERTICAL, command=text.yview)
    scroll_y.pack(side=tk.RIGHT, fill=tk.Y)
    text.config(yscrollcommand=scroll_y.set)

    # 创建一个框架来放置按钮（使按钮保持在同一排）
    button_frame = tk.Frame(parent_frame)
    button_frame.pack(pady=10)

    # 合并按钮
    def merge_networks():
        global network_merge_state  # 使用全局状态字典
        try:
            # 获取用户输入并预处理
            raw_input = text.get("1.0", "end-1c").strip()
            
            # 如果输入为空，则直接退出函数
            if not raw_input:
                return
            
            # 使用正则表达式处理换行符、空格、逗号作为分隔符，去除多余的空格
            raw_input = re.sub(r'[、，\s,]+', '\n', raw_input).strip()  # 将空格和逗号转换行

            networks = raw_input.split('\n')
            networks = [network.strip() for network in networks if network.strip()]  # 去掉空白内容

            # 定义简化的 CIDR 格式正则表达式
            cidr_pattern = re.compile(r"^(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\."
                                    r"(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\."
                                    r"(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\."
                                    r"(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})"
                                    r"/(3[0-2]|[1-2]?[0-9])$")

            # 验证每个网段是否为有效的 CIDR 格式
            validated_networks = []
            for network in networks:
                if not cidr_pattern.match(network):
                    raise ValueError(f"无效的网段，请确保输入符合 192.168.0.0/24 该格式。")
                # 使用 ipaddress.IPv4Network 解析网段，确保格式合法
                validated_networks.append(ipaddress.IPv4Network(network, strict=False))

            # 合并网段
            merged_network = ipaddress.collapse_addresses(validated_networks)

            # 更新显示结果
            result_text.delete("1.0", "end")  # 清空之前的结果
            result = "\n".join(str(network) for network in merged_network)  # 确保每个结果之间有换行符
            result_text.insert("1.0", result)  # 插入新的结果，带换行符

            # 保存当前输入和结果，以便下次保留
            network_merge_state["input"] = raw_input
            network_merge_state["result"] = result
            network_merge_state["error"] = ""  # 清除错误信息

            # 保存历史记录
            save_to_history("路由汇总计算器", {"network_merge_input": raw_input}, result)

        except ValueError as e:
            # 将错误信息显示在结果框
            result_text.delete("1.0", "end")  # 清空结果框内容
            error_message = f"错误：{str(e)}"
            result_text.insert("1.0", error_message, "error")  # 插入错误信息并应用样式标签

            # 更新错误状态
            network_merge_state["error"] = error_message
            network_merge_state["result"] = ""  # 清空结果

    merge_button = tk.Button(button_frame, text="合并网段", command=merge_networks)
    merge_button.pack(side=tk.LEFT, padx=5)

    # 清空按钮
    def clear_input():
        global network_merge_state
        text.delete("1.0", "end")  # 清空Text中的内容
        result_text.delete("1.0", "end")  # 清空结果框中的内容
        network_merge_state["input"] = ""
        network_merge_state["result"] = ""
        network_merge_state["error"] = ""  # 清除错误信息

    clear_button = tk.Button(button_frame, text="清空", command=clear_input)
    clear_button.pack(side=tk.LEFT, padx=5)

    # 创建一个框架来放置结果显示框和滚动条
    result_frame = tk.Frame(parent_frame)
    result_frame.pack(pady=10, fill=tk.X)

    # 使用Text小部件创建多行结果显示框
    result_text = tk.Text(result_frame, height=13, width=30, wrap=tk.WORD, font=("仿宋", 11))  # 设置字体为仿宋，大小为11
    result_text.pack(side=tk.LEFT, fill=tk.X, expand=True)  # 使用fill=tk.X以适应父容器宽度

    # 添加垂直滚动条
    scroll_y_result = tk.Scrollbar(result_frame, orient=tk.VERTICAL, command=result_text.yview)
    scroll_y_result.pack(side=tk.RIGHT, fill=tk.Y)
    result_text.config(yscrollcommand=scroll_y_result.set)

    # 添加右键菜单
    attach_result_right_click_menu(result_text, result_frame)

    # 配置错误样式
    def configure_tags():
        result_text.tag_configure("error", font=("微软雅黑", 15, "bold"), foreground="red")  # 加粗，红色
    configure_tags()

    # 恢复上一次输入和结果
    if network_merge_state["input"]:
        text.insert("1.0", network_merge_state["input"])
    if network_merge_state["result"]:
        result_text.insert("1.0", network_merge_state["result"])
