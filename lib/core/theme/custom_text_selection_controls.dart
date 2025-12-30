import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import 'app_fonts.dart';

/// 完整的文本选择控件
/// 包含"剪切"、"复制"、"粘贴"和"全选"功能，使用 OPPO Sans 字体
class CustomTextSelectionControls extends MaterialTextSelectionControls {
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ValueListenable<ClipboardStatus>? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) {
    final l10n = AppLocalizations.of(context);
    
    // 计算工具栏位置，显示在鼠标点击位置附近（Windows右键菜单逻辑）
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    
    // 估计工具栏宽度（每个按钮约125px，四个按钮约500px，考虑增大的字体和内边距）
    const double estimatedToolbarWidth = 500.0;
    const double estimatedToolbarHeight = 48.0; // 增大高度以适应更大的字体和内边距
    
    // 计算工具栏位置，优先显示在鼠标点击位置下方
    const double verticalSpacing = 4.0; // 菜单与鼠标之间的垂直间距
    
    // 获取鼠标点击位置，如果没有则使用选中文本位置
    final Offset menuPosition = lastSecondaryTapDownPosition ?? Offset(
      globalEditableRegion.left + selectionMidpoint.dx,
      globalEditableRegion.top + selectionMidpoint.dy,
    );
    
    double left = menuPosition.dx;
    double top = menuPosition.dy + verticalSpacing;
    
    // 确保工具栏不会超出屏幕左侧
    if (left < 8.0) {
      left = 8.0;
    }
    // 确保工具栏不会超出屏幕右侧
    if (left + estimatedToolbarWidth > mediaQuery.size.width - 8.0) {
      left = mediaQuery.size.width - estimatedToolbarWidth - 8.0;
    }
    // 确保工具栏不会超出屏幕顶部
    if (top < 8.0) {
      top = 8.0;
    }
    // 确保工具栏不会超出屏幕底部
    if (top + estimatedToolbarHeight > mediaQuery.size.height - 8.0) {
      top = menuPosition.dy - estimatedToolbarHeight - verticalSpacing;
      if (top < 8.0) {
        top = 8.0;
      }
    }
    
    // 使用DefaultTextStyle确保整个菜单都使用OPPO Sans字体，增大字体大小
    return DefaultTextStyle(
      style: AppFonts.createStyle(
        fontSize: 16.0, // 增大字体大小
        color: Theme.of(context).colorScheme.onSurface,
      ),
      child: Stack(
        children: [
          Positioned(
            left: left,
            top: top,
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.circular(8.0),
              color: Theme.of(context).colorScheme.surface,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 剪切按钮
                  if (canCut(delegate))
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0), // 增大内边距
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () => handleCut(delegate),
                      child: Text(l10n?.cut ?? '剪切'),
                    ),
                  
                  // 复制按钮
                  if (canCopy(delegate))
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0), // 增大内边距
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () => handleCopy(delegate),
                      child: Text(l10n?.copy ?? '复制'),
                    ),
                  
                  // 粘贴按钮
                  if (canPaste(delegate))
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0), // 增大内边距
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () => handlePaste(delegate),
                      child: Text(l10n?.paste ?? '粘贴'),
                    ),
                  
                  // 全选按钮
                  if (canSelectAll(delegate))
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0), // 增大内边距
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () => handleSelectAll(delegate),
                      child: Text(l10n?.selectAll ?? '全选'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}