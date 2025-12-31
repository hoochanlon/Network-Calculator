import 'package:flutter/material.dart';

/// 美化的开关按钮组件
/// 提供统一的开关样式，关闭状态使用与图标一致的浅灰色
class AppSwitch extends StatelessWidget {
  /// 开关的值
  final bool value;
  
  /// 开关值改变时的回调
  final ValueChanged<bool>? onChanged;
  
  /// 是否启用开关（默认为 true）
  final bool enabled;

  const AppSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // 获取图标颜色，用于关闭状态的颜色
    final iconColor = theme.iconTheme.color ??
        theme.textTheme.bodyMedium?.color?.withOpacity(0.6) ??
        const Color(0xFF9E9E9E);
    
    // 关闭状态：使用更柔和的浅灰色
    // 浅色主题：使用更浅的灰色，深色主题：使用稍深的灰色
    final inactiveThumbColor = isDark 
        ? iconColor.withOpacity(0.7)  // 深色主题：稍深一点
        : iconColor.withOpacity(0.5); // 浅色主题：更浅
    
    // 关闭状态的轨道颜色：更柔和的背景
    final inactiveTrackColor = isDark
        ? iconColor.withOpacity(0.15)  // 深色主题：更暗的背景
        : iconColor.withOpacity(0.25); // 浅色主题：更亮的背景

    // 使用 SwitchTheme 自定义样式，去除边框
    return SwitchTheme(
      data: SwitchThemeData(
        // 自定义滑块颜色
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return null; // 使用默认禁用颜色
            }
            if (value) {
              return theme.primaryColor; // 激活状态
            }
            return inactiveThumbColor; // 关闭状态
          },
        ),
        // 自定义轨道颜色
        trackColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return null; // 使用默认禁用颜色
            }
            if (value) {
              return theme.primaryColor.withOpacity(0.3); // 激活状态
            }
            return inactiveTrackColor; // 关闭状态
          },
        ),
        // 交互效果
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (!enabled) return null;
            if (states.contains(WidgetState.pressed)) {
              return theme.primaryColor.withOpacity(0.15);
            }
            if (states.contains(WidgetState.hovered)) {
              return theme.primaryColor.withOpacity(0.08);
            }
            return null;
          },
        ),
        // 去除边框：设置轨道轮廓颜色为透明
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        // 材质效果
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashRadius: 18,
      ),
      child: Switch.adaptive(
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}

