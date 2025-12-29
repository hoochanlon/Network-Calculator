import 'package:flutter/material.dart';
import '../../core/providers/calculator_settings_provider.dart';
import '../../l10n/app_localizations.dart';

/// 设置对话框构建器
class SettingsDialogsBuilder {
  /// 显示历史记录限制对话框
  static void showHistoryLimitDialog(
    BuildContext context,
    AppLocalizations l10n,
    int currentLimit,
    VoidCallback onLimitChanged,
  ) {
    final controller = TextEditingController(text: currentLimit.toString());
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
                if (context.mounted) {
                  Navigator.pop(context);
                  onLimitChanged();
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

  /// 显示重置排序对话框
  static void showResetSortOrderDialog(
    BuildContext context,
    AppLocalizations l10n,
    VoidCallback onReset,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.resetSidebarSortOrder,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          l10n.resetSidebarSortOrderConfirm,
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
              await CalculatorSettingsProvider.resetSidebarOrder();
              if (context.mounted) {
                Navigator.pop(context);
                onReset();
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

