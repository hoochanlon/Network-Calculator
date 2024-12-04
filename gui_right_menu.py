import tkinter as tk

def attach_result_right_click_menu(result_text, parent_frame):
    """
    为指定的文本框 result_text 添加右键菜单，包括复制、全选复制和粘贴功能。
    
    :param result_text: tk.Text 文本框实例
    :param parent_frame: tk.Frame 父容器，用于操作剪贴板
    """

    def copy_selected_text():
        """复制选中的文本到剪贴板。"""
        selected_text = result_text.get(tk.SEL_FIRST, tk.SEL_LAST)
        parent_frame.clipboard_clear()
        parent_frame.clipboard_append(selected_text)
        parent_frame.update()  # 更新剪贴板内容

    def copy_all_text():
        """复制文本框中的所有文本到剪贴板。"""
        all_text = result_text.get(1.0, tk.END).strip()
        if all_text:
            parent_frame.clipboard_clear()
            parent_frame.clipboard_append(all_text)
            parent_frame.update()  # 更新剪贴板内容

    def paste_from_clipboard():
        """从剪贴板粘贴文本。"""
        clipboard_content = parent_frame.clipboard_get()
        result_text.insert(tk.INSERT, clipboard_content)  # 将内容插入到文本框当前位置

    # 创建右键菜单
    context_menu = tk.Menu(result_text, tearoff=0)
    context_menu.add_command(label="复制", command=copy_selected_text, state=tk.DISABLED)
    context_menu.add_command(label="全选复制", command=copy_all_text)
    context_menu.add_command(label="粘贴", command=paste_from_clipboard)

    def update_copy_menu_state():
        """更新“复制”菜单项的状态（启用或禁用）。"""
        try:
            result_text.get(tk.SEL_FIRST, tk.SEL_LAST)  # 检测是否有选中内容
            context_menu.entryconfig(0, state=tk.NORMAL)  # 启用“复制”
        except tk.TclError:
            context_menu.entryconfig(0, state=tk.DISABLED)  # 禁用“复制”

    # 绑定右键菜单到 result_text
    def show_context_menu(event):
        """在鼠标右键单击处显示右键菜单。"""
        update_copy_menu_state()
        context_menu.post(event.x_root, event.y_root)

    result_text.bind("<Button-3>", show_context_menu)
