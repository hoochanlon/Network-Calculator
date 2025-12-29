# gui_ip_inclusion_checker.py
import tkinter as tk
from netaddr import IPNetwork, AddrFormatError
from gui.gui_right_menu import attach_result_right_click_menu
from core.calc_history_manager import save_to_history

# 全局字典用于存储上一次的输入和结果
previous_data = {
    'cidr_1': '',
    'cidr_2': '',
    'result': ''
}

def ip_inclusion_checker(frame):
    # 创建标签和输入框的函数
    def create_input_field(parent, label_text, default_value=''):
        label = tk.Label(parent, text=label_text)
        label.pack(pady=3)
        entry = tk.Entry(parent, width=30)
        entry.insert(tk.END, default_value)  # 设置默认值
        entry.pack(pady=3)
        return entry

    # 显示结果的函数
    def display_result(message, is_error=False):
        result_display.config(state=tk.NORMAL)
        result_display.delete(1.0, tk.END)

        if is_error:
            result_display.insert(tk.END, message, 'error')
        else:
            result_display.insert(tk.END, message)

        result_display.config(state=tk.DISABLED)

    # 检查 CIDR 是否包含在另一个 CIDR 范围内
    def check_inclusion():
        cidr_1, cidr_2 = cidr_entry_1.get().strip(), cidr_entry_2.get().strip()

        try:
            # 验证输入的CIDR格式
            network_1 = IPNetwork(cidr_1)
            network_2 = IPNetwork(cidr_2)

            # 检查目标CIDR是否包含掩码长度
            if '/' not in cidr_2:
                display_result("目标CIDR缺失掩码长度，\n请使用类似192.168.1.1/24的格式", is_error=True)
                return

        except AddrFormatError:
            display_result("无效的CIDR格式，请重新输入！", is_error=True)
            return
        except IndexError:
            display_result("缺失掩码长度，请检查CIDR格式", is_error=True)
            return

        # 判断网络1是否在网络2中
        if network_1 in network_2:
            # 检查网段的有效 IP 地址数量
            if len(network_2) > 2:
                # 获取可用IP范围（排除网络地址和广播地址）
                usable_range = f"{network_2[1]} 到 {network_2[-2]}"  # 排除网络地址和广播地址
                result_message = (
                    f"检测结果: True\n"
                    f"网络地址: {network_2.network}\n"
                    f"广播地址: {network_2.broadcast}\n"
                    f"可用 IP 范围: {usable_range}\n"
                    f"总共有效IP数: {len(network_2) - 2}"  # 排除网络地址和广播地址
                )
            else:
                result_message = (
                    f"检测结果: True\n"
                )
            display_result(result_message)
        else:
            display_result("检测结果: False")

        # 保存历史记录
        save_to_history("IP包含检测器", {"checker_cidr_1": cidr_1, "checker_cidr_2": cidr_2}, result_message)

        # 更新全局字典保存当前数据
        previous_data['cidr_1'] = cidr_1
        previous_data['cidr_2'] = cidr_2
        previous_data['result'] = result_message

    # 清空输入框和结果框
    def clear_all():
        cidr_entry_1.delete(0, tk.END)
        cidr_entry_2.delete(0, tk.END)
        result_display.config(state=tk.NORMAL)
        result_display.delete(1.0, tk.END)
        result_display.config(state=tk.DISABLED)

        # 清空全局数据字典
        previous_data['cidr_1'] = ''
        previous_data['cidr_2'] = ''
        previous_data['result'] = ''

    # 初始化输入框，若有上次输入数据则恢复
    cidr_entry_1 = create_input_field(frame, "请输入需要验证的CIDR或IP： \n (A, A ∈ B)", previous_data['cidr_1'])
    cidr_entry_2 = create_input_field(frame, "请输入目标CIDR网段： \n (B, B ⊃ A)", previous_data['cidr_2'])

    # 按钮布局
    button_frame = tk.Frame(frame)
    button_frame.pack(pady=10)

    tk.Button(button_frame, text="检测", command=check_inclusion, width=12).pack(side=tk.LEFT, padx=5)
    tk.Button(button_frame, text="清空", command=clear_all, width=12).pack(side=tk.LEFT, padx=5)

    # 结果显示框，若有上次结果则恢复
    result_display = tk.Text(frame, font=("仿宋", 12), height=10, width=50, wrap=tk.WORD, state=tk.DISABLED)
    result_display.pack(pady=10)

    # 恢复上一次结果显示
    if previous_data['result']:
        display_result(previous_data['result'])

    # 定义标签：错误信息为红色、微软雅黑字体、15号大小、加粗
    result_display.tag_config('error', foreground='red', font=("微软雅黑", 15, 'bold'), justify='center')

    # 添加右键菜单
    attach_result_right_click_menu(result_display, frame)  # 修正这里传递正确的组件
