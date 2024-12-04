import json
import os
import sys

# 获取当前目录路径
def get_history_file_path():
    if hasattr(sys, '_MEIPASS'):  # 如果是打包后的环境
        current_dir = sys._MEIPASS
    else:
        Desktop_dir = os.path.join(os.path.expanduser("~"), "Desktop")
        current_dir = os.path.join(Desktop_dir, "Network-Calculator")
    
    return os.path.join(current_dir, "history.json")

# 保存历史记录
def save_to_history(calculator, inputs, result):
    history_file = get_history_file_path()
    history = load_history()
    history.append({"calculator": calculator, "inputs": inputs, "result": result})
    
    with open(history_file, 'w', encoding='utf-8') as f:
        json.dump(history, f, ensure_ascii=False, indent=4)

# 加载历史记录
def load_history():
    history_file = get_history_file_path()
    if not os.path.exists(history_file):
        return []
    with open(history_file, 'r', encoding='utf-8') as f:
        return json.load(f)


def delete_history_record(index):
    history = load_history()  # 加载当前历史记录
    if index < len(history):
        # 删除指定的记录
        history.pop(index)
        # 保存更新后的历史记录到文件
        save_history(history)
        return True
    return False


# 保存更新后的历史记录
def save_history(history):
    history_file = get_history_file_path()
    with open(history_file, 'w', encoding='utf-8') as f:
        json.dump(history, f, ensure_ascii=False, indent=4)

# 清空所有历史记录
def clear_history():
    history_file = get_history_file_path()
    # 将文件内容清空
    with open(history_file, 'w', encoding='utf-8') as f:
        json.dump([], f, ensure_ascii=False, indent=4)  # 保存空列表
