# Network Calculator

A modern network calculator application providing professional IP address calculation, subnetting, route aggregation, and more. Built with Flutter, supporting Windows desktop and Web platforms.

**Language / 语言 / 言語**: [简体中文](README.md) | [English](README_EN.md) | [日本語](README_JA.md)

![Version](https://img.shields.io/badge/version-1.6.0-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## ✨ Features

### Core Calculation Functions

- **IP Address Calculator** - Calculate network information, broadcast address, available hosts, etc.
- **Subnet Mask Calculator** - Calculate network parameters based on host count or subnet mask, with binary and hexadecimal display support
- **IP Base Converter** - Convert IP addresses between binary, decimal, and hexadecimal
- **Route Aggregation Calculator** - Merge multiple subnets into CIDR address blocks with two aggregation algorithms
- **Supernet Split Calculator** - Split large address blocks into multiple small network segments
- **IP Inclusion Checker** - Check if an IP address or network segment is contained within another segment

### User Experience

- 🎨 **Modern UI** - NetEase Cloud Music style interface design
- 🌓 **Theme Switching** - Support for light/dark themes with multiple color options
- 🌍 **Multi-language Support** - Simplified Chinese, Traditional Chinese, English, Japanese
- 📝 **History Records** - Automatically save calculation history with search, import, and export support
- 🔄 **State Persistence** - Automatically save input state, no data loss when switching pages
- 📱 **Responsive Design** - Adapts to different screen sizes with adaptive sidebar width
- 🎯 **Sidebar Sorting** - Support for drag-and-drop sorting and item locking

## 🛠️ Tech Stack

- **Framework**: Flutter 3.0+
- **State Management**: Provider
- **Localization**: flutter_localizations + intl
- **Data Storage**: SharedPreferences + File System
- **UI Components**: Material Design 3
- **Icons**: Material Symbols Icons

## 📋 Requirements

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Windows 10/11 (Desktop version)
- Modern browser (Web version)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd Network-Calculator
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the Project

**Desktop (Windows):**
```bash
flutter run -d windows
```

**Web:**
```bash
flutter run -d chrome
```

### 4. Build Release Version

**Windows Desktop Application:**
```bash
flutter build windows --release
```

**Web Application:**
```bash
flutter build web --release
```

## 🔧 Build Instructions

### Windows Desktop Build

1. **Ensure Flutter Environment is Configured Correctly**
   ```bash
   flutter doctor
   ```

2. **Build Release Version**
   ```bash
   flutter build windows --release
   ```

3. **Output Location**
   - Build artifacts located at: `build\windows\x64\runner\Release\`
   - Executable file: `network_calculator.exe`

### Web Build

1. **Build Web Version**
   ```bash
   flutter build web --release
   ```

2. **Output Location**
   - Build artifacts located at: `build\web\`
   - Can be directly deployed to a web server

### Create Installer with Inno Setup

The project includes an Inno Setup script to create Windows installers:

```bash
# Run Inno Setup build script
.\InnoSetup.bat
```

## ❗ Common Issues

### Flutter Build Failures

#### 1. Dependency Issues

**Problem**: `flutter pub get` fails or dependency conflicts

**Solution**:
```bash
# Clean cache
flutter clean
flutter pub cache repair

# Re-fetch dependencies
flutter pub get
```

#### 2. Windows Plugin Build Failures

**Problem**: Windows platform plugin compilation errors

**Solution**:
```bash
# Run fix script
.\fix_windows_plugins.ps1
# or
.\fix_windows_plugins.bat

# Rebuild
flutter build windows --release
```

#### 3. CMake Errors

**Problem**: CMake configuration or compilation failures

**Solution**:
```bash
# Clean build cache
flutter clean
rmdir /s /q build\windows

# Rebuild
flutter build windows --release
```

#### 4. Symbolic Link Issues (Windows)

**Problem**: Symbolic link related errors during build

**Solution**:
```bash
# Run symbolic link fix script
.\fix_symlink_issue.ps1
# or
.\fix_symlink_issue.bat
```

#### 5. Localization File Generation Failure

**Problem**: Localization files not generated after `flutter pub get`

**Solution**:
```bash
# Manually generate localization files
flutter gen-l10n

# Or re-run
flutter pub get
```

#### 6. Web Platform Build Failures

**Problem**: Errors during Web build

**Solution**:
```bash
# Clean Web build cache
flutter clean
rmdir /s /q build\web

# Check Web support
flutter config --enable-web

# Rebuild
flutter build web --release
```

### Runtime Issues

#### 1. History Import/Export Not Working (Web Platform)

**Problem**: Garbled text when importing history records in Chrome browser

**Solution**: 
- Ensure JSON files use UTF-8 encoding
- Fixed: Uses `utf8.decode()` to correctly decode file content

#### 2. Sidebar Drag-and-Drop Sorting Not Working

**Problem**: Long-press lock/unlock feature not working

**Solution**: 
- Need to enable "Sidebar Drag Sort" in settings
- Long-press lock/unlock only works when drag sorting is enabled

#### 3. Theme Switching Not Working

**Problem**: Interface doesn't change after switching themes

**Solution**:
```bash
# Restart the application
# Or clean cache and re-run
flutter clean
flutter run
```

## 📁 Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── models/              # Data models
│   ├── providers/           # State management
│   ├── services/           # Business logic services
│   ├── theme/               # Theme configuration
│   └── utils/               # Utility classes
├── l10n/                    # Localization files
│   ├── app_zh.arb           # Simplified Chinese
│   ├── app_zh_TW.arb        # Traditional Chinese
│   ├── app_en.arb           # English
│   └── app_ja.arb            # Japanese
└── ui/                      # UI interface
    ├── screens/             # Pages
    └── widgets/             # Components
```

## 🎨 Custom Configuration

### Modify Sidebar Width

Edit `lib/ui/screens/main_screen.dart`:

```dart
// Default width: 240, max width for large screens (width > 1600): 270
final sidebarWidth = screenWidth > 1600 ? 270.0 : 240.0;
```

### Add New Calculator

1. Create service class in `lib/core/services/`
2. Create interface in `lib/ui/screens/calculator_screens/`
3. Register in `lib/ui/screens/main_navigation_items.dart`

### Add New Language

1. Create `app_xx.arb` file in `lib/l10n/`
2. Run `flutter gen-l10n` to generate code
3. Add to `supportedLocales` in `lib/main.dart`

## 📝 Development Guide

### Code Standards

The project uses `flutter_lints` for code checking to ensure code quality:

```bash
# Run code analysis
flutter analyze
```

### Localization Development

1. Modify `lib/l10n/app_zh.arb` (template file)
2. Synchronously update other language files
3. Run `flutter gen-l10n` to generate code

### Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test
```

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork this project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - Cross-platform UI framework
- [Material Symbols Icons](https://fonts.google.com/icons) - Icon library
- All contributors and users for their support

## 📞 Contact

For questions or suggestions, please contact us through:

- Submit an [Issue](https://github.com/your-repo/issues)
- Send an email

---

**Note**: This project is still under active development. Please provide feedback if you encounter any issues.

