import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/providers/calculator_settings_provider.dart';
import '../../l10n/app_localizations.dart';
import 'history_screen.dart';

/// 导航项数据模型
class NavigationItem {
  final IconData icon;
  final String label;
  final Widget screen;
  final bool isSpecial;
  final String? calculatorKey;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.screen,
    this.isSpecial = false,
    this.calculatorKey,
  });
}

/// 导航项构建器
class MainNavigationItemBuilder {
  /// 构建导航项 Widget
  static Widget buildNavigationItem(
    BuildContext context,
    NavigationItem item,
    int index,
    bool isSelected,
    VoidCallback onTap, {
    bool isLocked = false,
    VoidCallback? onLockToggle,
    bool showDragHandle = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    
    return InkWell(
      onTap: onTap,
      onLongPress: item.calculatorKey != null ? () {
        // 长按显示锁定/解锁菜单
        _showLockMenu(context, item, isLocked, onLockToggle, l10n);
      } : null,
      mouseCursor: SystemMouseCursors.click,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  width: 1,
                )
              : isLocked
                  ? Border.all(
                      color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                      width: 1,
                    )
                  : null,
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 20,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.bodyMedium?.color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            // 锁图标（如果被锁定）
            if (isLocked)
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 4),
                child: Icon(
                  Icons.lock,
                  size: 18,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            // 拖拽手柄（如果启用拖拽且未被锁定）
            if (showDragHandle && !isLocked)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.drag_handle,
                  size: 20,
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  /// 显示锁定菜单
  static void _showLockMenu(
    BuildContext context,
    NavigationItem item,
    bool isLocked,
    VoidCallback? onLockToggle,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                isLocked ? Icons.lock_open : Icons.lock,
                color: isLocked 
                    ? Theme.of(context).colorScheme.error 
                    : Theme.of(context).primaryColor,
              ),
              title: Text(isLocked ? l10n.unlockItem : l10n.lockItem),
              onTap: () async {
                if (item.calculatorKey != null) {
                  await CalculatorSettingsProvider.toggleItemLock(item.calculatorKey!);
                  // 通知顺序变化，触发界面刷新
                  CalculatorSettingsProvider.orderNotifier.notifyOrderChanged();
                  if (onLockToggle != null) {
                    onLockToggle();
                  }
                }
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

