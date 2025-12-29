import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:network_calculator/l10n/app_localizations.dart';
import '../widgets/screen_title_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images/ncalc.svg',
                        width: 64,
                        height: 64,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).iconTheme.color ?? Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${l10n.appTitle} v1.0.0',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${l10n.author}: Hoochanlon',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.aboutAppDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.aboutFeatures,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            l10n.aboutFeature1,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            l10n.aboutFeature2,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            l10n.aboutFeature3,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            l10n.aboutFeature4,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            l10n.aboutFeature5,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            l10n.aboutFeature6,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.aboutTargetUsers,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.aboutVersionInfo,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => _launchURL(context, 'https://github.com/hoochanlon'),
                              child: SvgPicture.asset(
                                'assets/images/github.svg',
                                width: 40,
                                height: 40,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).iconTheme.color ?? Colors.black,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => _launchURL(context, 'mailto:hoochanlon@outlook.com'),
                              child: SvgPicture.asset(
                                'assets/images/email.svg',
                                width: 40,
                                height: 40,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).iconTheme.color ?? Colors.black,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => _launchURL(context, 'https://bsky.app/profile/hoochanlon.bsky.social'),
                              child: SvgPicture.asset(
                                'assets/images/bluesky.svg',
                                width: 40,
                                height: 40,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).iconTheme.color ?? Colors.black,
                                  BlendMode.srcIn,
                                ),
                              ),
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
        ),
      ),
    );
  }
}

