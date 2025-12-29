import 'dart:io';
import 'package:flutter/material.dart';
import 'package:network_calculator/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/providers/calculator_settings_provider.dart';
import '../../core/services/history_service.dart';
import '../widgets/screen_title_bar.dart';
import 'about_screen.dart';
import 'color_theme_screen.dart';
import 'settings_dialogs.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _historyLimit = 8000;
  String? _historyStoragePath;
  String _defaultStoragePath = '';
  String _defaultStorageFilePath = '';
  bool _showAbout = false;
  bool _showColorTheme = false;
  bool _sidebarDragEnabled = false;
  bool _showAdvanced = false; // 高级设置展开状态

  @override
  void initState() {
    super.initState();
    _loadHistoryLimit();
    _loadHistoryStoragePath();
    _loadDefaultStoragePath();
    _loadSidebarDragEnabled();
    // 初始化锁定状态（仅在首次使用时）
    CalculatorSettingsProvider.initializeLockedItems();
  }

  Future<void> _loadSidebarDragEnabled() async {
    final enabled = await CalculatorSettingsProvider.getSidebarDragEnabled();
    if (mounted) {
      setState(() {
        _sidebarDragEnabled = enabled;
      });
    }
  }

  Future<void> _loadHistoryLimit() async {
    final value = await CalculatorSettingsProvider.getHistoryLimit();
    if (mounted) {
      setState(() {
        _historyLimit = value;
      });
    }
  }

  Future<void> _loadHistoryStoragePath() async {
    final value = await CalculatorSettingsProvider.getHistoryStoragePath();
    if (mounted) {
      setState(() {
        _historyStoragePath = value;
      });
    }
  }

  Future<void> _loadDefaultStoragePath() async {
    final value = await HistoryService.getDefaultStoragePath();
    final filePath = await HistoryService.getDefaultStorageFilePath();
    if (mounted) {
      setState(() {
        _defaultStoragePath = value;
        _defaultStorageFilePath = filePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          ScreenTitleBar(
            title: _showAbout
                ? l10n.about
                : _showColorTheme
                    ? l10n.colorTheme
                    : l10n.settings,
            actions: _showAbout || _showColorTheme
                ? [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          _showAbout = false;
                          _showColorTheme = false;
                        });
                      },
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                  ]
                : null,
          ),
          Expanded(
            child: _showAbout
                ? const AboutScreen()
                : _showColorTheme
                    ? const ColorThemeScreen()
                    : _buildSettingsContent(context, l10n, localeProvider, themeProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, AppLocalizations l10n, LocaleProvider localeProvider, ThemeProvider themeProvider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n.language),
                subtitle: Text(
                  localeProvider.followSystem
                      ? l10n.followSystem
                      : localeProvider.locale.languageCode == 'zh'
                          ? (localeProvider.locale.countryCode == 'TW' ? l10n.traditionalChinese : l10n.chinese)
                          : localeProvider.locale.languageCode == 'ja'
                              ? l10n.japanese
                              : l10n.english,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        l10n.language,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioListTile<Locale?>(
                            title: Text(l10n.chinese),
                            value: const Locale('zh'),
                            groupValue: localeProvider.followSystem ? null : localeProvider.userLocale,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onChanged: (value) {
                              localeProvider.setLocale(value);
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile<Locale?>(
                            title: Text(l10n.traditionalChinese),
                            value: const Locale('zh', 'TW'),
                            groupValue: localeProvider.followSystem ? null : localeProvider.userLocale,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onChanged: (value) {
                              localeProvider.setLocale(value);
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile<Locale?>(
                            title: Text(l10n.english),
                            value: const Locale('en'),
                            groupValue: localeProvider.followSystem ? null : localeProvider.userLocale,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onChanged: (value) {
                              localeProvider.setLocale(value);
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile<Locale?>(
                            title: Text(l10n.japanese),
                            value: const Locale('ja'),
                            groupValue: localeProvider.followSystem ? null : localeProvider.userLocale,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onChanged: (value) {
                              localeProvider.setLocale(value);
                              Navigator.pop(context);
                            },
                          ),
                          RadioListTile<Locale?>(
                            title: Text(l10n.followSystem),
                            value: null,
                            groupValue: localeProvider.followSystem ? null : localeProvider.userLocale,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onChanged: (value) {
                              localeProvider.setLocale(value);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: Text(l10n.theme),
                subtitle: Text(
                  themeProvider.themeMode == ThemeMode.dark
                      ? l10n.dark
                      : themeProvider.themeMode == ThemeMode.light
                          ? l10n.light
                          : l10n.system,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        l10n.theme,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioListTile<ThemeMode>(
                            title: Text(l10n.light),
                            value: ThemeMode.light,
                            groupValue: themeProvider.themeMode,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onChanged: (value) {
                              if (value != null) {
                                themeProvider.setThemeMode(value);
                                Navigator.pop(context);
                              }
                            },
                          ),
                          RadioListTile<ThemeMode>(
                            title: Text(l10n.dark),
                            value: ThemeMode.dark,
                            groupValue: themeProvider.themeMode,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onChanged: (value) {
                              if (value != null) {
                                themeProvider.setThemeMode(value);
                                Navigator.pop(context);
                              }
                            },
                          ),
                          RadioListTile<ThemeMode>(
                            title: Text(l10n.system),
                            value: ThemeMode.system,
                            groupValue: themeProvider.themeMode,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onChanged: (value) {
                              if (value != null) {
                                themeProvider.setThemeMode(value);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.palette),
                title: Text(l10n.colorTheme),
                subtitle: Text(themeProvider.currentColorTheme.name),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  setState(() {
                    _showColorTheme = true;
                  });
                },
              ),
              const Divider(),
              // 高级设置分组
              ExpansionTile(
                leading: const Icon(Symbols.science),
                title: Text(l10n.advancedSettings),
                subtitle: Text(l10n.advanced),
                trailing: Icon(
                  _showAdvanced ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                ),
                initiallyExpanded: _showAdvanced,
                onExpansionChanged: (expanded) {
                  setState(() {
                    _showAdvanced = expanded;
                  });
                },
                children: [
                  // 启用侧边栏拖拽排序
                  ListTile(
                    leading: const Icon(Icons.drag_handle),
                    title: Text(l10n.sidebarDragEnabled),
                    subtitle: Text(l10n.sidebarDragEnabledDescription),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 20),
                          onPressed: () {
                            SettingsDialogsBuilder.showResetSortOrderDialog(
                              context,
                              l10n,
                              () {
                                // 重置后刷新界面
                                setState(() {});
                              },
                            );
                          },
                          tooltip: l10n.resetSidebarSortOrder,
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: _sidebarDragEnabled,
                          onChanged: (value) async {
                            await CalculatorSettingsProvider.setSidebarDragEnabled(value);
                            if (mounted) {
                              setState(() {
                                _sidebarDragEnabled = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // 历史记录数量限制
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(l10n.historyLimit),
                    subtitle: Text('${l10n.historyLimitDescription}\n${l10n.currentLimit}: $_historyLimit ${l10n.entries}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      SettingsDialogsBuilder.showHistoryLimitDialog(
                        context,
                        l10n,
                        _historyLimit,
                        _loadHistoryLimit,
                      );
                    },
                  ),
                  const Divider(height: 1),
                  // 数据记录读写目录
                  ListTile(
                    leading: const Icon(Icons.folder),
                    title: Text(l10n.dataStoragePath),
                    subtitle: Text(
                      _historyStoragePath != null
                          ? '${_historyStoragePath}${Platform.pathSeparator}history.json'
                          : _defaultStorageFilePath,
                    ),
                    trailing: _historyStoragePath != null
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () async {
                              await CalculatorSettingsProvider.setHistoryStoragePath(null);
                              await _loadHistoryStoragePath();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.dataStoragePathReset),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            tooltip: l10n.reset,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          )
                        : null,
                    onTap: () async {
                      final l10n = AppLocalizations.of(context)!;
                      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
                      
                      if (selectedDirectory != null) {
                        await CalculatorSettingsProvider.setHistoryStoragePath(selectedDirectory);
                        await _loadHistoryStoragePath();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${l10n.dataStoragePathSet}: $selectedDirectory'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.about),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              setState(() {
                _showAbout = true;
              });
            },
          ),
        ),
              ],
            );
  }

}

