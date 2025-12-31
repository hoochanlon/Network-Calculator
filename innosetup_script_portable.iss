; Inno Setup 便携版（绿色版）打包脚本
; 用于打包 Flutter Windows 应用为便携版
; 支持国际化：中文、英文、日文
; 使用方法：在 Inno Setup 中打开此文件，然后按 F9 编译
; 
; 便携版特点：
; - 不需要安装，解压即可使用
; - 所有文件都在一个文件夹中
; - 不会在注册表中创建条目
; - 不会创建开始菜单快捷方式（除非用户手动创建）

#define AppVersion "1.6.0"
#define AppPublisher "Network Calculator"
#define AppExeName "network_calculator.exe"

[Setup]
AppName={cm:AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
DefaultDirName={autopf}\NetworkCalculator
DefaultGroupName={cm:AppName}
OutputDir=installer
OutputBaseFilename=NetworkCalculator_Portable
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
ArchitecturesInstallIn64BitMode=x64
DisableProgramGroupPage=yes
DisableDirPage=no
DisableReadyPage=no
DisableFinishedPage=no
UsePreviousLanguage=no
; 便携版设置
CreateUninstallRegKey=no
Uninstallable=no
LicenseFile=
InfoBeforeFile=
InfoAfterFile=

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
; 要启用中文和日文支持，请先下载语言文件：
; 1. 访问 https://jrsoftware.org/files/istrans/
; 2. 下载 ChineseSimplified.isl 和 Japanese.isl
; 3. 放到 Inno Setup 的 Languages 文件夹中（通常是 C:\Program Files (x86)\Inno Setup 6\Languages\）
; 4. 取消下面两行的注释
; Name: "chinesesimp"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"
; Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"

[CustomMessages]
; English (default)
english.AppName=Network Calculator
english.AppPublisher=Network Calculator
english.PortableDescription=Portable version - no installation required
english.SelectDestination=Select destination folder for portable version
english.PortableInfo=This is a portable version. All files will be extracted to the selected folder. You can run the application directly from there.

; 要启用中文和日文的自定义消息，请先在 [Languages] 部分取消对应语言的注释
; Chinese Simplified
; chinesesimp.AppName=网络计算器
; chinesesimp.AppPublisher=网络计算器
; chinesesimp.PortableDescription=便携版 - 无需安装
; chinesesimp.SelectDestination=选择便携版的目标文件夹
; chinesesimp.PortableInfo=这是便携版。所有文件将解压到所选文件夹。您可以直接从那里运行应用程序。

; Japanese
; japanese.AppName=ネットワーク計算機
; japanese.AppPublisher=ネットワーク計算機
; japanese.PortableDescription=ポータブル版 - インストール不要
; japanese.SelectDestination=ポータブル版の保存先フォルダを選択
; japanese.PortableInfo=これはポータブル版です。すべてのファイルが選択したフォルダに展開されます。そこから直接アプリケーションを実行できます。

[Files]
; 包含所有必要的文件
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; 如果应用有图标，取消下面的注释并指定图标路径
; Source: "assets\images\logo.ico"; DestDir: "{app}"; Flags: ignoreversion

; 便携版说明文件会在 PowerShell 脚本中创建

[Code]
procedure InitializeWizard;
begin
  // 自定义欢迎页面文本
  WizardForm.WelcomeLabel1.Caption := 'Welcome to the Network Calculator Portable Setup Wizard';
  WizardForm.WelcomeLabel2.Caption := 'This is a portable version. All files will be extracted to the selected folder. You can run the application directly from there.';
end;

