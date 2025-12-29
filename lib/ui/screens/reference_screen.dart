import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:network_calculator/l10n/app_localizations.dart';
import '../widgets/screen_title_bar.dart';

class ReferenceScreen extends StatelessWidget {
  const ReferenceScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Column(
        children: [
          ScreenTitleBar(title: l10n.references),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 基础 IP 与子网工具
                      _buildSection(
                        context,
                        '📊 ${l10n.referenceBasicTools}',
                        [
                          _buildSubsection(
                            context,
                            l10n.referenceIpAddressCalc,
                            l10n.referenceIpAddressCalcDesc,
                            [
                              _buildLinkItem(
                                context,
                                'IPv4Calc',
                                'https://ipv4calc.bmcx.com/',
                                'https://ipv4calc.bmcx.com/',
                              ),
                              _buildLinkItem(
                                context,
                                l10n.referenceIpCalculator,
                                'https://ipjisuanqi.com/',
                                'https://ipjisuanqi.com/',
                              ),
                            ],
                          ),
                          _buildSubsection(
                            context,
                            l10n.referenceSubnetCidr,
                            l10n.referenceSubnetCidrDesc,
                            [
                              _buildLinkItem(
                                context,
                                'ToolJson Subnetmask Calculator',
                                'https://www.tooljson.com/network/subnetmask-calculator',
                                'https://www.tooljson.com/network/subnetmask-calculator',
                              ),
                              _buildLinkItem(
                                context,
                                'SolarWinds Advanced Subnet Calculator',
                                'https://www.solarwinds.com/free-tools/advanced-subnet-calculator',
                                'https://www.solarwinds.com/free-tools/advanced-subnet-calculator',
                              ),
                              _buildLinkItem(
                                context,
                                'CIDR.xyz',
                                'https://cidr.xyz/',
                                'https://cidr.xyz/',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // 路由聚合与超网拆分
                      _buildSection(
                        context,
                        '🔀 ${l10n.referenceRouteAggregation}',
                        [
                          _buildSubsection(
                            context,
                            l10n.referenceSupernetSplit,
                            l10n.referenceSupernetSplitDesc,
                            [
                              _buildLinkItem(
                                context,
                                'CIDR Splitter',
                                'https://cidrsplitter.com/',
                                'https://cidrsplitter.com/',
                              ),
                            ],
                          ),
                          _buildSubsection(
                            context,
                            l10n.referenceRouteAggregationTitle,
                            l10n.referenceRouteAggregationDesc,
                            [
                              _buildLinkItem(
                                context,
                                'Networks.tools CIDR Deduplicator',
                                'https://networks.tools/cidr-deduplicator',
                                'https://networks.tools/cidr-deduplicator',
                              ),
                              _buildLinkItem(
                                context,
                                'Calcip Route Summarization',
                                'https://www.calcip.com/route-summarization',
                                'https://www.calcip.com/route-summarization',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // 学习与速查资源
                      _buildSection(
                        context,
                        '📖 ${l10n.referenceLearningResources}',
                        [
                          _buildSubsection(
                            context,
                            l10n.referenceTechBlogs,
                            '',
                            [
                              _buildLinkItem(
                                context,
                                l10n.referenceSubnetRouteBlog,
                                'https://www.cnblogs.com/TRY0929/p/14737533.html',
                                'https://www.cnblogs.com/TRY0929/p/14737533.html',
                              ),
                            ],
                          ),
                          _buildSubsection(
                            context,
                            l10n.referenceCheatSheets,
                            '',
                            [
                              _buildLinkItem(
                                context,
                                'IPv4/IPv6 CIDR 与子网速查表',
                                'https://cloudzy.com/wp-content/uploads/Network-Cheat-Sheet-_-IPv4-IPv6-CIDR-and-Subnetting.pdf',
                                'https://cloudzy.com/wp-content/uploads/Network-Cheat-Sheet-_-IPv4-IPv6-CIDR-and-Subnetting.pdf',
                              ),
                              _buildLinkItem(
                                context,
                                'Cisco 相关网络速查表',
                                'https://ipcisco.com/cheat-sheets',
                                'https://ipcisco.com/cheat-sheets',
                              ),
                              _buildLinkItem(
                                context,
                                'GeeksforGeeks 计算机网络速查表',
                                'https://www.geeksforgeeks.org/computer-networks/computer-network-cheat-sheet',
                                'https://www.geeksforgeeks.org/computer-networks/computer-network-cheat-sheet',
                              ),
                              _buildLinkItem(
                                context,
                                'cheatography 更多网络类速查表',
                                'https://cheatography.com/tag/networking',
                                'https://cheatography.com/tag/networking',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSubsection(
    BuildContext context,
    String title,
    String description,
    List<Widget> links,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
          ],
          const SizedBox(height: 12),
          ...links,
        ],
      ),
    );
  }

  Widget _buildLinkItem(BuildContext context, String title, String url, String displayUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _launchURL(context, url),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Symbols.open_in_new,
                size: 18,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayUrl,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

