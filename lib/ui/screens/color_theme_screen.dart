import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:network_calculator/l10n/app_localizations.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/models/color_theme.dart';
import '../widgets/screen_title_bar.dart';

class ColorThemeScreen extends StatefulWidget {
  const ColorThemeScreen({super.key});

  @override
  State<ColorThemeScreen> createState() => _ColorThemeScreenState();
}

class _ColorThemeScreenState extends State<ColorThemeScreen> {
  // 缓存当前选中的主题ID，避免不必要的重建
  String? _cachedSelectedThemeId;
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    // 只在主题真正改变时更新缓存
    final currentThemeId = themeProvider.currentColorTheme.id;
    if (_cachedSelectedThemeId != currentThemeId) {
      _cachedSelectedThemeId = currentThemeId;
    }

    return Scaffold(
      body: Column(
        children: [
          // ScreenTitleBar(
          //   title: l10n.colorTheme,
          // ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                Text(
                  l10n.presetThemes,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: _buildThemeList(
                      context,
                      ColorTheme.presets,
                      themeProvider,
                      l10n,
                    ),
                  ),
                ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildThemeList(
    BuildContext context,
    List<ColorTheme> themes,
    ThemeProvider themeProvider,
    AppLocalizations l10n,
  ) {
    // 使用缓存的选中主题ID，减少不必要的比较
    final currentThemeId = _cachedSelectedThemeId ?? themeProvider.currentColorTheme.id;
    final widgets = <Widget>[];

    for (int i = 0; i < themes.length; i++) {
      final theme = themes[i];
      final isSelected = currentThemeId == theme.id;

      widgets.add(
        ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.primaryColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? theme.primaryColor
                    : Theme.of(context).dividerColor,
                width: isSelected ? 3 : 1,
              ),
            ),
          ),
          title: Text(_getThemeDisplayName(theme, l10n)),
          trailing: isSelected
              ? Icon(Icons.check_circle, color: theme.primaryColor)
              : null,
          selected: isSelected,
          onTap: () {
            // 优化：如果已经选中，不执行操作
            if (isSelected) return;
            
            // 立即更新缓存，提供即时反馈
            setState(() {
              _cachedSelectedThemeId = theme.id;
            });
            
            // 使用 requestAnimationFrame 优化，在下一帧更新主题
            // 这样可以让UI先响应点击，然后再更新主题，减少卡顿感
            WidgetsBinding.instance.addPostFrameCallback((_) {
              themeProvider.setColorTheme(theme);
            });
          },
        ),
      );

      if (i < themes.length - 1) {
        widgets.add(const Divider(height: 1));
      }
    }

    return widgets;
  }

  String _getThemeDisplayName(ColorTheme theme, AppLocalizations l10n) {
    switch (theme.id) {
      case 'netease_red':
        return l10n.neteaseRed;
      case 'facebook_blue':
        return l10n.facebookBlue;
      case 'spotify_green':
        return l10n.spotifyGreen;
      case 'qq_music_yellow':
        return l10n.qqMusicYellow;
      case 'bilibili_pink':
        return l10n.bilibiliPink;
      default:
        return theme.name;
    }
  }
}


