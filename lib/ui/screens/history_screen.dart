import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:network_calculator/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import '../../core/services/history_service.dart';
import '../../core/providers/calculator_state_provider.dart';
import '../../core/utils/calculator_name_translator.dart';
import '../../core/theme/app_fonts.dart';
import '../widgets/screen_title_bar.dart';
import '../web/history_download_stub.dart'
    if (dart.library.html) '../web/history_download_web.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> with WidgetsBindingObserver {

  List<HistoryRecord> _history = [];
  List<HistoryRecord> _filteredHistory = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadHistory();
    _searchController.addListener(_filterHistory);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadHistory();
    }
  }

  void _filterHistory() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredHistory = _history;
      });
    } else {
      setState(() {
        _filteredHistory = _history.where((record) {
          final calculator = record.calculator.toLowerCase();
          final result = record.result.toLowerCase();
          final inputs = record.inputs.values
              .map((v) => v.toString().toLowerCase())
              .join(' ');
          return calculator.contains(query) ||
              result.contains(query) ||
              inputs.contains(query);
        }).toList();
      });
    }
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });
    final history = await HistoryService.loadHistory();
    // 默认按时间倒序（最新优先）
    history.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    setState(() {
      _history = history;
      _filteredHistory = history;
      _isLoading = false;
    });
  }

  // 公开的刷新方法，供外部调用
  void refreshHistory() {
    _loadHistory();
  }

  Future<void> _deleteRecord(int index) async {
    // 找到在原始历史记录中的实际索引
    final record = _filteredHistory[index];
    final actualIndex = _history.indexOf(record);
    if (actualIndex != -1) {
      await HistoryService.deleteRecord(actualIndex);
      await _loadHistory();
    }
  }

  Future<void> _clearHistory() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.deleteAll,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          l10n.confirmDeleteAll,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(l10n.cancel),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text(l10n.deleteAll),
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      ),
    );

    if (confirmed == true) {
      await HistoryService.clearHistory();
      await _loadHistory();
    }
  }

  Future<void> _clearCalculatorStates() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.clearCalculatorStates,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          l10n.confirmClearCalculatorStates,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(l10n.cancel),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text(l10n.clear),
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      ),
    );

    if (confirmed == true) {
      final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
      await stateProvider.clearAllStates();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.calculatorStatesCleared),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _exportHistory() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final result = await HistoryService.exportHistory();
      if (result != null) {
        if (kIsWeb) {
          // Web：result 是 JSON 内容，触发浏览器下载
          downloadHistoryJson(result);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.exportSuccess),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } else {
          // 桌面端：result 是文件路径
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${l10n.exportSuccess}: $result'),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.exportFailed)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.exportFailed)),
        );
      }
    }
  }

  Future<void> _importHistory() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      debugPrint('History import: opening file picker...');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      debugPrint('History import: file picker result = ${result != null}');

      if (result != null) {
        bool success = false;

        if (kIsWeb) {
          // Web 平台：使用文件内容（bytes）
          final file = result.files.single;
          if (file.bytes != null) {
            // 使用 UTF-8 解码，避免中文等字符出现乱码
            final content = utf8.decode(file.bytes!);
            success = await HistoryService.importHistoryFromContent(content);
          }
        } else {
          // 桌面平台：优先使用文件路径；部分环境（如沙盒）可能拿不到路径，此时回退到 bytes
          final file = result.files.single;
          final filePath = file.path;
          if (filePath != null) {
            // 正常桌面环境：直接使用文件路径读取
            success = await HistoryService.importHistory(filePath);
          } else if (file.bytes != null) {
            // 沙盒环境：没有路径，但有文件内容，按 Web 方式处理
            final content = utf8.decode(file.bytes!);
            success = await HistoryService.importHistoryFromContent(content);
          } else {
            // 理论上不会到这里，记录一条日志便于排查
            debugPrint('History import failed: no path and no bytes from FilePicker.');
          }
        }

        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.importSuccess)),
            );
            await _loadHistory();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.invalidFile)),
            );
          }
        }
      }
    } catch (e, stack) {
      debugPrint('History import exception: $e');
      debugPrint(stack.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.importFailed)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          ScreenTitleBar(
            title: l10n.history,
            actions: [
              // 清除计算器输入和结果按钮（始终显示）
              IconButton(
                icon: const Icon(Icons.cleaning_services, size: 24),
                onPressed: _clearCalculatorStates,
                tooltip: l10n.clearCalculatorStates,
                splashRadius: 20,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
              ),
              // 其他按钮（仅在历史记录不为空时显示）
              if (_history.isNotEmpty) ...[
                IconButton(
                  icon: const Icon(Icons.upload_file, size: 24),
                  onPressed: _importHistory,
                  tooltip: l10n.importHistory,
                  splashRadius: 20,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.download, size: 24),
                  onPressed: _exportHistory,
                  tooltip: l10n.exportHistory,
                  splashRadius: 20,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 24),
                  onPressed: _clearHistory,
                  tooltip: l10n.deleteAll,
                  splashRadius: 20,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ],
            ],
          ),
          // 原有 body 内容
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  children: [
                    // 搜索框
                    if (_history.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: _searchController,
                          style: AppFonts.createStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          selectionControls: AppTextSelectionControls.customControls,
                          decoration: InputDecoration(
                            hintText: l10n.searchHint,
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                    },
                                    splashRadius: 20,
                                  )
                                : null,
                          ),
                        ),
                      ),
                // 历史记录列表
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredHistory.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _searchController.text.isNotEmpty
                                        ? Icons.search_off
                                        : Icons.history,
                                    size: 64,
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _searchController.text.isNotEmpty
                                        ? l10n.noResultsFound
                                        : l10n.noHistory,
                                    style: AppFonts.withFont(Theme.of(context).textTheme.bodyLarge),
                                  ),
                                  // 当没有历史记录且不是搜索状态时，显示导入按钮
                                  if (_searchController.text.isEmpty) ...[
                                    const SizedBox(height: 32),
                                    ElevatedButton.icon(
                                      onPressed: _importHistory,
                                      icon: const Icon(Icons.upload_file),
                                      label: Text(l10n.importHistory),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadHistory,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _filteredHistory.length,
                                itemBuilder: (context, index) {
                                  final record = _filteredHistory[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: ExpansionTile(
                                      leading: Icon(
                                        _getCalculatorIcon(record.calculator),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      title: Text(
                                        CalculatorNameTranslator.translate(record.calculator, l10n),
                                        style: AppFonts.withFont(Theme.of(context).textTheme.titleMedium),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 8),
                                          Text(
                                            _formatDate(record.timestamp),
                                            style: AppFonts.withFont(
                                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.color
                                                        ?.withOpacity(0.6),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.copy),
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(text: record.result));
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(l10n.copiedToClipboard)),
                                              );
                                            },
                                            splashRadius: 20,
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline),
                                            onPressed: () => _deleteRecord(index),
                                            splashRadius: 20,
                                          ),
                                        ],
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (record.inputs.isNotEmpty) ...[
                                                Text(
                                                  '${l10n.inputs}:',
                                                  style: AppFonts.withFont(Theme.of(context).textTheme.titleSmall),
                                                ),
                                                const SizedBox(height: 8),
                                                ...record.inputs.entries.map((entry) => Padding(
                                                      padding: const EdgeInsets.only(bottom: 4),
                                                      child: Text(
                                                        '${entry.key}: ${entry.value}',
                                                        style: AppFonts.withFont(Theme.of(context).textTheme.bodyMedium),
                                                      ),
                                                    )),
                                                const Divider(),
                                              ],
                                              Text(
                                                '${l10n.result}:',
                                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  fontFamily: 'OPPOSans',
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              SelectableText(
                                                record.result,
                                                style: AppFonts.withFont(Theme.of(context).textTheme.bodyMedium),
                                                selectionControls: AppTextSelectionControls.customControls,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                  ),
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }

  IconData _getCalculatorIcon(String calculator) {
    // 支持键值和旧格式（向后兼容）
    final key = CalculatorNameTranslator.isKey(calculator)
        ? calculator
        : CalculatorNameTranslator.toKey(calculator, AppLocalizations.of(context)!);

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

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
