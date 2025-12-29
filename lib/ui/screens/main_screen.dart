import 'package:flutter/material.dart';
import 'package:network_calculator/l10n/app_localizations.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../core/providers/calculator_settings_provider.dart';
import '../../core/providers/locale_provider.dart';
import 'history_screen.dart';
import 'main_navigation_item.dart';
import 'main_navigation_items.dart';
import 'main_social_footer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  String? _currentItemKey; // 跟踪当前选中项的 key，用于排序改变时保持选中状态
  final GlobalKey<HistoryScreenState> _historyKey = GlobalKey<HistoryScreenState>();
  List<NavigationItem>? _cachedNavigationItems;
  List<String>? _cachedCalculatorOrder;
  Locale? _cachedLocale;
  LocaleProvider? _localeProvider;
  bool _sidebarDragEnabled = false;

  @override
  void initState() {
    super.initState();
    // 监听计算器顺序变化
    CalculatorSettingsProvider.orderNotifier.addListener(_onOrderChanged);
    // 初始化锁定状态（仅在首次使用时）
    CalculatorSettingsProvider.initializeLockedItems();
    // 监听语言变化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _localeProvider = Provider.of<LocaleProvider>(context, listen: false);
        _localeProvider?.addListener(_onLocaleChanged);
        _loadSidebarDragEnabled();
      }
    });
  }

  Future<void> _loadSidebarDragEnabled() async {
    final enabled = await CalculatorSettingsProvider.getSidebarDragEnabled();
    if (mounted) {
      setState(() {
        _sidebarDragEnabled = enabled;
      });
    }
  }

  @override
  void dispose() {
    CalculatorSettingsProvider.orderNotifier.removeListener(_onOrderChanged);
    // 移除语言变化监听
    _localeProvider?.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onOrderChanged() async {
    // 重新加载拖拽状态（可能在设置界面中更改了）
    await _loadSidebarDragEnabled();
    
    // 保存当前选中项的 key
    String? currentKey = _currentItemKey;
    if (currentKey == null && _cachedNavigationItems != null && 
        _currentIndex >= 0 && _currentIndex < _cachedNavigationItems!.length) {
      currentKey = _cachedNavigationItems![_currentIndex].calculatorKey;
    }
    
    // 清除缓存，强制刷新
    _cachedNavigationItems = null;
    _cachedCalculatorOrder = null;
    
    // 如果找到了当前项的 key，在新列表中查找其新位置
    if (currentKey != null && mounted) {
      final newItems = await _getNavigationItems();
      final newIndex = newItems.indexWhere(
        (item) => item.calculatorKey == currentKey
      );
      if (newIndex >= 0 && mounted) {
        setState(() {
          _currentIndex = newIndex;
          _currentItemKey = currentKey;
        });
      }
    } else {
      // 如果没有找到 key，只是刷新界面
      setState(() {});
    }
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
    final items = await MainNavigationItemsManager.getNavigationItems(
      context,
      _historyKey,
      _cachedNavigationItems,
      _cachedCalculatorOrder,
      _cachedLocale,
    );
    
    // 更新缓存
    final savedOrder = await CalculatorSettingsProvider.getSidebarOrder();
    final currentLocale = Provider.of<LocaleProvider>(context, listen: false).locale;
    _cachedNavigationItems = items;
    _cachedCalculatorOrder = List<String>.from(savedOrder);
    _cachedLocale = currentLocale;
    
    // 如果当前索引有效，确保 _currentItemKey 已设置
    if (_currentItemKey == null && _currentIndex >= 0 && _currentIndex < items.length) {
      _currentItemKey = items[_currentIndex].calculatorKey;
    }
    
    return items;
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
            width: 230,
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
                      
                      // 如果启用了拖拽排序，使用 ReorderableListView
                      if (_sidebarDragEnabled) {
                        return FutureBuilder<Set<String>>(
                          future: CalculatorSettingsProvider.getLockedItems(),
                          builder: (context, lockedSnapshot) {
                            if (!lockedSnapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final lockedItems = lockedSnapshot.data!;
                            
                            return StatefulBuilder(
                              builder: (context, setLocalState) {
                                return ReorderableListView(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  proxyDecorator: (child, index, animation) {
                                    return Material(
                                      elevation: 6,
                                      shadowColor: Colors.black26,
                                      borderRadius: BorderRadius.circular(8),
                                      child: child,
                                    );
                                  },
                                  onReorder: (oldIndex, newIndex) {
                                    if (newIndex > oldIndex) {
                                      newIndex -= 1;
                                    }
                                    
                                    // 检查是否尝试移动锁定的项目
                                    final oldKey = items[oldIndex].calculatorKey;
                                    if (oldKey != null && lockedItems.contains(oldKey)) {
                                      return; // 锁定的项目不能移动
                                    }
                                    
                                    // 检查目标位置是否是锁定项目
                                    final targetKey = items[newIndex].calculatorKey;
                                    if (targetKey != null && lockedItems.contains(targetKey)) {
                                      return; // 不能移动到锁定项目的位置
                                    }
                                    
                                    // 保存当前选中项的 key
                                    String? currentKey = _currentItemKey;
                                    if (currentKey == null && _currentIndex >= 0 && _currentIndex < items.length) {
                                      currentKey = items[_currentIndex].calculatorKey;
                                    }
                                    
                                    // 构建新顺序，保持锁定项目的位置不变
                                    final currentOrder = List<String>.from(
                                      items.map((e) => e.calculatorKey ?? '').toList()
                                    );
                                    
                                    // 记录锁定项目及其原始位置
                                    final Map<int, String> lockedPositions = {};
                                    for (int i = 0; i < currentOrder.length; i++) {
                                      if (lockedItems.contains(currentOrder[i])) {
                                        lockedPositions[i] = currentOrder[i];
                                      }
                                    }
                                    
                                    // 创建只包含非锁定项目的列表
                                    final nonLockedItems = <String>[];
                                    final nonLockedIndices = <int>[];
                                    for (int i = 0; i < currentOrder.length; i++) {
                                      if (!lockedItems.contains(currentOrder[i])) {
                                        nonLockedItems.add(currentOrder[i]);
                                        nonLockedIndices.add(i);
                                      }
                                    }
                                    
                                    // 在非锁定项目列表中执行移动
                                    final oldNonLockedIndex = nonLockedIndices.indexOf(oldIndex);
                                    if (oldNonLockedIndex == -1) return;
                                    
                                    // 计算目标位置在非锁定项目列表中的索引
                                    int targetNonLockedIndex = 0;
                                    for (int i = 0; i < nonLockedIndices.length; i++) {
                                      if (nonLockedIndices[i] >= newIndex) {
                                        targetNonLockedIndex = i;
                                        break;
                                      }
                                      targetNonLockedIndex = i + 1;
                                    }
                                    
                                    // 在非锁定项目列表中移动
                                    final movedItem = nonLockedItems.removeAt(oldNonLockedIndex);
                                    nonLockedItems.insert(targetNonLockedIndex, movedItem);
                                    
                                    // 重新构建完整顺序，保持锁定项目在原来的位置
                                    final finalOrder = <String>[];
                                    int nonLockedItemIndex = 0;
                                    
                                    for (int i = 0; i < currentOrder.length; i++) {
                                      if (lockedPositions.containsKey(i)) {
                                        // 保持锁定项目在原来的位置
                                        finalOrder.add(lockedPositions[i]!);
                                      } else {
                                        // 插入非锁定项目
                                        if (nonLockedItemIndex < nonLockedItems.length) {
                                          finalOrder.add(nonLockedItems[nonLockedItemIndex]);
                                          nonLockedItemIndex++;
                                        }
                                      }
                                    }
                                    
                                    // 立即更新本地状态，使UI平滑过渡
                                    setLocalState(() {
                                      // 更新缓存，避免重新获取
                                      _cachedCalculatorOrder = finalOrder;
                                      _cachedNavigationItems = null; // 清除缓存，强制重新构建
                                    });
                                    
                                    // 异步保存新顺序（不阻塞UI）
                                    CalculatorSettingsProvider.setSidebarOrder(finalOrder).then((_) {
                                      // 更新当前索引
                                      if (currentKey != null && mounted) {
                                        _getNavigationItems().then((newItems) {
                                          final foundIndex = newItems.indexWhere(
                                            (item) => item.calculatorKey == currentKey
                                          );
                                          if (foundIndex >= 0 && mounted) {
                                            setState(() {
                                              _currentIndex = foundIndex;
                                              _currentItemKey = currentKey;
                                            });
                                          }
                                        });
                                      }
                                    });
                                  },
                                  children: items.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final item = entry.value;
                                    final isSelected = _currentIndex == index;
                                    final isLocked = item.calculatorKey != null && lockedItems.contains(item.calculatorKey);
                                    
                                    Widget child = MainNavigationItemBuilder.buildNavigationItem(
                                      context,
                                      item,
                                      index,
                                      isSelected,
                                      () {
                                        setState(() {
                                          _currentIndex = index;
                                          _currentItemKey = item.calculatorKey;
                                        });
                                        if (item.screen is HistoryScreen && _historyKey.currentState != null) {
                                          _historyKey.currentState!.refreshHistory();
                                        }
                                      },
                                      isLocked: isLocked,
                                      showDragHandle: true,
                                      onLockToggle: () {
                                        setState(() {});
                                      },
                                    );
                                    
                                    // 使用稳定的 key，确保 Flutter 能正确识别项目
                                    final itemKey = item.calculatorKey ?? 'item_$index';
                                    
                                    // 如果项目被锁定，不能拖拽
                                    if (isLocked) {
                                      return KeyedSubtree(
                                        key: ValueKey(itemKey),
                                        child: child,
                                      );
                                    } else {
                                      return ReorderableDragStartListener(
                                        key: ValueKey(itemKey),
                                        index: index,
                                        child: child,
                                      );
                                    }
                                  }).toList(),
                                );
                              },
                            );
                          },
                        );
                      } else {
                        // 未启用拖拽排序，使用普通的 ListView
                        return ListView.builder(
                          key: ValueKey(items.map((e) => e.calculatorKey ?? '').join(',')),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final isSelected = _currentIndex == index;
                            
                            return FutureBuilder<bool>(
                              future: item.calculatorKey != null 
                                  ? CalculatorSettingsProvider.isItemLocked(item.calculatorKey!)
                                  : Future.value(false),
                              builder: (context, lockSnapshot) {
                                final isLocked = lockSnapshot.data ?? false;
                                return MainNavigationItemBuilder.buildNavigationItem(
                                  context,
                                  item,
                                  index,
                                  isSelected,
                                  () {
                                    setState(() {
                                      _currentIndex = index;
                                      _currentItemKey = item.calculatorKey;
                                    });
                                    if (item.screen is HistoryScreen && _historyKey.currentState != null) {
                                      _historyKey.currentState!.refreshHistory();
                                    }
                                  },
                                  isLocked: isLocked,
                                  showDragHandle: false,
                                  onLockToggle: () {
                                    setState(() {});
                                  },
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                // 页脚社交图标
                MainSocialFooterBuilder.buildSocialFooter(context),
              ],
            ),
          ),
          // 右侧内容区域
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth > 1200 ? 1200.0 : constraints.maxWidth;
                return Center(
                  child: SizedBox(
                    width: maxWidth,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}



