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
import '../../core/utils/calculator_name_translator.dart';
import '../widgets/screen_title_bar.dart';
import 'about_screen.dart';
import 'color_theme_screen.dart';

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
  bool _showCalculatorSort = false;
  int _sortOrderKey = 0; // 用于强制刷新排序界面

  @override
  void initState() {
    super.initState();
    _loadHistoryLimit();
    _loadHistoryStoragePath();
    _loadDefaultStoragePath();
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
                    : _showCalculatorSort
                        ? l10n.calculatorSortOrder
                        : l10n.settings,
            actions: _showAbout || _showColorTheme || _showCalculatorSort
                ? [
                    if (_showCalculatorSort)
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => _showResetSortOrderDialog(context, l10n),
                        tooltip: l10n.resetSortOrder,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                      ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          _showAbout = false;
                          _showColorTheme = false;
                          _showCalculatorSort = false;
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
                    : _showCalculatorSort
                        ? _buildCalculatorSortScreen(context, l10n)
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
              ListTile(
                leading: const Icon(Icons.sort),
                title: Text(l10n.calculatorSortOrder),
                subtitle: Text(l10n.calculatorSortOrderDescription),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  setState(() {
                    _showCalculatorSort = true;
                  });
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.history),
                title: Text(l10n.historyLimit),
                subtitle: Text('${l10n.historyLimitDescription}\n${l10n.currentLimit}: $_historyLimit ${l10n.entries}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showHistoryLimitDialog(context, l10n);
                },
              ),
              const Divider(),
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

  Widget _buildCalculatorSortScreen(BuildContext context, AppLocalizations l10n) {
    return StatefulBuilder(
      key: ValueKey(_sortOrderKey), // 使用 key 强制重建
      builder: (context, setLocalState) {
        return FutureBuilder<List<String>>(
          future: CalculatorSettingsProvider.getCalculatorOrder(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final currentOrder = snapshot.data!;
            return ReorderableListView(
              padding: const EdgeInsets.all(16),
              proxyDecorator: (child, index, animation) {
                // 自定义拖拽时的外观，移除默认的条形图层
                return Material(
                  elevation: 6,
                  shadowColor: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                  child: child,
                );
              },
              onReorder: (oldIndex, newIndex) async {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final newOrder = List<String>.from(currentOrder);
                final item = newOrder.removeAt(oldIndex);
                newOrder.insert(newIndex, item);
                await CalculatorSettingsProvider.setCalculatorOrder(newOrder);
                // 立即更新本地状态以反映新顺序
                setLocalState(() {});
                // 通知主屏幕刷新 - 通过 ChangeNotifier
                CalculatorSettingsProvider.orderNotifier.notifyOrderChanged();
              },
              children: currentOrder.asMap().entries.map((entry) {
                final index = entry.key;
                final key = entry.value;
                final calculatorName = _getCalculatorName(key, l10n);
                final icon = _getCalculatorIcon(key);
                return ReorderableDragStartListener(
                  key: Key(key),
                  index: index,
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(icon),
                      title: Text(calculatorName),
                      trailing: const Icon(Icons.drag_handle),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  String _getCalculatorName(String key, AppLocalizations l10n) {
    return CalculatorNameTranslator.translate(key, l10n);
  }

  IconData _getCalculatorIcon(String key) {
    switch (key) {
      case CalculatorKeys.ipCalculator:
        return Symbols.bring_your_own_ip;
      case CalculatorKeys.subnetCalculator:
        return Symbols.account_tree;
      case CalculatorKeys.baseConverter:
        return Symbols.swap_horiz;
      case CalculatorKeys.networkMerge:
        return Symbols.call_merge;
      case CalculatorKeys.networkSplit:
        return Symbols.call_split;
      case CalculatorKeys.ipInclusionChecker:
        return Symbols.search;
      default:
        return Symbols.calculate;
    }
  }


  void _showHistoryLimitDialog(BuildContext context, AppLocalizations l10n) {
    final controller = TextEditingController(text: _historyLimit.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.historyLimit,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.historyLimitDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.historyLimitHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(l10n.cancel),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () async {
              final value = int.tryParse(controller.text);
              if (value != null && value >= 10 && value <= 100000) {
                await CalculatorSettingsProvider.setHistoryLimit(value);
                await _loadHistoryLimit();
                if (context.mounted) {
                  Navigator.pop(context);
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.historyLimitHint),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(l10n.save),
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      ),
    );
  }

  void _showResetSortOrderDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.resetSortOrder,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          l10n.resetSortOrderConfirm,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(l10n.cancel),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () async {
              await CalculatorSettingsProvider.resetCalculatorOrder();
              if (context.mounted) {
                Navigator.pop(context);
                // 刷新排序界面 - 通过更新 key 强制重建
                setState(() {
                  _sortOrderKey++;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(l10n.reset),
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      ),
    );
  }
}

