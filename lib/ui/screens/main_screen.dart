import 'package:flutter/material.dart';
import 'package:network_calculator/l10n/app_localizations.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/providers/calculator_settings_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/utils/calculator_name_translator.dart';
import 'calculator_screens/ip_calculator_screen.dart';
import 'calculator_screens/subnet_calculator_screen.dart';
import 'calculator_screens/base_converter_screen.dart';
import 'calculator_screens/network_merge_screen.dart';
import 'calculator_screens/network_split_screen.dart';
import 'calculator_screens/ip_inclusion_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<HistoryScreenState> _historyKey = GlobalKey<HistoryScreenState>();
  List<NavigationItem>? _cachedNavigationItems;
  List<String>? _cachedCalculatorOrder;
  Locale? _cachedLocale;
  LocaleProvider? _localeProvider;

  @override
  void initState() {
    super.initState();
    // 监听计算器顺序变化
    CalculatorSettingsProvider.orderNotifier.addListener(_onOrderChanged);
    // 监听语言变化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _localeProvider = Provider.of<LocaleProvider>(context, listen: false);
        _localeProvider?.addListener(_onLocaleChanged);
      }
    });
  }

  @override
  void dispose() {
    CalculatorSettingsProvider.orderNotifier.removeListener(_onOrderChanged);
    // 移除语言变化监听
    _localeProvider?.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onOrderChanged() {
    // 清除缓存，强制刷新
    setState(() {
      _cachedNavigationItems = null;
      _cachedCalculatorOrder = null;
    });
  }

  void _onLocaleChanged() {
    // 当语言变化时，清除缓存，强制刷新侧边栏
    setState(() {
      _cachedNavigationItems = null;
      _cachedCalculatorOrder = null;
      _cachedLocale = null;
    });
  }

  Future<List<NavigationItem>> _getNavigationItems() async {
    final l10n = AppLocalizations.of(context)!;
    final savedOrder = await CalculatorSettingsProvider.getCalculatorOrder();
    final currentLocale = Provider.of<LocaleProvider>(context, listen: false).locale;
    
    // 如果顺序和语言都没有变化，返回缓存的列表
    // 使用语言代码作为缓存键的一部分，确保语言变化时刷新
    if (_cachedNavigationItems != null && 
        _cachedCalculatorOrder != null &&
        _listEquals(_cachedCalculatorOrder!, savedOrder) &&
        _cachedLocale?.toString() == currentLocale.toString()) {
      return _cachedNavigationItems!;
    }

    // 创建所有计算器项（不包括特殊项）
    final allCalculators = <String, NavigationItem>{
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
    };

    // 按照保存的顺序排列计算器
    final orderedCalculators = <NavigationItem>[];
    for (final key in savedOrder) {
      if (allCalculators.containsKey(key)) {
        orderedCalculators.add(allCalculators[key]!);
      }
    }

    // 添加特殊项（历史记录和设置）
    orderedCalculators.addAll([
      NavigationItem(
        icon: Symbols.history,
        label: l10n.history,
        screen: HistoryScreen(key: _historyKey),
        isSpecial: true,
      ),
      NavigationItem(
        icon: Symbols.settings,
        label: l10n.settings,
        screen: const SettingsScreen(),
        isSpecial: true,
      ),
    ]);

    _cachedNavigationItems = orderedCalculators;
    _cachedCalculatorOrder = List<String>.from(savedOrder);
    _cachedLocale = currentLocale;
    return orderedCalculators;
  }

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _refreshNavigationItems() {
    setState(() {
      _cachedNavigationItems = null;
      _cachedCalculatorOrder = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Row(
        children: [
          // 左侧导航栏
          Container(
            width: 220,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF252525) : Colors.white,
              border: Border(
                right: BorderSide(
                  color: isDark ? const Color(0xFF404040) : const Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Logo 区域
                Container(
                  height: 68, // 固定高度，与右侧内容区域标题栏对齐
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? const Color(0xFF404040) : const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/ncalc.svg',
                        width: 28,
                        height: 28,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.appTitle,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // 导航菜单
                Expanded(
                  child: FutureBuilder<List<NavigationItem>>(
                    future: _getNavigationItems(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final items = snapshot.data!;
                      return ListView.builder(
                        key: ValueKey(items.map((e) => e.calculatorKey ?? '').join(',')),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final isSelected = _currentIndex == index;
                          
                          return _buildNavigationItem(context, item, index, isSelected, items);
                        },
                      );
                    },
                  ),
                ),
                // 页脚社交图标
                _buildSocialFooter(context),
              ],
            ),
          ),
          // 右侧内容区域
          Expanded(
            child: FutureBuilder<List<NavigationItem>>(
              future: _getNavigationItems(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data!;
                return IndexedStack(
                  index: _currentIndex,
                  children: items.map((item) => item.screen).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    NavigationItem item,
    int index,
    bool isSelected,
    List<NavigationItem> items,
  ) {
    return InkWell(
      // mouseCursor: SystemMouseCursors.click,
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        // 当切换到历史记录页面时，刷新数据
        if (item.screen is HistoryScreen && _historyKey.currentState != null) {
          _historyKey.currentState!.refreshHistory();
        }
      },
      mouseCursor: SystemMouseCursors.click,
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
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.cannotOpenLink}: $url')),
        );
      }
    }
  }

  Widget _buildSocialFooter(BuildContext context) {
    // 使用主题的主色调
    final primaryColor = Theme.of(context).primaryColor;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF404040)
                : const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Blog
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _launchURL(context, 'https://hoochanlon.github.io'),
              child: SvgPicture.asset(
                'assets/images/blog.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // GitHub
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _launchURL(context, 'https://github.com/hoochanlon'),
              child: SvgPicture.asset(
                'assets/images/github.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Bluesky
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _launchURL(context, 'https://bsky.app/profile/hoochanlon.bsky.social'),
              child: SvgPicture.asset(
                'assets/images/bluesky.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Email
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _launchURL(context, 'mailto:hoochanlon@outlook.com'),
              child: SvgPicture.asset(
                'assets/images/email.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

class CalculatorHomeScreen extends StatelessWidget {
  const CalculatorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Symbols.bring_your_own_ip, size: 28),
            const SizedBox(width: 12),
            Text(l10n.appTitle),
          ],
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1E1E1E),
                    const Color(0xFF2C2C2C).withOpacity(0.5),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFF5F5F5),
                    const Color(0xFFFAFAFA),
                  ],
                ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 欢迎标题
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appTitle,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)?.appSubtitle ?? 'Professional Network Calculator Toolset',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 网格布局
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.15,
                    children: [
                      _buildCalculatorCard(
                        context,
                        l10n.ipCalculator,
                        Symbols.bring_your_own_ip,
                        Colors.red,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const IpCalculatorScreen()),
                        ),
                      ),
                      _buildCalculatorCard(
                        context,
                        l10n.subnetCalculator,
                        Symbols.account_tree,
                        Colors.orange,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SubnetCalculatorScreen()),
                        ),
                      ),
                      _buildCalculatorCard(
                        context,
                        l10n.baseConverter,
                        Symbols.swap_horiz,
                        Colors.blue,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const BaseConverterScreen()),
                        ),
                      ),
                      _buildCalculatorCard(
                        context,
                        l10n.networkMerge,
                        Symbols.call_merge,
                        Colors.green,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NetworkMergeScreen()),
                        ),
                      ),
                      _buildCalculatorCard(
                        context,
                        l10n.networkSplit,
                        Symbols.call_split,
                        Colors.purple,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NetworkSplitScreen()),
                        ),
                      ),
                      _buildCalculatorCard(
                        context,
                        l10n.ipInclusionChecker,
                        Symbols.search,
                        Colors.teal,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const IpInclusionScreen()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)?.getStarted ?? 'Get Started',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Symbols.arrow_forward,
                      size: 14,
                      color: color,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

