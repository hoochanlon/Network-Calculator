import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:network_calculator/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_fonts.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/calculator_state_provider.dart';
import 'ui/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
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

