import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_calculator/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../core/services/ip_calculator_service.dart';
import '../../../core/services/history_service.dart';
import '../../../core/utils/error_message_translator.dart';
import '../../../core/utils/calculator_name_translator.dart';
import '../../../core/providers/calculator_state_provider.dart';
import '../../../core/providers/calculator_settings_provider.dart';
import '../../widgets/screen_title_bar.dart';

class IpCalculatorScreen extends StatefulWidget {
  const IpCalculatorScreen({super.key});

  @override
  State<IpCalculatorScreen> createState() => _IpCalculatorScreenState();
}

class _IpCalculatorScreenState extends State<IpCalculatorScreen> {
  final _ipController = TextEditingController();
  final _subnetController = TextEditingController();
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
        _ipController.clear();
        _subnetController.clear();
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
    _ipController.dispose();
    _subnetController.dispose();
    super.dispose();
  }

  Future<void> _loadState() async {
    final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
    final state = await stateProvider.getState(CalculatorKeys.ipCalculator);
    
    if (state != null && mounted) {
      setState(() {
        _ipController.text = state['ip'] ?? '';
        _subnetController.text = state['subnet'] ?? '';
        _result = state['result'];
        _isInitialized = true;
      });
    } else {
      _isInitialized = true;
    }
  }

  Future<void> _saveState() async {
    final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
    await stateProvider.saveState(CalculatorKeys.ipCalculator, {
      'ip': _ipController.text,
      'subnet': _subnetController.text,
      'result': _result,
    });
  }

  Future<void> _calculate() async {
    final l10n = AppLocalizations.of(context)!;
    if (_ipController.text.isEmpty || _subnetController.text.isEmpty) {
      _showError(l10n.pleaseEnterBothIpAndSubnet);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = IpCalculatorService.calculateIpInfo(
      _ipController.text.trim(),
      _subnetController.text.trim(),
    );

    setState(() {
      _result = result;
      _isLoading = false;
    });

    if (result != null && result.containsKey('error')) {
      _showError(result['error']);
    } else if (result != null) {
      // 保存历史记录
      final l10n = AppLocalizations.of(context)!;
      final resultText = _formatResult(result, l10n);
      await HistoryService.addRecord(HistoryRecord(
        calculator: CalculatorNameTranslator.toKey(l10n.ipCalculator, l10n),
        inputs: {
          'ip': _ipController.text.trim(),
          'subnet': _subnetController.text.trim(),
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
      _ipController.clear();
      _subnetController.clear();
      _result = null;
    });
    // 清除保存的状态
    final stateProvider = Provider.of<CalculatorStateProvider>(context, listen: false);
    await stateProvider.clearState(CalculatorKeys.ipCalculator);
  }

  void _showError(String message) {
    final l10n = AppLocalizations.of(context)!;
    final translatedMessage = ErrorMessageTranslator.translate(message, l10n);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(translatedMessage)),
    );
  }

  String _formatResult(Map<String, dynamic> result, AppLocalizations l10n) {
    return '''
${l10n.ipAddress}: ${result['ipAddress']}
${l10n.subnetMask}: ${result['subnetMask']} (${result['cidr']})
${l10n.networkAddress}: ${result['networkAddress']}
${l10n.broadcastAddress}: ${result['broadcastAddress']}
${l10n.usableIps}: ${result['usableIps']}
${l10n.firstUsableIp}: ${result['firstUsableIp']}
${l10n.lastUsableIp}: ${result['lastUsableIp']}
${l10n.networkClass}: ${result['networkClass']}
''';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          ScreenTitleBar(title: l10n.ipCalculator),
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
                      controller: _ipController,
                      decoration: InputDecoration(
                        labelText: l10n.inputIpAddress,
                        hintText: '192.168.1.1',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _subnetController,
                      decoration: InputDecoration(
                        labelText: l10n.inputSubnetMask,
                        hintText: '255.255.255.0 or /24',
                      ),
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
                              onPressed: _isLoading ? null : _calculate,
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
                      _buildResultRow(l10n.networkAddress, _result!['networkAddress']),
                      _buildResultRow(l10n.broadcastAddress, _result!['broadcastAddress']),
                      _buildResultRow(l10n.usableIps, _result!['usableIps'].toString()),
                      _buildResultRow(l10n.firstUsableIp, _result!['firstUsableIp']),
                      _buildResultRow(l10n.lastUsableIp, _result!['lastUsableIp']),
                      _buildResultRow(l10n.networkClass, _result!['networkClass']),
                      _buildResultRow(l10n.cidr, _result!['cidr']),
                      const SizedBox(height: 16),
                      Text(
                        l10n.binary,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        'IP: ${_result!['ipBinary']}\n${l10n.subnetMask}: ${_result!['subnetMaskBinary']}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.hexadecimal,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        'IP: ${_result!['ipHexadecimal']}\n${l10n.subnetMask}: ${_result!['subnetMaskHexadecimal']}',
                        style: Theme.of(context).textTheme.bodyMedium,
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
}

