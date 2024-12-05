# pyinstaller_output_cmd.py
import subprocess
import os
from core.calc_history_manager import clear_history

# 获取用户桌面路径
Desktop_dir = os.path.join(os.path.expanduser("~"), "Desktop")
project_directory = os.path.join(Desktop_dir, "Network-Calculator")

def generate_pyinstaller_command():
    """
    生成 PyInstaller 命令（支持多行命令）。
    """

    # 设置各个文件的路径
    main_file = os.path.join(project_directory, "main.py")
    logo_icon = os.path.join(project_directory, "images", "logo.ico")
    docs_directory = os.path.join(project_directory, "docs")
    images_directory = os.path.join(project_directory, "images")

    # 设置输出路径为桌面
    dist_directory = Desktop_dir

    # 生成 pyinstaller 命令，拆分为多行
    pyinstaller_cmd = (
        f'pyinstaller -w -F -i "{logo_icon}" '
        f'--onefile '
        f'--add-data "{docs_directory};docs" '
        f'--add-data "{images_directory};images" '
        f'--name "IP地址规划计算器v1.3.1" '
        f'--distpath "{dist_directory}" '
        f'"{main_file}"'
    )

    return pyinstaller_cmd

def save_command_to_txt(cmd):
    """
    保存生成的 PyInstaller 命令到一个文本文件。
    """
    # 设置保存路径
    txt_file_path = os.path.join(project_directory, "pyinstaller_command.txt")

    # 将命令写入文件
    with open(txt_file_path, "w", encoding="utf-8") as file:
        file.write(cmd)

    print(f"命令已保存到 {txt_file_path} 文件")

def run_pyinstaller_command():
    """
    运行生成的 PyInstaller 命令，并保存命令到文本文件。
    """
    cmd = generate_pyinstaller_command()

    # 保存命令到文本文件
    save_command_to_txt(cmd)

    # 打印命令以便确认
    print("正在执行命令：")
    print(cmd)

    try:
        # 使用 subprocess.run 来执行命令
        subprocess.run(cmd, shell=True, check=True)
        print("PyInstaller 打包完成！")
    except subprocess.CalledProcessError as e:
        print(f"运行 PyInstaller 命令时发生错误：{e}")
    except Exception as e:
        print(f"发生错误：{e}")

# 执行命令
if __name__ == "__main__":
    clear_history()
    run_pyinstaller_command()


# 打包成一个无黑窗、有图片、图标、文件，等其他素材在内的，一个完整的 EXE 运行程序。
'''
pyinstaller -w -F -i "C:\\Users\\胡成龙\\Desktop\\Network-Calculator\\images\\logo.ico" --onefile ^
--add-data "C:\\Users\\胡成龙\\Desktop\\Network-Calculator\\docs;docs" ^
--add-data "C:\\Users\\胡成龙\\Desktop\\Network-Calculator\\images;images" ^
--name "IP地址规划计算器v1.3" ^
C:\\Users\\胡成龙\\Desktop\\Network-Calculator\\main.py
'''

'''
pyinstaller -w -F -i "C:\\Users\\administrator\\Desktop\\Network-Calculator\\images\\logo.ico" --onefile ^
--add-data "C:\\Users\\administrator\\Desktop\\Network-Calculator\\docs;docs" ^
--add-data "C:\\Users\\administrator\\Desktop\\Network-Calculator\\images;images" ^
--name "IP地址规划计算器v1.3" ^
C:\\Users\\administrator\\Desktop\\Network-Calculator\\main.py
'''