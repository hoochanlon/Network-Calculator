import 'package:flutter/material.dart';
import 'package:network_calculator/l10n/app_localizations.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'calculator_screens/ip_calculator_screen.dart';
import 'calculator_screens/subnet_calculator_screen.dart';
import 'calculator_screens/base_converter_screen.dart';
import 'calculator_screens/network_merge_screen.dart';
import 'calculator_screens/network_split_screen.dart';
import 'calculator_screens/ip_inclusion_screen.dart';

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

