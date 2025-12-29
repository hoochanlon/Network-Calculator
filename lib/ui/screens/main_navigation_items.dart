import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import '../../core/providers/calculator_settings_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/utils/calculator_name_translator.dart';
import '../../l10n/app_localizations.dart';
import 'calculator_screens/ip_calculator_screen.dart';
import 'calculator_screens/subnet_calculator_screen.dart';
import 'calculator_screens/base_converter_screen.dart';
import 'calculator_screens/network_merge_screen.dart';
import 'calculator_screens/network_split_screen.dart';
import 'calculator_screens/ip_inclusion_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'reference_screen.dart';
import 'main_navigation_item.dart';

/// 导航项管理器
class MainNavigationItemsManager {
  /// 获取导航项列表
  static Future<List<NavigationItem>> getNavigationItems(
    BuildContext context,
    GlobalKey<HistoryScreenState> historyKey,
    List<NavigationItem>? cachedItems,
    List<String>? cachedOrder,
    Locale? cachedLocale,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final savedOrder = await CalculatorSettingsProvider.getSidebarOrder();
    final currentLocale = Provider.of<LocaleProvider>(context, listen: false).locale;
    
    // 如果顺序和语言都没有变化，返回缓存的列表
    if (cachedItems != null && 
        cachedOrder != null &&
        _listEquals(cachedOrder, savedOrder) &&
        cachedLocale?.toString() == currentLocale.toString()) {
      return cachedItems;
    }

    // 创建所有导航项（包括计算器和特殊项）
    final allItems = <String, NavigationItem>{
      CalculatorKeys.ipCalculator: NavigationItem(
        icon: Symbols.bring_your_own_ip,
        label: l10n.ipCalculator,
        screen: const IpCalculatorScreen(),
        calculatorKey: CalculatorKeys.ipCalculator,
      ),
      CalculatorKeys.subnetCalculator: NavigationItem(
        icon: Symbols.account_tree,
        label: l10n.subnetCalculator,
        screen: const SubnetCalculatorScreen(),
        calculatorKey: CalculatorKeys.subnetCalculator,
      ),
      CalculatorKeys.baseConverter: NavigationItem(
        icon: Symbols.swap_horiz,
        label: l10n.baseConverter,
        screen: const BaseConverterScreen(),
        calculatorKey: CalculatorKeys.baseConverter,
      ),
      CalculatorKeys.networkMerge: NavigationItem(
        icon: Symbols.call_merge,
        label: l10n.networkMerge,
        screen: const NetworkMergeScreen(),
        calculatorKey: CalculatorKeys.networkMerge,
      ),
      CalculatorKeys.networkSplit: NavigationItem(
        icon: Symbols.call_split,
        label: l10n.networkSplit,
        screen: const NetworkSplitScreen(),
        calculatorKey: CalculatorKeys.networkSplit,
      ),
      CalculatorKeys.ipInclusionChecker: NavigationItem(
        icon: Symbols.search,
        label: l10n.ipInclusionChecker,
        screen: const IpInclusionScreen(),
        calculatorKey: CalculatorKeys.ipInclusionChecker,
      ),
      CalculatorKeys.history: NavigationItem(
        icon: Symbols.history,
        label: l10n.history,
        screen: HistoryScreen(key: historyKey),
        isSpecial: true,
        calculatorKey: CalculatorKeys.history,
      ),
      CalculatorKeys.references: NavigationItem(
        icon: Symbols.menu_book,
        label: l10n.references,
        screen: const ReferenceScreen(),
        isSpecial: true,
        calculatorKey: CalculatorKeys.references,
      ),
      CalculatorKeys.settings: NavigationItem(
        icon: Symbols.settings,
        label: l10n.settings,
        screen: const SettingsScreen(),
        isSpecial: true,
        calculatorKey: CalculatorKeys.settings,
      ),
    };

    // 按照保存的顺序排列所有项
    final orderedItems = <NavigationItem>[];
    for (final key in savedOrder) {
      if (allItems.containsKey(key)) {
        orderedItems.add(allItems[key]!);
      }
    }

    return orderedItems;
  }

  /// 比较两个列表是否相等
  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

