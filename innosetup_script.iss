; Inno Setup 安装脚本
; 用于打包 Flutter Windows 应用
; 使用方法：在 Inno Setup 中打开此文件，然后按 F9 编译

#define AppName "网络计算器"
#define AppVersion "1.0.0"
#define AppPublisher "Network Calculator"
#define AppExeName "network_calculator.exe"

[Setup]
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
DefaultDirName={autopf}\NetworkCalculator
DefaultGroupName={#AppName}
OutputDir=installer
OutputBaseFilename=NetworkCalculator_Setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
ArchitecturesInstallIn64BitMode=x64
DisableProgramGroupPage=yes
LicenseFile=
InfoBeforeFile=
InfoAfterFile=

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
; 如果需要中文界面，请先下载中文语言包：
; 1. 访问 https://jrsoftware.org/files/istrans/
; 2. 下载 ChineseSimplified.isl
; 3. 放到 Inno Setup 的 Languages 文件夹中
; 4. 取消下面一行的注释
; Name: "chinesesimp"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"

[Files]
; 包含所有必要的文件
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; 如果应用有图标，取消下面的注释并指定图标路径
; Source: "assets\images\logo.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Windows\Start Menu\Programs\{#AppName}"; Filename: "{app}\{#AppExeName}"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Run]
Filename: "{app}\{#AppExeName}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent

[Code]
// 可选：添加自定义代码
// 例如：检查 .NET Framework 版本等

