import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_calculator/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../core/services/base_converter_service.dart';
import '../../../core/services/history_service.dart';
import '../../../core/utils/error_message_translator.dart';
import '../../../core/utils/calculator_name_translator.dart';
import '../../../core/providers/calculator_state_provider.dart';
import '../../../core/providers/calculator_settings_provider.dart';
import '../../widgets/screen_title_bar.dart';

class BaseConverterScreen extends StatefulWidget {
  const BaseConverterScreen({super.key});

  @override
  State<BaseConverterScreen> createState() => _BaseConverterScreenState();
}

class _BaseConverterScreenState extends State<BaseConverterScreen> {
  final _inputController = TextEditingController();
  Map<String, dynamic>? _result;
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
    final state = await stateProvider.getState(CalculatorKeys.baseConverter);
    
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
    await stateProvider.saveState(CalculatorKeys.baseConverter, {
      'input': _inputController.text,
      'result': _result,
    });
  }

  Future<void> _convert() async {
    if (_inputController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = BaseConverterService.convertIp(_inputController.text.trim());

    setState(() {
      _result = result;
      _isLoading = false;
    });

    if (result != null && result.containsKey('error')) {
      _showError(result['error']);
    } else if (result != null) {
      final l10n = AppLocalizations.of(context)!;
      final resultText = _formatResult(result, l10n);
      await HistoryService.addRecord(HistoryRecord(
        calculator: CalculatorNameTranslator.toKey(l10n.baseConverter, l10n),
        inputs: {'input': _inputController.text.trim()},
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
      _inputController.clear();
      _result = null;
    });
    // 清除保存的状态
    final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
    await stateProvider.clearState(CalculatorKeys.baseConverter);
  }

  void _showError(String message) {
    final l10n = AppLocalizations.of(context)!;
    final translatedMessage = ErrorMessageTranslator.translate(message, l10n);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(translatedMessage)),
    );
  }

  String _formatResult(Map<String, dynamic> result, AppLocalizations l10n) {
    final buffer = StringBuffer();
    if (result.containsKey('binary')) {
      buffer.writeln('${l10n.binary}: ${result['binary']}');
    }
    if (result.containsKey('decimal')) {
      buffer.writeln('${l10n.decimal}: ${result['decimal']}');
    }
    if (result.containsKey('decimalNoDot')) {
      buffer.writeln('${l10n.decimalNoDot}: ${result['decimalNoDot']}');
    }
    if (result.containsKey('hexadecimal')) {
      buffer.writeln('${l10n.hexadecimal}: ${result['hexadecimal']}');
    }
    if (result.containsKey('complement')) {
      final comp = result['complement'] as Map<String, dynamic>;
      buffer.writeln('\n${l10n.complement}:');
      buffer.writeln('  ${l10n.binary}: ${comp['binary']}');
      buffer.writeln('  ${l10n.decimal}: ${comp['decimal']}');
      buffer.writeln('  ${l10n.decimalNoDot}: ${comp['decimalNoDot']}');
      buffer.writeln('  ${l10n.hexadecimal}: ${comp['hexadecimal']}');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          ScreenTitleBar(title: l10n.baseConverter),
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
                      controller: _inputController,
                      decoration: InputDecoration(
                        labelText: l10n.inputBaseValue,
                        hintText: '192.168.1.1 or 11000000.10101000.00000001.00000001',
                      ),
                      onSubmitted: (_) => _convert(),
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
                                onPressed: _isLoading ? null : _convert,
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
                                    : Text(l10n.calculate),
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
            if (_result != null && !_result!.containsKey('error')) ...[
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
                              Clipboard.setData(ClipboardData(text: _formatResult(_result!, l10n)));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.copiedToClipboard)),
                              );
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      if (_result!.containsKey('binary'))
                        _buildResultRow(l10n.binary, _result!['binary']),
                      if (_result!.containsKey('decimal'))
                        _buildResultRow(l10n.decimal, _result!['decimal']),
                      if (_result!.containsKey('decimalNoDot'))
                        _buildResultRow(l10n.decimalNoDot, _result!['decimalNoDot'].toString()),
                      if (_result!.containsKey('hexadecimal'))
                        _buildResultRow(l10n.hexadecimal, _result!['hexadecimal']),
                      if (_result!.containsKey('complement')) ...[
                        const SizedBox(height: 16),
                        Text(
                          l10n.complement,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        ..._buildComplementResult(_result!['complement'] as Map<String, dynamic>, l10n),
                      ],
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

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildComplementResult(Map<String, dynamic> complement, AppLocalizations l10n) {
    return [
      _buildResultRow('${l10n.binary}:', complement['binary']),
      _buildResultRow('${l10n.decimal}:', complement['decimal']),
      _buildResultRow('${l10n.decimalNoDot}:', complement['decimalNoDot'].toString()),
      _buildResultRow('${l10n.hexadecimal}:', complement['hexadecimal']),
    ];
  }
}

