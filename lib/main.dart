import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:network_calculator/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_fonts.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/calculator_state_provider.dart';
import 'core/providers/calculator_settings_provider.dart';
import 'ui/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 预加载字体，优化启动性能和字体渲染
  // Web 端也需要预加载，特别是 iOS Safari 需要确保字体正确加载
  await _preloadFonts();
  
  // 初始化窗口尺寸（仅桌面平台）
  if (!kIsWeb) {
    await _initializeWindow();
  }
  
  runApp(const MyApp());
}

/// 初始化窗口尺寸
Future<void> _initializeWindow() async {
  try {
    await windowManager.ensureInitialized();
    
    // 获取保存的窗口尺寸
    final width = await CalculatorSettingsProvider.getWindowWidth();
    final height = await CalculatorSettingsProvider.getWindowHeight();
    final minWidth = CalculatorSettingsProvider.minWindowWidth;
    final minHeight = CalculatorSettingsProvider.minWindowHeight;
    
    // 设置最小窗口尺寸
    await windowManager.setMinimumSize(Size(minWidth, minHeight));
    
    // 设置窗口尺寸
    await windowManager.setSize(Size(width, height));
    
    // 居中显示窗口
    await windowManager.center();
    
    // 显示窗口
    await windowManager.show();
    await windowManager.focus();
  } catch (e) {
    // 窗口初始化失败不影响应用启动
    debugPrint('Window initialization failed: $e');
  }
}

/// 预加载字体资源
/// 在应用启动时预加载字体，减少首次渲染时的延迟
/// 对所有平台都进行预加载，特别是 iOS Safari 需要确保字体正确加载
Future<void> _preloadFonts() async {
  try {
    // 预加载主字体，使用不同权重确保完整加载
    final fontLoader = FontLoader(AppFonts.primaryFontFamily);
    fontLoader.addFont(_loadFont('assets/fonts/OPPOSans4.0.ttf'));
    await fontLoader.load();
    
    // 在 Web 端，额外等待一小段时间确保字体完全加载（iOS Safari 需要）
    if (kIsWeb) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  } catch (e) {
    // 字体加载失败不影响应用启动，使用系统默认字体
    debugPrint('Font preload failed: $e');
  }
}

/// 加载字体文件
Future<ByteData> _loadFont(String path) async {
  return await rootBundle.load(path);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CalculatorStateProvider()),
      ],
      child: Builder(
        builder: (context) {
          return Consumer2<LocaleProvider, ThemeProvider>(
            builder: (context, localeProvider, themeProvider, _) {
              final primaryColor = themeProvider.currentColorTheme.primaryColor;
              // 获取本地化的应用标题
              final appTitle = AppLocalizations.of(context)?.appTitle ?? 'Network Calculator';
              return DefaultTextStyle(
                style: AppFonts.createStyle(fontSize: 14),
                child: MaterialApp(
                  title: appTitle,
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.getLightTheme(primaryColor),
                  darkTheme: AppTheme.getDarkTheme(primaryColor),
                  themeMode: themeProvider.themeMode,
                  locale: localeProvider.locale,
                  // 确保响应式文本缩放时也使用自定义字体
                  builder: (context, child) {
                    return MediaQuery(
                      // 限制文本缩放范围，避免过度缩放
                      data: MediaQuery.of(context).copyWith(
                        textScaler: MediaQuery.of(context).textScaler.clamp(
                          minScaleFactor: 0.8,
                          maxScaleFactor: 1.5,
                        ),
                      ),
                      child: DefaultTextStyle(
                        style: AppFonts.createStyle(fontSize: 14),
                        child: child!,
                      ),
                    );
                  },
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('zh'), // 简体中文
                    Locale('zh', 'TW'), // 繁体中文
                    Locale('en'), // 英文
                    Locale('ja'), // 日语
                  ],
                  home: const MainScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

