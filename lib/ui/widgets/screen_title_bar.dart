import 'package:flutter/material.dart';

class ScreenTitleBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;

  const ScreenTitleBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    // 与左侧边栏 Logo 区域高度对齐（padding: 20 * 2 = 40，加上内容高度约 28，总计约 68）
    // 标题栏 padding: 20（上下），确保底部边框对齐
    return Container(
      height: 68, // 固定高度，与左侧边栏 Logo 区域对齐
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (actions != null) ...[
            const Spacer(),
            ...actions!,
          ],
        ],
      ),
    );
  }
}

