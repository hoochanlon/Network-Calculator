# gui_calc_history_manager.py
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import tkinter as tk
from tkinter import messagebox, filedialog
import json
from core.calc_history_manager import load_history, clear_history, delete_history_record

# 查看历史记录的对话框
def show_history():
    history = load_history()
    if not history:
        messagebox.showinfo("历史记录", "没有历史记录可显示！")
        return

    history_window = tk.Toplevel()
    history_window.title("历史记录")
    history_window.geometry("600x480")
    history_window.resizable(False, False)

    # 顶部搜索框
    def search_records():
        search_term = search_entry.get().strip().lower()
        listbox.delete(0, tk.END)  # 清空列表
        for idx, record in enumerate(history):
            record_text = f"{record['calculator']} - {record['result']}".lower()
            if search_term in record_text:
                listbox.insert(tk.END, f"{idx + 1}. {record['calculator']} - {record['result']}")

        if listbox.size() == 0:
            messagebox.showinfo("搜索结果", "未找到匹配的记录。")

    search_frame = tk.Frame(history_window)
    search_frame.pack(pady=10)

    search_label = tk.Label(search_frame, text="查询记录:")
    search_label.pack(side=tk.LEFT, padx=5)

    search_entry = tk.Entry(search_frame, width=40)
    search_entry.pack(side=tk.LEFT, padx=5)

    search_button = tk.Button(search_frame, text=" 搜索🔍 ", command=search_records)
    search_button.pack(side=tk.LEFT, padx=5)


    # 创建 Listbox 和 滚动条
    listbox_frame = tk.Frame(history_window)
    listbox_frame.pack(pady=10)

    # Initialize with multiple selection mode
    listbox = tk.Listbox(listbox_frame, width=80, height=20, selectmode=tk.MULTIPLE)
    listbox.pack(side=tk.LEFT, fill=tk.Y)

    scrollbar = tk.Scrollbar(listbox_frame, orient=tk.VERTICAL, command=listbox.yview)
    scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

    listbox.config(yscrollcommand=scrollbar.set)

    # 填充历史记录到 Listbox
    for idx, record in enumerate(history):
        listbox.insert(tk.END, f"{idx + 1}. {record['calculator']} - {record['result']}")

    # 常规右键菜单功能
    # def show_popup_menu(event):
    #     popup_menu.post(event.x_root, event.y_root)

    def show_popup_menu(event):
        # 动态检查选中项并更新菜单项状态
        if listbox.curselection():  # 检查是否有选中的记录
            popup_menu.entryconfig("复制", state=tk.NORMAL)  # 启用“复制”
            popup_menu.entryconfig("查看", state=tk.NORMAL)
            popup_menu.entryconfig("删除", state=tk.NORMAL)
        else:
            popup_menu.entryconfig("复制", state=tk.DISABLED)  # 禁用“复制”
            popup_menu.entryconfig("查看", state=tk.DISABLED)
            popup_menu.entryconfig("删除", state=tk.DISABLED)
            

        
        # 显示右键菜单
        popup_menu.post(event.x_root, event.y_root)


    # 详情查看
    def look_record():
        selected_indices = listbox.curselection()
        if selected_indices:
            selected_index = selected_indices[0]
            selected_record = history[selected_index]
            
            # 获取 inputs 字典中的内容，直接提取对应键的值
            ip = selected_record['inputs'].get('ip', None)
            mask = selected_record['inputs'].get('mask', None)
            hosts = selected_record['inputs'].get('hosts', None)
            subnet_input = selected_record['inputs'].get('subnet_input', None)
            symbol = selected_record['inputs'].get('symbol', None)
            network_merge_input = selected_record['inputs'].get('network_merge_input', None)
            supernet_split_input = selected_record['inputs'].get('supernet_split_input', None)
            checker_cidr_1 = selected_record['inputs'].get('checker_cidr_1', None)
            checker_cidr_2 = selected_record['inputs'].get('checker_cidr_2', None)

            # 动态检查是否有值，若没有则跳过该字段
            inputs_str = ""
            if ip:
                inputs_str += f"IP地址: {ip}\n"
            if mask:
                inputs_str += f"子网掩码: {mask}\n"
            if hosts:
                inputs_str += f"主机数: {hosts}\n"
            if subnet_input:
                inputs_str += f"子网输入: {subnet_input}\n"
            if symbol:
                inputs_str += f"输入字符: {symbol}\n"
            if network_merge_input:
                inputs_str += f"需要合并的网段:\n{network_merge_input}\n"
            if supernet_split_input:
                inputs_str += f"需要拆分的超网及目标长度:\n{supernet_split_input}\n"
            if checker_cidr_1:
                inputs_str += f"需要验证的CIDR或IP：\n{checker_cidr_1}\n"
            if checker_cidr_2:
                inputs_str += f"目标CIDR网段： \n{checker_cidr_2}\n"

            # 如果没有任何输入信息，显示默认提示
            if not inputs_str:
                inputs_str = "没有输入信息"

            # 创建可复制文本框
            detail_window = tk.Toplevel()
            detail_window.title("记录详情")
            detail_window.geometry("400x400")
            detail_window.resizable(False, False)

            # 创建 Text 控件来显示详情，并禁用粘贴功能
            detail_text = tk.Text(detail_window, wrap=tk.WORD, height=25, width=60, font=("仿宋", 11))
            detail_text.pack(padx=10, pady=10)
            detail_text.insert(tk.END, f"\n输入:\n{inputs_str}\n\n结果:\n{selected_record['result']}")
            detail_text.config(state=tk.DISABLED)  # 禁止编辑

            # 禁止粘贴功能
            detail_text.bind("<Button-3>", lambda event: None)  # 禁用右键菜单
            detail_text.bind("<Control-v>", lambda event: "break")  # 禁用 Ctrl+V 粘贴

        else:
            messagebox.showwarning("选择记录", "请先选择一个历史记录进行查看。")

    # 删除记录
    def delete_record():
        selected_indices = listbox.curselection()
        if selected_indices:
            for selected_index in reversed(selected_indices):
                if delete_history_record(selected_index):
                    listbox.delete(selected_index)
                else:
                    messagebox.showwarning("删除失败", f"无法删除记录 {selected_index + 1}.")
        else:
            messagebox.showwarning("选择记录", "请先选择一个历史记录进行删除。")

    # 清空历史记录
    def clear_all_history():
        if messagebox.askyesno("清空历史", "确认清空所有历史记录吗？"):
            clear_history()
            listbox.delete(0, tk.END)  # 清空 Listbox 中的内容
            # messagebox.showinfo("清空成功", "历史记录已清空！")
            # show_history()  # 重新加载历史记录窗口

    # 导出历史记录为 JSON 文件
    def export_history_to_json():
        # 弹出文件保存对话框
        file_path = filedialog.asksaveasfilename(defaultextension=".json", filetypes=[("JSON Files", "*.json")])
        if file_path:
            try:
                with open(file_path, "w", encoding="utf-8") as f:
                    json.dump(history, f, ensure_ascii=False, indent=4)
            except Exception as e:
                messagebox.showerror("导出失败", f"导出失败: {e}")
    
    def copy_record():
        selected_indices = listbox.curselection()  # 获取所有选中的记录
        if selected_indices:
            copy_text = ""  # 用于存储所有选中记录的文本内容
            
            # 遍历选中的记录并构建文本
            for selected_index in selected_indices:
                selected_record = history[selected_index]
                
                record_text = f"{selected_record['calculator']} - {selected_record['result']}"
                ip = selected_record['inputs'].get('ip', None)
                mask = selected_record['inputs'].get('mask', None)
                hosts = selected_record['inputs'].get('hosts', None)
                subnet_input = selected_record['inputs'].get('subnet_input', None)
                symbol = selected_record['inputs'].get('symbol', None)
                network_merge_input = selected_record['inputs'].get('network_merge_input', None)
                supernet_split_input = selected_record['inputs'].get('supernet_split_input', None)
                checker_cidr_1 = selected_record['inputs'].get('checker_cidr_1', None)
                checker_cidr_2 = selected_record['inputs'].get('checker_cidr_2', None)                

                inputs_str = ""
                if ip:
                    inputs_str += f"IP地址: {ip}\n"
                if mask:
                    inputs_str += f"子网掩码: {mask}\n"
                if hosts:
                    inputs_str += f"主机数: {hosts}\n"
                if subnet_input:
                    inputs_str += f"子网输入: {subnet_input}\n"
                if symbol:
                    inputs_str += f"输入字符: {symbol}\n"
                if network_merge_input:
                    inputs_str += f"需要合并的网段:\n{network_merge_input}\n"
                if supernet_split_input:
                    inputs_str += f"需要拆分的超网及目标长度:\n{supernet_split_input}\n"
                if checker_cidr_1:
                    inputs_str += f"需要验证的CIDR或IP：\n{checker_cidr_1}\n"
                if checker_cidr_2:
                    inputs_str += f"目标CIDR网段： \n{checker_cidr_2}\n"

                if not inputs_str:
                    inputs_str = "没有输入信息"

                # 将每条记录的内容添加到 copy_text 中
                copy_text += f"\n记录:\n{record_text}\n输入:\n{inputs_str}\n结果:\n{selected_record['result']}\n\n"

            # 将文本内容复制到剪贴板
            history_window.clipboard_clear()
            history_window.clipboard_append(copy_text)
            history_window.update()

        #     messagebox.showinfo("复制成功", f"{len(selected_indices)} 条记录已复制到剪贴板。")
        # else:
        #     messagebox.showwarning("选择记录", "请先选择一些历史记录进行复制。")


    # 创建右键菜单
    popup_menu = tk.Menu(history_window, tearoff=0)
    popup_menu.add_command(label="查看", command=look_record)
    popup_menu.add_command(label="复制", command=copy_record)
    popup_menu.add_command(label="删除", command=delete_record)

    # 绑定右键点击事件
    listbox.bind("<Button-3>", show_popup_menu)

    # 鼠标拖动选择功能
    is_dragging = False
    start_index = None

    def on_select_start(event):
        nonlocal is_dragging, start_index
        is_dragging = True
        start_index = listbox.nearest(event.y)  # 获取鼠标按下时的目标项
        if start_index >= 0:
            listbox.select_clear(0, tk.END)  # 清除当前的选择

    def on_select_drag(event):
        if is_dragging:
            current_index = listbox.nearest(event.y)  # 获取当前拖动时的目标项
            if current_index >= 0:
                listbox.select_set(start_index, current_index)  # 从起始项到当前项的范围选择

    def on_select_release(event):
        nonlocal is_dragging
        is_dragging = False  # 停止拖动

    listbox.bind("<ButtonPress-1>", on_select_start)  # 按下左键时开始拖动
    listbox.bind("<B1-Motion>", on_select_drag)  # 拖动过程中更新选择
    listbox.bind("<ButtonRelease-1>", on_select_release)  # 松开左键时停止拖动

    # 按钮区域
    button_frame = tk.Frame(history_window)
    button_frame.pack(pady=5)

    restore_button = tk.Button(button_frame, text="查看详情", command=look_record)
    restore_button.pack(side=tk.LEFT, padx=5)

    delete_button = tk.Button(button_frame, text="删除记录", command=delete_record)
    delete_button.pack(side=tk.LEFT, padx=5)

    clear_button = tk.Button(button_frame, text="清空历史", command=clear_all_history)
    clear_button.pack(side=tk.LEFT, padx=5)

    export_button = tk.Button(button_frame, text="导出历史记录", command=export_history_to_json)  # 新增导出按钮
    export_button.pack(side=tk.LEFT, padx=5)



