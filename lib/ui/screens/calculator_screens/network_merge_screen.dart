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
import '../../widgets/screen_title_bar.dart';

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
        _isInitialized = true;
      });
    } else {
      _isInitialized = true;
    }
  }

  Future<void> _saveState() async {
    final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
    await stateProvider.saveState(CalculatorKeys.networkMerge, {
      'input': _inputController.text,
      'result': _result,
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

    final result = NetworkMergeService.mergeNetworks(networks);

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
                    Text(
                      l10n.inputNetworks,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _inputController,
                      decoration: const InputDecoration(
                        hintText: '192.168.1.0/24\n192.168.2.0/24\n192.168.3.0/24',
                      ),
                      maxLines: 10,
                      minLines: 5,
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
                              onPressed: _isLoading ? null : _merge,
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
                                  : Text(l10n.merge),
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
            if (_result != null && !_result!.startsWith('Error:') && !_result!.startsWith('Invalid')) ...[
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
                              Clipboard.setData(ClipboardData(text: _result!));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.copiedToClipboard)),
                              );
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      SelectableText(
                        _result!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
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

