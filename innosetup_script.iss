; Inno Setup 安装脚本
; 用于打包 Flutter Windows 应用
; 支持国际化：中文、英文、日文
; 使用方法：在 Inno Setup 中打开此文件，然后按 F9 编译

#define AppVersion "1.6.0"
#define AppPublisher "Hoochanlon"
#define AppExeName "network_calculator.exe"
#define AppURL "https://github.com/hoochanlon/network-calculator"

[Setup]
AppName={cm:AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
; 发布者网址（显示在"程序和功能"中）
AppPublisherURL={#AppURL}
; 支持链接（帮助和支持）
AppSupportURL={#AppURL}
; 更新信息链接
AppUpdatesURL={#AppURL}
DefaultDirName={autopf}\NetworkCalculator
DefaultGroupName={cm:AppName}
OutputDir=installer
OutputBaseFilename=NetworkCalculator_Setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
ArchitecturesInstallIn64BitMode=x64
DisableProgramGroupPage=yes
UsePreviousLanguage=no
; 指定安装程序本身显示的图标
SetupIconFile=windows\runner\resources\app_icon.ico
; 指定"程序和功能"列表中显示的图标（重要：必须指向可执行文件或图标文件）
UninstallDisplayIcon={app}\{#AppExeName}
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
english.CreateDesktopIcon=Create a desktop icon
english.AdditionalIcons=Additional icons:
english.LaunchProgram=Launch Network Calculator

; 要启用中文和日文的自定义消息，请先在 [Languages] 部分取消对应语言的注释
; Chinese Simplified
; chinesesimp.AppName=网络计算器
; chinesesimp.AppPublisher=网络计算器
; chinesesimp.CreateDesktopIcon=创建桌面图标
; chinesesimp.AdditionalIcons=附加图标:
; chinesesimp.LaunchProgram=启动网络计算器

; Japanese
; japanese.AppName=ネットワーク計算機
; japanese.AppPublisher=ネットワーク計算機
; japanese.CreateDesktopIcon=デスクトップアイコンを作成
; japanese.AdditionalIcons=追加アイコン:
; japanese.LaunchProgram=ネットワーク計算機を起動

[Files]
; 包含所有必要的文件
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; 如果应用有图标，取消下面的注释并指定图标路径
; Source: "assets\images\logo.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{cm:AppName}"; Filename: "{app}\{#AppExeName}"
Name: "{autodesktop}\{cm:AppName}"; Filename: "{app}\{#AppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Windows\Start Menu\Programs\{cm:AppName}"; Filename: "{app}\{#AppExeName}"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Run]
Filename: "{app}\{#AppExeName}"; Description: "{cm:LaunchProgram}"; Flags: nowait postinstall skipifsilent

[Code]
// 可选：添加自定义代码
// 例如：检查 .NET Framework 版本等
