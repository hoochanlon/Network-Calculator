import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_calculator/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../core/services/ip_inclusion_service.dart';
import '../../../core/services/history_service.dart';
import '../../../core/utils/error_message_translator.dart';
import '../../../core/utils/calculator_name_translator.dart';
import '../../../core/providers/calculator_state_provider.dart';
import '../../../core/providers/calculator_settings_provider.dart';
import '../../../core/theme/app_fonts.dart';
import '../../widgets/screen_title_bar.dart';

class IpInclusionScreen extends StatefulWidget {
  const IpInclusionScreen({super.key});

  @override
  State<IpInclusionScreen> createState() => _IpInclusionScreenState();
}

class _IpInclusionScreenState extends State<IpInclusionScreen> {
  final _cidr1Controller = TextEditingController();
  final _cidr2Controller = TextEditingController();
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
        _cidr1Controller.clear();
        _cidr2Controller.clear();
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
    _cidr1Controller.dispose();
    _cidr2Controller.dispose();
    super.dispose();
  }

  Future<void> _loadState() async {
    final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
    final state = await stateProvider.getState(CalculatorKeys.ipInclusionChecker);
    
    if (state != null && mounted) {
      setState(() {
        _cidr1Controller.text = state['cidr1'] ?? '';
        _cidr2Controller.text = state['cidr2'] ?? '';
        _result = state['result'];
        _isInitialized = true;
      });
    } else {
      _isInitialized = true;
    }
  }

  Future<void> _saveState() async {
    final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
    await stateProvider.saveState(CalculatorKeys.ipInclusionChecker, {
      'cidr1': _cidr1Controller.text,
      'cidr2': _cidr2Controller.text,
      'result': _result,
    });
  }

  Future<void> _check() async {
    final l10n = AppLocalizations.of(context)!;
    if (_cidr1Controller.text.isEmpty || _cidr2Controller.text.isEmpty) {
      _showError(l10n.pleaseEnterBothCidr);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = IpInclusionService.checkInclusion(
      _cidr1Controller.text.trim(),
      _cidr2Controller.text.trim(),
    );

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
        calculator: CalculatorNameTranslator.toKey(l10n.ipInclusionChecker, l10n),
        inputs: {
          'cidr1': _cidr1Controller.text.trim(),
          'cidr2': _cidr2Controller.text.trim(),
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
      _cidr1Controller.clear();
      _cidr2Controller.clear();
      _result = null;
    });
    // 清除保存的状态
    final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
    await stateProvider.clearState(CalculatorKeys.ipInclusionChecker);
  }

  void _showError(String message) {
    final l10n = AppLocalizations.of(context)!;
    final translatedMessage = ErrorMessageTranslator.translate(message, l10n);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(translatedMessage)),
    );
  }

  String _formatResult(Map<String, dynamic> result, AppLocalizations l10n) {
    if (result['result'] == true) {
      return '''
${l10n.result}: ${l10n.trueText}
${l10n.networkAddress}: ${result['networkAddress']}
${l10n.broadcastAddress}: ${result['broadcastAddress']}
${l10n.usableIps}: ${result['usableIps']}
${l10n.firstUsableIp}: ${result['firstUsableIp']}
${l10n.lastUsableIp}: ${result['lastUsableIp']}
''';
    } else {
      return '${l10n.result}: ${l10n.falseText}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          ScreenTitleBar(title: l10n.ipInclusionChecker),
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
                      controller: _cidr1Controller,
                      decoration: InputDecoration(
                        labelText: l10n.inputCheckCidr,
                        hintText: '192.168.1.0/24',
                      ),
                      selectionControls: AppTextSelectionControls.customControls,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _cidr2Controller,
                      decoration: InputDecoration(
                        labelText: l10n.inputTargetCidr,
                        hintText: '192.168.0.0/16',
                      ),
                      selectionControls: AppTextSelectionControls.customControls,
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
                              onPressed: _isLoading ? null : _check,
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
                                  : Text(l10n.check),
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
                      _buildResultRow(
                        l10n.result,
                        _result!['result'] == true ? l10n.trueText : l10n.falseText,
                        isHighlight: _result!['result'] == true,
                      ),
                      if (_result!['result'] == true) ...[
                        _buildResultRow(l10n.networkAddress, _result!['networkAddress']),
                        _buildResultRow(l10n.broadcastAddress, _result!['broadcastAddress']),
                        _buildResultRow(l10n.usableIps, _result!['usableIps'].toString()),
                        if (_result!['firstUsableIp'] != null)
                          _buildResultRow(l10n.firstUsableIp, _result!['firstUsableIp']),
                        if (_result!['lastUsableIp'] != null)
                          _buildResultRow(l10n.lastUsableIp, _result!['lastUsableIp']),
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

  Widget _buildResultRow(String label, String value, {bool isHighlight = false}) {
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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isHighlight ? Theme.of(context).primaryColor : null,
                    fontWeight: isHighlight ? FontWeight.bold : null,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

