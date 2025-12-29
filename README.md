# 网络计算器 Flutter 版本

这是一个功能完整的网络计算器应用，采用 Flutter 开发，具有现代化的网易云音乐风格界面，支持中英文国际化。

## 功能特性

### 核心功能

1. **IP地址计算器**
   - 计算网络地址、广播地址
   - 计算可用IP数量
   - 显示二进制和十六进制表示
   - 支持CIDR格式

2. **子网掩码计算器**
   - 根据主机数计算子网掩码
   - 根据子网掩码计算可用主机数
   - 显示反掩码、二进制和十六进制表示

3. **IP进制转换器**
   - 支持二进制、十进制、十六进制转换
   - 支持点分格式和无点分格式
   - 计算反码

4. **路由聚合计算器**
   - 合并多个CIDR格式的网络
   - 计算超网

5. **超网拆分计算器**
   - 将超网拆分为多个子网
   - 支持指定目标子网掩码长度

6. **IP包含检测器**
   - 检测一个CIDR是否包含在另一个CIDR中
   - 显示网络地址、广播地址和可用IP范围

### 辅助功能

- **历史记录管理**：保存、查看、删除和导出计算历史
- **多语言支持**：支持中文和英文
- **主题切换**：支持深色、浅色和系统主题
- **现代化UI**：网易云音乐风格的界面设计

## 项目结构

```
lib/
├── core/
│   ├── models/           # 数据模型
│   ├── providers/        # 状态管理
│   ├── services/         # 业务逻辑服务
│   └── theme/            # 主题配置
├── l10n/                 # 国际化资源
└── ui/
    └── screens/          # UI界面
        ├── calculator_screens/  # 各个计算器页面
        ├── history_screen.dart
        └── settings_screen.dart
```

## 安装和运行

### 前置要求

- Flutter SDK (>=3.0.0)
- Dart SDK

### 安装步骤

1. 克隆项目或下载源码

2. 安装依赖：
```bash
flutter pub get
```

3. 生成国际化文件：
```bash
flutter gen-l10n
```

4. 运行应用：
```bash
flutter run
```

### 构建发布版本

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Windows:**
```bash
flutter build windows --release
```

**macOS:**
```bash
flutter build macos --release
```

**Linux:**
```bash
flutter build linux --release
```

## 技术栈

- **Flutter**: 跨平台UI框架
- **Provider**: 状态管理
- **shared_preferences**: 本地数据持久化
- **intl**: 国际化支持
- **Material Design 3**: 现代化UI设计

## 模块化设计

项目采用模块化设计，主要模块包括：

1. **核心服务层** (`core/services/`)
   - `ip_calculator_service.dart`: IP地址计算
   - `subnet_calculator_service.dart`: 子网计算
   - `base_converter_service.dart`: 进制转换
   - `network_merge_service.dart`: 网络合并
   - `network_split_service.dart`: 网络拆分
   - `ip_inclusion_service.dart`: IP包含检测
   - `history_service.dart`: 历史记录管理

2. **UI层** (`ui/screens/`)
   - 各个功能页面的独立实现
   - 统一的卡片式设计风格

3. **状态管理** (`core/providers/`)
   - `locale_provider.dart`: 语言切换
   - `theme_provider.dart`: 主题切换

## 界面设计

采用网易云音乐风格的设计：

- **深色主题**：深色背景 (#1E1E1E)，卡片颜色 (#333333)
- **主色调**：网易云红 (#EC4141)
- **圆角设计**：统一的16px圆角
- **卡片式布局**：清晰的信息层次
- **现代化交互**：流畅的动画和过渡效果

## 国际化

支持的语言：
- 中文 (简体)
- English

所有文本都通过 `AppLocalizations` 进行管理，便于扩展更多语言。

## 故障排除

### Windows 平台插件问题

#### 问题现象

在 Windows 平台运行应用时，可能会遇到以下错误：

```
MissingPluginException: No implementation found for method getAll on channel plugins.flutter.io/shared_preferences
```

或者在构建时出现：

```
Package path_provider:windows references path_provider_windows:windows as the default plugin, but the package does not exist
```

#### 问题原因

1. **缺少 Windows 平台实现包**：Flutter 的某些插件（如 `shared_preferences`、`path_provider`、`url_launcher`）需要单独的 Windows 平台实现包，这些包不会自动包含在主包中。

2. **插件注册文件未生成**：添加 Windows 平台包后，需要重新生成插件注册文件（`generated_plugin_registrant.cc`），否则插件无法正确注册。

3. **构建缓存问题**：旧的构建缓存可能包含过期的插件信息，导致新添加的插件无法被识别。

#### 一键修复方法

**方法一：使用修复脚本（推荐）**

在项目根目录运行：

**Windows 命令提示符 (CMD):**
```bash
fix_windows_plugins.bat
```

**PowerShell:**
```powershell
.\fix_windows_plugins.ps1
```

该脚本会自动执行以下步骤：
1. 清理项目构建缓存
2. 重新获取所有依赖包
3. 重新生成插件注册文件
4. 构建 Windows 应用验证修复

**方法二：手动修复**

如果脚本无法运行，可以手动执行以下命令：

```bash
# 1. 清理项目
flutter clean

# 2. 重新获取依赖
flutter pub get

# 3. 重新构建（这会自动重新生成插件注册文件）
flutter build windows --debug
```

#### 预防措施

确保 `pubspec.yaml` 中包含以下 Windows 平台实现包：

```yaml
dependencies:
  shared_preferences: ^2.2.2
  shared_preferences_windows: ^2.4.1  # Windows 平台实现
  path_provider: ^2.1.2
  path_provider_windows: ^2.3.0       # Windows 平台实现
  url_launcher: ^6.2.5
  url_launcher_windows: ^3.1.5        # Windows 平台实现
```

**注意**：`package_info_plus` 从 9.0.0 版本开始已经内置了 Windows 支持，不需要单独的 Windows 包。

#### 其他常见问题

**问题：构建时提示找不到文件**

```
Error when reading 'file_picker-8.3.7/lib/file_picker.dart': 系统找不到指定的文件
```

**解决方案**：更新到最新版本的包，旧版本可能已从 pub cache 中移除：

```bash
flutter pub upgrade
```

**问题：插件注册警告**

看到以下警告是正常的，可以忽略：

```
Package path_provider:windows references path_provider_windows:windows as the default plugin...
```

这些警告不会影响应用的正常运行。

## 许可证

与原项目保持一致。

## 开发者

基于原 Python 版本改写的 Flutter 版本，保持了所有核心功能的完整性。

