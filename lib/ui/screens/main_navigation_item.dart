import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/providers/calculator_settings_provider.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/utils/calculator_name_translator.dart';
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
    bool sidebarDragEnabled = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    
    return InkWell(
      onTap: onTap,
      // 锁定功能需要依赖侧边栏拖拽排序开关
      // 所有有 calculatorKey 的项都支持长按锁定（但需要启用拖拽排序）
      onLongPress: (item.calculatorKey != null && sidebarDragEnabled)
          ? () async {
        // 获取当前锁定状态
        final currentLocked = await CalculatorSettingsProvider.isItemLocked(item.calculatorKey!);
        // 长按自动锁定/解锁
        await CalculatorSettingsProvider.toggleItemLock(item.calculatorKey!);
        // 通知顺序变化，触发界面刷新
        CalculatorSettingsProvider.orderNotifier.notifyOrderChanged();
        if (onLockToggle != null) {
          onLockToggle();
        }
        // 显示操作提示
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                currentLocked ? l10n.unlockItem : l10n.lockItem,
                style: AppFonts.createStyle(
                  fontSize: 14,
                ),
              ),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
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
              : (isLocked && sidebarDragEnabled)
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
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            // 锁图标（仅在启用拖拽排序且被锁定时显示）
            if (isLocked && sidebarDragEnabled)
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
  
}

