# Inno Setup 打包 Flutter Windows 应用详细指南

## 第一步：下载并安装 Inno Setup

1. 访问官网：https://jrsoftware.org/isdl.php
2. 下载最新版本（推荐下载完整版，包含所有功能）
3. 安装 Inno Setup（安装过程很简单，一直点下一步即可）

---

## 第二步：准备文件

确保你已经构建了 Flutter 应用：

```bash
flutter build windows --release
```

构建完成后，文件位于：`build\windows\x64\runner\Release\`

---

## 第三步：使用 Inno Setup 脚本向导（推荐新手）

### 方法 A：使用脚本向导

1. **打开 Inno Setup**
2. **选择 "File" > "New"** 或直接关闭欢迎窗口
3. **选择 "Create a new script file using the Script Wizard"**
4. **按照向导填写信息：**

   - **Application name（应用名称）**: 网络计算器
   - **Application version（版本）**: 1.0.0
   - **Application publisher（发布者）**: Network Calculator
   - **Application website（网站）**: （可选，留空）
   - **Application folder（安装文件夹）**: NetworkCalculator
   - **Allow user to change the application folder**: 勾选

5. **选择应用程序文件：**
   - 点击 "Add file(s)..." 
   - 选择 `build\windows\x64\runner\Release\network_calculator.exe`
   - 选择 `build\windows\x64\runner\Release\flutter_windows.dll`
   - 点击 "Add folder(s)..."
   - 选择 `build\windows\x64\runner\Release\data` 文件夹

6. **选择应用程序图标（可选）：**
   - 如果有图标文件，可以添加

7. **选择安装程序选项：**
   - **Allow user to create a desktop icon**: 勾选（创建桌面快捷方式）
   - **Allow user to start the application after Setup has finished**: 勾选（安装后运行）

8. **选择安装程序语言：**
   - 选择 "Simplified Chinese"（简体中文）和 "English"

9. **选择编译设置：**
   - **Custom compiler output folder**: 可以设置为 `installer` 文件夹
   - **Custom setup filename**: NetworkCalculator_Setup

10. **完成向导**
    - 点击 "Next" > "Finish"
    - 保存脚本文件（建议保存为 `innosetup_script.iss`）

11. **编译安装程序**
    - 点击工具栏的 "Compile" 按钮（或按 F9）
    - 等待编译完成
    - 安装程序会生成在 `installer` 文件夹中

---

## 第四步：使用现有脚本文件（推荐有经验用户）

如果你已经有 `innosetup_script.iss` 文件：

1. **打开 Inno Setup**
2. **选择 "File" > "Open"**
3. **选择项目根目录下的 `innosetup_script.iss` 文件**
4. **检查脚本中的路径是否正确：**
   ```iss
   Source: "build\windows\x64\runner\Release\*"; 
   ```
   确保这个路径相对于脚本文件位置是正确的

5. **编译安装程序：**
   - 点击工具栏的 "Compile" 按钮（或按 F9）
   - 或者选择 "Build" > "Compile"

6. **查看输出：**
   - 编译成功后，安装程序会生成在 `installer` 文件夹中
   - 文件名：`NetworkCalculator_Setup.exe`

---

## 第五步：测试安装程序

1. 双击生成的 `NetworkCalculator_Setup.exe`
2. 按照安装向导完成安装
3. 测试应用是否能正常运行
4. 检查桌面快捷方式是否创建成功

---

## 常见问题

### Q1: 编译时提示找不到文件？
**A:** 检查脚本中的路径是否正确，确保 `build\windows\x64\runner\Release\` 文件夹存在且包含所有文件。

### Q2: 如何修改安装程序图标？
**A:** 在 `[Setup]` 部分添加：
```iss
SetupIconFile=path\to\your\icon.ico
```

### Q3: 如何添加卸载程序？
**A:** Inno Setup 会自动创建卸载程序，无需额外配置。

### Q4: 如何修改安装程序语言？
**A:** 在 `[Languages]` 部分修改或添加语言文件。

### Q5: 安装程序太大怎么办？
**A:** 脚本中已启用 LZMA 压缩，如果还觉得大，可以尝试：
```iss
Compression=lzma2/ultra64
```

---

## 脚本说明

项目根目录下的 `innosetup_script.iss` 已经配置好了基本设置：

- ✅ 应用名称：网络计算器
- ✅ 版本：1.0.0
- ✅ 自动包含所有必要文件
- ✅ 创建桌面快捷方式（可选）
- ✅ 支持中英文界面
- ✅ 安装后可选运行程序

---

## 快速开始

1. 确保已构建应用：`flutter build windows --release`
2. 打开 Inno Setup
3. 打开 `innosetup_script.iss`
4. 按 F9 编译
5. 在 `installer` 文件夹中找到安装程序

完成！🎉

