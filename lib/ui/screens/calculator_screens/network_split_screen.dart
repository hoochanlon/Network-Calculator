import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_calculator/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../core/services/network_split_service.dart';
import '../../../core/services/history_service.dart';
import '../../../core/utils/error_message_translator.dart';
import '../../../core/utils/calculator_name_translator.dart';
import '../../../core/providers/calculator_state_provider.dart';
import '../../../core/providers/calculator_settings_provider.dart';
import '../../widgets/screen_title_bar.dart';

class NetworkSplitScreen extends StatefulWidget {
  const NetworkSplitScreen({super.key});

  @override
  State<NetworkSplitScreen> createState() => _NetworkSplitScreenState();
}

class _NetworkSplitScreenState extends State<NetworkSplitScreen> {
  final _supernetController = TextEditingController();
  final _targetMaskController = TextEditingController();
  List<String>? _result;
  bool _isLoading = false;
  bool _isInitialized = false;

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
        _supernetController.clear();
        _targetMaskController.clear();
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
    _supernetController.dispose();
    _targetMaskController.dispose();
    super.dispose();
  }

  Future<void> _loadState() async {
    final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
    final state = await stateProvider.getState(CalculatorKeys.networkSplit);
    
    if (state != null && mounted) {
      setState(() {
        _supernetController.text = state['supernet'] ?? '';
        _targetMaskController.text = state['targetMask'] ?? '';
        _result = state['result'] != null ? List<String>.from(state['result']) : null;
        _isInitialized = true;
      });
    } else {
      _isInitialized = true;
    }
  }

  Future<void> _saveState() async {
    final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
    await stateProvider.saveState(CalculatorKeys.networkSplit, {
      'supernet': _supernetController.text,
      'targetMask': _targetMaskController.text,
      'result': _result,
    });
  }

  Future<void> _split() async {
    final l10n = AppLocalizations.of(context)!;
    if (_supernetController.text.isEmpty || _targetMaskController.text.isEmpty) {
      _showError(l10n.pleaseEnterSupernetAndMask);
      return;
    }

    final targetMask = int.tryParse(_targetMaskController.text.trim());
    if (targetMask == null || targetMask < 1 || targetMask > 32) {
      _showError(l10n.targetMaskMustBeBetween1And32);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = NetworkSplitService.splitNetwork(
      _supernetController.text.trim(),
      targetMask,
    );

    setState(() {
      _result = result;
      _isLoading = false;
    });

    if (result == null) {
      _showError(l10n.invalidSupernetFormat);
    } else if (result.isNotEmpty) {
      final resultText = result.join('\n');
      await HistoryService.addRecord(HistoryRecord(
        calculator: CalculatorNameTranslator.toKey(l10n.networkSplit, l10n),
        inputs: {
          'supernet': _supernetController.text.trim(),
          'targetMask': _targetMaskController.text.trim(),
        },
        result: resultText,
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
      _supernetController.clear();
      _targetMaskController.clear();
      _result = null;
    });
    // 清除保存的状态
    final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
    await stateProvider.clearState(CalculatorKeys.networkSplit);
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
          ScreenTitleBar(title: l10n.networkSplit),
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
                    TextField(
                      controller: _supernetController,
                      decoration: InputDecoration(
                        labelText: l10n.inputSupernet,
                        hintText: '172.16.64.0/21',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _targetMaskController,
                      decoration: InputDecoration(
                        labelText: l10n.inputTargetMask,
                        hintText: '24',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _split,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                minimumSize: const Size(0, 48),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : Text(l10n.split),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _clear,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                minimumSize: const Size(0, 48),
                                side: BorderSide(
                                  color: Theme.of(context).dividerColor,
                                  width: 1,
                                ),
                              ),
                              child: Text(l10n.clear),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_result != null && _result!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.result,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              final l10n = AppLocalizations.of(context)!;
                              Clipboard.setData(ClipboardData(text: _result!.join('\n')));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.copiedToClipboard)),
                              );
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      ..._result!.map((subnet) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: SelectableText(
                              subnet,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          )),
                    ],
                  ),
                ),
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

