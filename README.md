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

## 许可证

与原项目保持一致。

## 开发者

基于原 Python 版本改写的 Flutter 版本，保持了所有核心功能的完整性。

