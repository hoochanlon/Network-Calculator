import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_calculator/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../core/services/network_merge_service.dart';
import '../../../core/services/history_service.dart';
import '../../../core/utils/error_message_translator.dart';
import '../../../core/utils/calculator_name_translator.dart';
import '../../../core/providers/calculator_state_provider.dart';
import '../../../core/providers/calculator_settings_provider.dart';
import '../../../core/theme/app_fonts.dart';
import '../../widgets/screen_title_bar.dart';
import '../../widgets/calculator_text_field.dart';
import '../../widgets/calculator_buttons.dart';
import '../../widgets/result_card.dart';

class NetworkMergeScreen extends StatefulWidget {
  const NetworkMergeScreen({super.key});

  @override
  State<NetworkMergeScreen> createState() => _NetworkMergeScreenState();
}

class _NetworkMergeScreenState extends State<NetworkMergeScreen> {
  final _inputController = TextEditingController();
  String? _result;
  bool _isLoading = false;
  bool _isInitialized = false;
  MergeAlgorithm _selectedAlgorithm = MergeAlgorithm.summarization;

  @override
  void initState() {
    super.initState();
    _loadState();
    // 监听状态变化，当功能关闭时清除显示
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
      stateProvider.addListener(_onStateChanged);
    });
  }

  void _onStateChanged() async {
    if (!mounted) return;
    
    // 检查功能状态
    final preserveInputs = await CalculatorSettingsProvider.getPreserveInputs();
    if (!preserveInputs) {
      // 如果功能关闭，清除当前显示的结果
      setState(() {
        _inputController.clear();
        _result = null;
      });
    } else {
      // 如果功能开启，重新加载保存的状态
      await _loadState();
    }
  }

  @override
  void dispose() {
    // 移除监听器
    final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
    stateProvider.removeListener(_onStateChanged);
    if (_isInitialized) {
      _saveState();
    }
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _loadState() async {
    final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
    final state = await stateProvider.getState(CalculatorKeys.networkMerge);
    
    if (state != null && mounted) {
      setState(() {
        _inputController.text = state['input'] ?? '';
        _result = state['result'];
        final algorithmIndex = state['algorithm'] ?? 0;
        _selectedAlgorithm = MergeAlgorithm.values[algorithmIndex.clamp(0, MergeAlgorithm.values.length - 1)];
        _isInitialized = true;
      });
    } else {
      // 如果没有保存的状态，确保界面被清空
      if (mounted) {
        setState(() {
          _inputController.clear();
          _result = null;
          _selectedAlgorithm = MergeAlgorithm.summarization;
          _isInitialized = true;
        });
      } else {
        _isInitialized = true;
      }
    }
  }

  Future<void> _saveState() async {
    final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
    await stateProvider.saveState(CalculatorKeys.networkMerge, {
      'input': _inputController.text,
      'result': _result,
      'algorithm': _selectedAlgorithm.index,
    });
  }

  Future<void> _merge() async {
    if (_inputController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final networks = _inputController.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    final result = NetworkMergeService.mergeNetworks(networks, algorithm: _selectedAlgorithm);

    setState(() {
      _result = result;
      _isLoading = false;
    });

    if (result != null && result.startsWith('Error:') || result != null && result.startsWith('Invalid')) {
      _showError(result);
    } else if (result != null) {
      final l10n = AppLocalizations.of(context)!;
      await HistoryService.addRecord(HistoryRecord(
        calculator: CalculatorNameTranslator.toKey(l10n.networkMerge, l10n),
        inputs: {'networks': _inputController.text.trim()},
        result: result,
        timestamp: DateTime.now(),
      ));
    }
    
    // 保存状态
    if (_isInitialized) {
      _saveState();
    }
  }

  void _clear() async {
    setState(() {
      _inputController.clear();
      _result = null;
    });
    // 清除保存的状态
    final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
    await stateProvider.clearState(CalculatorKeys.networkMerge);
  }

  void _showError(String message) {
    final l10n = AppLocalizations.of(context)!;
    final translatedMessage = ErrorMessageTranslator.translate(message, l10n);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(translatedMessage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          ScreenTitleBar(title: l10n.networkMerge),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CalculatorTextField(
                      controller: _inputController,
                        labelText: l10n.inputNetworks,
                        hintText: '192.168.1.0/24\n192.168.2.0/24\n192.168.3.0/24',
                      multiline: true,
                      minLines: 5,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                            // 移除阴影，避免夜间模式下的阴影边角问题
                            boxShadow: [],
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                              width: 0.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: SegmentedButton<MergeAlgorithm>(
                              segments: [
                                ButtonSegment<MergeAlgorithm>(
                                  value: MergeAlgorithm.summarization,
                                  icon: const Icon(Icons.auto_awesome, size: 18),
                                  label: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(
                                      l10n.algorithmSummarization,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                ButtonSegment<MergeAlgorithm>(
                                  value: MergeAlgorithm.merge,
                                  icon: const Icon(Icons.merge_type, size: 18),
                                  label: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(
                                      l10n.algorithmMerge,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                              selected: {_selectedAlgorithm},
                              onSelectionChanged: (Set<MergeAlgorithm> newSelection) {
                                setState(() {
                                  _selectedAlgorithm = newSelection.first;
                                });
                                if (_isInitialized) {
                                  _saveState();
                                }
                              },
                              style: SegmentedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                minimumSize: const Size(0, 44),
                                side: BorderSide.none, // 移除按钮之间的边框
                                backgroundColor: Colors.transparent, // 使用透明背景，让容器颜色显示
                                foregroundColor: Theme.of(context).colorScheme.onSurface,
                                selectedBackgroundColor: Theme.of(context).colorScheme.primary,
                                selectedForegroundColor: Theme.of(context).colorScheme.onPrimary,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                // 确保没有阴影
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Text(
                          _selectedAlgorithm == MergeAlgorithm.summarization
                              ? l10n.algorithmSummarizationSource
                              : l10n.algorithmMergeSource,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CalculatorButtonRow(
                      actionText: l10n.merge,
                      clearText: l10n.clear,
                      onActionPressed: _merge,
                      onClearPressed: _clear,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
            if (_result != null && !_result!.startsWith('Error:') && !_result!.startsWith('Invalid')) ...[
              const SizedBox(height: 16),
              ResultCard(
                title: l10n.result,
                content: _result!,
                copyText: _result!,
              ),
            ],
          ],
        ),
      ),
          ),
        ],
      ),
    );
  }
}

