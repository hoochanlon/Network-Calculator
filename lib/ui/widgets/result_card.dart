import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';

/// 统一的结果展示卡片组件
/// 
/// 提供统一的结果展示样式，包括标题、复制按钮和内容区域
class ResultCard extends StatelessWidget {
  /// 标题文本
  final String title;
  
  /// 结果内容（可以是字符串或Widget列表）
  final dynamic content;
  
  /// 复制文本（如果为null，则不显示复制按钮）
  final String? copyText;
  
  /// 内容是否为字符串列表（用于多行显示）
  final bool isStringList;
  
  /// 自定义内容构建器（如果提供，将忽略content）
  final Widget Function(BuildContext)? contentBuilder;

  const ResultCard({
    super.key,
    required this.title,
    this.content,
    this.copyText,
    this.isStringList = false,
    this.contentBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (copyText != null)
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: copyText!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.copiedToClipboard)),
                      );
                    },
                  ),
              ],
            ),
            const Divider(),
            if (contentBuilder != null)
              contentBuilder!(context)
            else if (isStringList && content is List<String>)
              ...(content as List<String>).map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: SelectableText(
                      item,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ))
            else if (content is String)
              SelectableText(
                content as String,
                style: Theme.of(context).textTheme.bodyLarge,
              )
            else if (content is Widget)
              content as Widget
            else if (content is List<Widget>)
              ...(content as List<Widget>),
          ],
        ),
      ),
    );
  }
}

/// 结果行组件
/// 
/// 用于显示键值对形式的结果
class ResultRow extends StatelessWidget {
  /// 标签文本
  final String label;
  
  /// 值文本
  final String value;
  
  /// 是否高亮显示
  final bool isHighlight;
  
  /// 标签宽度
  final double labelWidth;

  const ResultRow({
    super.key,
    required this.label,
    required this.value,
    this.isHighlight = false,
    this.labelWidth = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: labelWidth,
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

