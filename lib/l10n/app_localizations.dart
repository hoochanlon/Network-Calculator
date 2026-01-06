import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('zh'),
    Locale('zh', 'HK')
  ];

  /// 应用程序标题
  ///
  /// In zh, this message translates to:
  /// **'网络计算器'**
  String get appTitle;

  /// No description provided for @ipCalculator.
  ///
  /// In zh, this message translates to:
  /// **'IP地址计算器'**
  String get ipCalculator;

  /// No description provided for @subnetCalculator.
  ///
  /// In zh, this message translates to:
  /// **'子网掩码计算器'**
  String get subnetCalculator;

  /// No description provided for @baseConverter.
  ///
  /// In zh, this message translates to:
  /// **'IP进制转换器'**
  String get baseConverter;

  /// No description provided for @networkMerge.
  ///
  /// In zh, this message translates to:
  /// **'路由聚合计算器'**
  String get networkMerge;

  /// No description provided for @networkSplit.
  ///
  /// In zh, this message translates to:
  /// **'超网拆分计算器'**
  String get networkSplit;

  /// No description provided for @ipInclusionChecker.
  ///
  /// In zh, this message translates to:
  /// **'IP包含检测器'**
  String get ipInclusionChecker;

  /// No description provided for @history.
  ///
  /// In zh, this message translates to:
  /// **'历史记录'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settings;

  /// No description provided for @about.
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get about;

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get language;

  /// No description provided for @chinese.
  ///
  /// In zh, this message translates to:
  /// **'中文（中国）'**
  String get chinese;

  /// No description provided for @english.
  ///
  /// In zh, this message translates to:
  /// **'English（美国）'**
  String get english;

  /// No description provided for @japanese.
  ///
  /// In zh, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// No description provided for @traditionalChinese.
  ///
  /// In zh, this message translates to:
  /// **'繁體中文（中國香港）'**
  String get traditionalChinese;

  /// No description provided for @followSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get followSystem;

  /// No description provided for @preserveInputs.
  ///
  /// In zh, this message translates to:
  /// **'保留输入和结果'**
  String get preserveInputs;

  /// No description provided for @preserveInputsDescription.
  ///
  /// In zh, this message translates to:
  /// **'切换计算器时保留输入内容和计算结果'**
  String get preserveInputsDescription;

  /// No description provided for @calculate.
  ///
  /// In zh, this message translates to:
  /// **'计算'**
  String get calculate;

  /// No description provided for @clear.
  ///
  /// In zh, this message translates to:
  /// **'清空'**
  String get clear;

  /// No description provided for @inputIpAddress.
  ///
  /// In zh, this message translates to:
  /// **'请输入IP地址'**
  String get inputIpAddress;

  /// No description provided for @inputSubnetMask.
  ///
  /// In zh, this message translates to:
  /// **'请输入子网掩码'**
  String get inputSubnetMask;

  /// No description provided for @inputHosts.
  ///
  /// In zh, this message translates to:
  /// **'请输入主机数'**
  String get inputHosts;

  /// No description provided for @inputSubnetOrCidr.
  ///
  /// In zh, this message translates to:
  /// **'请输入子网掩码或CIDR'**
  String get inputSubnetOrCidr;

  /// No description provided for @inputBaseValue.
  ///
  /// In zh, this message translates to:
  /// **'请输入IP地址或数值'**
  String get inputBaseValue;

  /// No description provided for @inputNetworks.
  ///
  /// In zh, this message translates to:
  /// **'请输入CIDR格式的网段，以换行做分隔'**
  String get inputNetworks;

  /// No description provided for @inputSupernet.
  ///
  /// In zh, this message translates to:
  /// **'请输入需拆分的超网（CIDR格式）'**
  String get inputSupernet;

  /// No description provided for @inputTargetMask.
  ///
  /// In zh, this message translates to:
  /// **'请输入目标子网掩码长度（1~32）'**
  String get inputTargetMask;

  /// No description provided for @inputCheckCidr.
  ///
  /// In zh, this message translates to:
  /// **'请输入需要验证的CIDR或IP'**
  String get inputCheckCidr;

  /// No description provided for @inputTargetCidr.
  ///
  /// In zh, this message translates to:
  /// **'请输入目标CIDR网段'**
  String get inputTargetCidr;

  /// No description provided for @ipAddress.
  ///
  /// In zh, this message translates to:
  /// **'IP地址'**
  String get ipAddress;

  /// No description provided for @networkAddress.
  ///
  /// In zh, this message translates to:
  /// **'网络地址'**
  String get networkAddress;

  /// No description provided for @broadcastAddress.
  ///
  /// In zh, this message translates to:
  /// **'广播地址'**
  String get broadcastAddress;

  /// No description provided for @usableIps.
  ///
  /// In zh, this message translates to:
  /// **'可用IP数量'**
  String get usableIps;

  /// No description provided for @firstUsableIp.
  ///
  /// In zh, this message translates to:
  /// **'第一可用IP'**
  String get firstUsableIp;

  /// No description provided for @lastUsableIp.
  ///
  /// In zh, this message translates to:
  /// **'最后可用IP'**
  String get lastUsableIp;

  /// No description provided for @networkClass.
  ///
  /// In zh, this message translates to:
  /// **'网络类别'**
  String get networkClass;

  /// No description provided for @cidr.
  ///
  /// In zh, this message translates to:
  /// **'CIDR'**
  String get cidr;

  /// No description provided for @subnetMask.
  ///
  /// In zh, this message translates to:
  /// **'子网掩码'**
  String get subnetMask;

  /// No description provided for @invertedMask.
  ///
  /// In zh, this message translates to:
  /// **'反掩码'**
  String get invertedMask;

  /// No description provided for @binary.
  ///
  /// In zh, this message translates to:
  /// **'二进制'**
  String get binary;

  /// No description provided for @hexadecimal.
  ///
  /// In zh, this message translates to:
  /// **'十六进制'**
  String get hexadecimal;

  /// No description provided for @decimal.
  ///
  /// In zh, this message translates to:
  /// **'十进制'**
  String get decimal;

  /// No description provided for @complement.
  ///
  /// In zh, this message translates to:
  /// **'反码'**
  String get complement;

  /// No description provided for @result.
  ///
  /// In zh, this message translates to:
  /// **'结果'**
  String get result;

  /// No description provided for @error.
  ///
  /// In zh, this message translates to:
  /// **'错误'**
  String get error;

  /// No description provided for @invalidInput.
  ///
  /// In zh, this message translates to:
  /// **'无效的输入'**
  String get invalidInput;

  /// No description provided for @copy.
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get copy;

  /// No description provided for @cut.
  ///
  /// In zh, this message translates to:
  /// **'剪切'**
  String get cut;

  /// No description provided for @paste.
  ///
  /// In zh, this message translates to:
  /// **'粘贴'**
  String get paste;

  /// No description provided for @selectAll.
  ///
  /// In zh, this message translates to:
  /// **'全选'**
  String get selectAll;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @export.
  ///
  /// In zh, this message translates to:
  /// **'导出'**
  String get export;

  /// No description provided for @merge.
  ///
  /// In zh, this message translates to:
  /// **'合并网段'**
  String get merge;

  /// No description provided for @mergeAlgorithm.
  ///
  /// In zh, this message translates to:
  /// **'合并算法'**
  String get mergeAlgorithm;

  /// No description provided for @selectAlgorithm.
  ///
  /// In zh, this message translates to:
  /// **'选择算法'**
  String get selectAlgorithm;

  /// No description provided for @algorithmSummarizationSource.
  ///
  /// In zh, this message translates to:
  /// **'基于 Route Summarization Calculator (calcip.com)'**
  String get algorithmSummarizationSource;

  /// No description provided for @algorithmMergeSource.
  ///
  /// In zh, this message translates to:
  /// **'基于 CIDR Merger & Deduplicator (networks.tools)'**
  String get algorithmMergeSource;

  /// No description provided for @algorithmSummarization.
  ///
  /// In zh, this message translates to:
  /// **'Summarization'**
  String get algorithmSummarization;

  /// No description provided for @algorithmSummarizationDescription.
  ///
  /// In zh, this message translates to:
  /// **'最大化覆盖的汇总，找到所有网络的公共前缀'**
  String get algorithmSummarizationDescription;

  /// No description provided for @algorithmMerge.
  ///
  /// In zh, this message translates to:
  /// **'Merge'**
  String get algorithmMerge;

  /// No description provided for @algorithmMergeDescription.
  ///
  /// In zh, this message translates to:
  /// **'基于路由器性能的合并最优解，合并相邻或重叠的CIDR范围'**
  String get algorithmMergeDescription;

  /// No description provided for @split.
  ///
  /// In zh, this message translates to:
  /// **'拆分网络'**
  String get split;

  /// No description provided for @check.
  ///
  /// In zh, this message translates to:
  /// **'检测'**
  String get check;

  /// No description provided for @noHistory.
  ///
  /// In zh, this message translates to:
  /// **'暂无历史记录'**
  String get noHistory;

  /// No description provided for @deleteAll.
  ///
  /// In zh, this message translates to:
  /// **'清空全部'**
  String get deleteAll;

  /// No description provided for @exportHistory.
  ///
  /// In zh, this message translates to:
  /// **'导出历史记录'**
  String get exportHistory;

  /// No description provided for @importHistory.
  ///
  /// In zh, this message translates to:
  /// **'导入历史记录'**
  String get importHistory;

  /// No description provided for @search.
  ///
  /// In zh, this message translates to:
  /// **'搜索'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In zh, this message translates to:
  /// **'搜索计算器、输入或结果...'**
  String get searchHint;

  /// No description provided for @exportSuccess.
  ///
  /// In zh, this message translates to:
  /// **'导出成功'**
  String get exportSuccess;

  /// No description provided for @exportFailed.
  ///
  /// In zh, this message translates to:
  /// **'导出失败'**
  String get exportFailed;

  /// No description provided for @importSuccess.
  ///
  /// In zh, this message translates to:
  /// **'导入成功'**
  String get importSuccess;

  /// No description provided for @importFailed.
  ///
  /// In zh, this message translates to:
  /// **'导入失败'**
  String get importFailed;

  /// No description provided for @invalidFile.
  ///
  /// In zh, this message translates to:
  /// **'无效的文件格式'**
  String get invalidFile;

  /// No description provided for @version.
  ///
  /// In zh, this message translates to:
  /// **'版本'**
  String get version;

  /// No description provided for @developer.
  ///
  /// In zh, this message translates to:
  /// **'开发者'**
  String get developer;

  /// No description provided for @github.
  ///
  /// In zh, this message translates to:
  /// **'GitHub'**
  String get github;

  /// No description provided for @email.
  ///
  /// In zh, this message translates to:
  /// **'邮箱'**
  String get email;

  /// No description provided for @confirmDeleteAll.
  ///
  /// In zh, this message translates to:
  /// **'确定要清空所有历史记录吗？'**
  String get confirmDeleteAll;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @noResultsFound.
  ///
  /// In zh, this message translates to:
  /// **'未找到结果'**
  String get noResultsFound;

  /// No description provided for @copiedToClipboard.
  ///
  /// In zh, this message translates to:
  /// **'已复制到剪贴板'**
  String get copiedToClipboard;

  /// No description provided for @inputs.
  ///
  /// In zh, this message translates to:
  /// **'输入'**
  String get inputs;

  /// No description provided for @hosts.
  ///
  /// In zh, this message translates to:
  /// **'主机数'**
  String get hosts;

  /// No description provided for @usableHosts.
  ///
  /// In zh, this message translates to:
  /// **'可用主机数'**
  String get usableHosts;

  /// No description provided for @subnetInput.
  ///
  /// In zh, this message translates to:
  /// **'子网输入'**
  String get subnetInput;

  /// No description provided for @decimalNoDot.
  ///
  /// In zh, this message translates to:
  /// **'无点分十进制'**
  String get decimalNoDot;

  /// No description provided for @trueText.
  ///
  /// In zh, this message translates to:
  /// **'是'**
  String get trueText;

  /// No description provided for @falseText.
  ///
  /// In zh, this message translates to:
  /// **'否'**
  String get falseText;

  /// No description provided for @pleaseEnter.
  ///
  /// In zh, this message translates to:
  /// **'请输入'**
  String get pleaseEnter;

  /// No description provided for @or.
  ///
  /// In zh, this message translates to:
  /// **'或'**
  String get or;

  /// No description provided for @theme.
  ///
  /// In zh, this message translates to:
  /// **'主题'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In zh, this message translates to:
  /// **'浅色'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In zh, this message translates to:
  /// **'深色'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get system;

  /// No description provided for @pleaseEnterBothIpAndSubnet.
  ///
  /// In zh, this message translates to:
  /// **'请输入IP地址和子网掩码'**
  String get pleaseEnterBothIpAndSubnet;

  /// No description provided for @pleaseEnterHostOrSubnet.
  ///
  /// In zh, this message translates to:
  /// **'请输入主机数或子网掩码，不能同时输入'**
  String get pleaseEnterHostOrSubnet;

  /// No description provided for @hostCountMustBeAtLeast2.
  ///
  /// In zh, this message translates to:
  /// **'主机数必须至少为2'**
  String get hostCountMustBeAtLeast2;

  /// No description provided for @pleaseEnterBothCidr.
  ///
  /// In zh, this message translates to:
  /// **'请输入两个CIDR值'**
  String get pleaseEnterBothCidr;

  /// No description provided for @pleaseEnterSupernetAndMask.
  ///
  /// In zh, this message translates to:
  /// **'请输入超网和目标掩码长度'**
  String get pleaseEnterSupernetAndMask;

  /// No description provided for @targetMaskMustBeBetween1And32.
  ///
  /// In zh, this message translates to:
  /// **'目标掩码长度必须在1到32之间'**
  String get targetMaskMustBeBetween1And32;

  /// No description provided for @invalidSupernetFormat.
  ///
  /// In zh, this message translates to:
  /// **'无效的超网格式或目标掩码长度'**
  String get invalidSupernetFormat;

  /// No description provided for @errorInvalidIpAddressFormat.
  ///
  /// In zh, this message translates to:
  /// **'无效的IP地址格式'**
  String get errorInvalidIpAddressFormat;

  /// No description provided for @errorInvalidIpOrSubnetMaskFormat.
  ///
  /// In zh, this message translates to:
  /// **'无效的IP地址或子网掩码格式'**
  String get errorInvalidIpOrSubnetMaskFormat;

  /// No description provided for @errorInvalidSubnetMaskFormat.
  ///
  /// In zh, this message translates to:
  /// **'无效的子网掩码格式'**
  String get errorInvalidSubnetMaskFormat;

  /// No description provided for @errorInvalidCidrFormat.
  ///
  /// In zh, this message translates to:
  /// **'无效的CIDR格式'**
  String get errorInvalidCidrFormat;

  /// No description provided for @errorInvalidCidrRange.
  ///
  /// In zh, this message translates to:
  /// **'无效的CIDR，必须在/0到/32之间'**
  String get errorInvalidCidrRange;

  /// No description provided for @errorInvalidNetworkFormat.
  ///
  /// In zh, this message translates to:
  /// **'无效的网络格式'**
  String get errorInvalidNetworkFormat;

  /// No description provided for @errorInvalidInput.
  ///
  /// In zh, this message translates to:
  /// **'无效的输入'**
  String get errorInvalidInput;

  /// No description provided for @errorConversionFailed.
  ///
  /// In zh, this message translates to:
  /// **'转换失败'**
  String get errorConversionFailed;

  /// No description provided for @errorCheckFailed.
  ///
  /// In zh, this message translates to:
  /// **'检测失败'**
  String get errorCheckFailed;

  /// No description provided for @errorGeneral.
  ///
  /// In zh, this message translates to:
  /// **'发生错误'**
  String get errorGeneral;

  /// No description provided for @errorDecimalOutOfRange.
  ///
  /// In zh, this message translates to:
  /// **'十进制值超出范围'**
  String get errorDecimalOutOfRange;

  /// No description provided for @errorHostCountMustBeAtLeast2.
  ///
  /// In zh, this message translates to:
  /// **'主机数必须至少为2'**
  String get errorHostCountMustBeAtLeast2;

  /// No description provided for @errorNoNetworksProvided.
  ///
  /// In zh, this message translates to:
  /// **'未提供网络'**
  String get errorNoNetworksProvided;

  /// No description provided for @aboutAppDescription.
  ///
  /// In zh, this message translates to:
  /// **'这是一个功能强大的工具，帮助用户进行IP地址规划和计算。'**
  String get aboutAppDescription;

  /// No description provided for @aboutFeatures.
  ///
  /// In zh, this message translates to:
  /// **'主要功能包括：'**
  String get aboutFeatures;

  /// No description provided for @aboutFeature1.
  ///
  /// In zh, this message translates to:
  /// **'IP地址规划计算'**
  String get aboutFeature1;

  /// No description provided for @aboutFeature2.
  ///
  /// In zh, this message translates to:
  /// **'IP地址进制转换'**
  String get aboutFeature2;

  /// No description provided for @aboutFeature3.
  ///
  /// In zh, this message translates to:
  /// **'IP地址归属网段检测'**
  String get aboutFeature3;

  /// No description provided for @aboutFeature4.
  ///
  /// In zh, this message translates to:
  /// **'子网掩码与主机数换算'**
  String get aboutFeature4;

  /// No description provided for @aboutFeature5.
  ///
  /// In zh, this message translates to:
  /// **'路由聚合及超网拆分'**
  String get aboutFeature5;

  /// No description provided for @aboutFeature6.
  ///
  /// In zh, this message translates to:
  /// **'计算历史记录管理'**
  String get aboutFeature6;

  /// No description provided for @aboutDesignAdvantages.
  ///
  /// In zh, this message translates to:
  /// **'设计优点包括：'**
  String get aboutDesignAdvantages;

  /// No description provided for @aboutDesignAdvantage1.
  ///
  /// In zh, this message translates to:
  /// **'简洁直观的用户界面'**
  String get aboutDesignAdvantage1;

  /// No description provided for @aboutDesignAdvantage2.
  ///
  /// In zh, this message translates to:
  /// **'多语言国际化支持'**
  String get aboutDesignAdvantage2;

  /// No description provided for @aboutDesignAdvantage3.
  ///
  /// In zh, this message translates to:
  /// **'深色/浅色主题切换'**
  String get aboutDesignAdvantage3;

  /// No description provided for @aboutDesignAdvantage4.
  ///
  /// In zh, this message translates to:
  /// **'响应式布局设计'**
  String get aboutDesignAdvantage4;

  /// No description provided for @aboutDesignAdvantage5.
  ///
  /// In zh, this message translates to:
  /// **'快速高效的计算性能'**
  String get aboutDesignAdvantage5;

  /// No description provided for @aboutTargetUsers.
  ///
  /// In zh, this message translates to:
  /// **'该工具适合网络工程师、开发者和学习者。'**
  String get aboutTargetUsers;

  /// No description provided for @aboutVersionInfo.
  ///
  /// In zh, this message translates to:
  /// **'当前版本已优化用户界面并修复了一些问题。'**
  String get aboutVersionInfo;

  /// No description provided for @author.
  ///
  /// In zh, this message translates to:
  /// **'作者'**
  String get author;

  /// No description provided for @bluesky.
  ///
  /// In zh, this message translates to:
  /// **'Bluesky'**
  String get bluesky;

  /// No description provided for @colorTheme.
  ///
  /// In zh, this message translates to:
  /// **'颜色'**
  String get colorTheme;

  /// No description provided for @presetThemes.
  ///
  /// In zh, this message translates to:
  /// **'预设颜色'**
  String get presetThemes;

  /// No description provided for @customThemes.
  ///
  /// In zh, this message translates to:
  /// **'自定义主题'**
  String get customThemes;

  /// No description provided for @createCustomTheme.
  ///
  /// In zh, this message translates to:
  /// **'创建自定义主题'**
  String get createCustomTheme;

  /// No description provided for @themeName.
  ///
  /// In zh, this message translates to:
  /// **'主题名称'**
  String get themeName;

  /// No description provided for @selectColor.
  ///
  /// In zh, this message translates to:
  /// **'选择颜色'**
  String get selectColor;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @reset.
  ///
  /// In zh, this message translates to:
  /// **'重置'**
  String get reset;

  /// No description provided for @resetToDefault.
  ///
  /// In zh, this message translates to:
  /// **'重置为默认'**
  String get resetToDefault;

  /// No description provided for @resetToDefaultConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定要重置为默认主题吗？这将删除所有自定义主题。'**
  String get resetToDefaultConfirm;

  /// No description provided for @deleteTheme.
  ///
  /// In zh, this message translates to:
  /// **'删除主题'**
  String get deleteTheme;

  /// No description provided for @deleteThemeConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除主题 \"{themeName}\" 吗？'**
  String deleteThemeConfirm(String themeName);

  /// No description provided for @neteaseRed.
  ///
  /// In zh, this message translates to:
  /// **'网易云·红'**
  String get neteaseRed;

  /// No description provided for @facebookBlue.
  ///
  /// In zh, this message translates to:
  /// **'Facebook 蓝'**
  String get facebookBlue;

  /// No description provided for @spotifyGreen.
  ///
  /// In zh, this message translates to:
  /// **'Spotify 绿'**
  String get spotifyGreen;

  /// No description provided for @qqMusicYellow.
  ///
  /// In zh, this message translates to:
  /// **'QQ音乐·黄'**
  String get qqMusicYellow;

  /// No description provided for @bilibiliPink.
  ///
  /// In zh, this message translates to:
  /// **'BiliBili·粉红'**
  String get bilibiliPink;

  /// No description provided for @calculatorSortOrder.
  ///
  /// In zh, this message translates to:
  /// **'计算器排序'**
  String get calculatorSortOrder;

  /// No description provided for @calculatorSortOrderDescription.
  ///
  /// In zh, this message translates to:
  /// **'拖拽调整计算器顺序'**
  String get calculatorSortOrderDescription;

  /// No description provided for @sidebarSortOrder.
  ///
  /// In zh, this message translates to:
  /// **'侧边栏排序'**
  String get sidebarSortOrder;

  /// No description provided for @sidebarSortOrderDescription.
  ///
  /// In zh, this message translates to:
  /// **'拖拽调整侧边栏项目顺序'**
  String get sidebarSortOrderDescription;

  /// No description provided for @resetSortOrder.
  ///
  /// In zh, this message translates to:
  /// **'重置排序'**
  String get resetSortOrder;

  /// No description provided for @resetSortOrderConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定要重置为默认排序吗？'**
  String get resetSortOrderConfirm;

  /// No description provided for @resetSidebarSortOrder.
  ///
  /// In zh, this message translates to:
  /// **'重置侧边栏排序'**
  String get resetSidebarSortOrder;

  /// No description provided for @resetSidebarSortOrderConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定要重置为默认侧边栏排序吗？'**
  String get resetSidebarSortOrderConfirm;

  /// No description provided for @lockItem.
  ///
  /// In zh, this message translates to:
  /// **'锁定项目'**
  String get lockItem;

  /// No description provided for @unlockItem.
  ///
  /// In zh, this message translates to:
  /// **'解锁项目'**
  String get unlockItem;

  /// No description provided for @sidebarDragEnabled.
  ///
  /// In zh, this message translates to:
  /// **'启用侧边栏拖拽排序'**
  String get sidebarDragEnabled;

  /// No description provided for @sidebarDragEnabledDescription.
  ///
  /// In zh, this message translates to:
  /// **'开启后可在侧边栏长按拖拽项目进行排序'**
  String get sidebarDragEnabledDescription;

  /// No description provided for @historyLimit.
  ///
  /// In zh, this message translates to:
  /// **'历史记录数量限制'**
  String get historyLimit;

  /// No description provided for @historyLimitDescription.
  ///
  /// In zh, this message translates to:
  /// **'设置最多保存的历史记录条数'**
  String get historyLimitDescription;

  /// No description provided for @historyLimitHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入数量（10-100000）'**
  String get historyLimitHint;

  /// No description provided for @dataStoragePath.
  ///
  /// In zh, this message translates to:
  /// **'数据记录读写目录'**
  String get dataStoragePath;

  /// No description provided for @dataStoragePathDefault.
  ///
  /// In zh, this message translates to:
  /// **'默认：应用数据目录'**
  String get dataStoragePathDefault;

  /// No description provided for @dataStoragePathDefaultPath.
  ///
  /// In zh, this message translates to:
  /// **'默认读写位置'**
  String get dataStoragePathDefaultPath;

  /// No description provided for @dataStoragePathCustom.
  ///
  /// In zh, this message translates to:
  /// **'自定义读写位置'**
  String get dataStoragePathCustom;

  /// No description provided for @dataStoragePathSet.
  ///
  /// In zh, this message translates to:
  /// **'数据记录读写目录已设置为'**
  String get dataStoragePathSet;

  /// No description provided for @dataStoragePathReset.
  ///
  /// In zh, this message translates to:
  /// **'已重置为默认读写位置'**
  String get dataStoragePathReset;

  /// No description provided for @historyDetailSettings.
  ///
  /// In zh, this message translates to:
  /// **'历史记录详细设置'**
  String get historyDetailSettings;

  /// No description provided for @historyDetailSettingsDescription.
  ///
  /// In zh, this message translates to:
  /// **'历史记录的详细配置选项'**
  String get historyDetailSettingsDescription;

  /// No description provided for @currentLimit.
  ///
  /// In zh, this message translates to:
  /// **'当前限制'**
  String get currentLimit;

  /// No description provided for @entries.
  ///
  /// In zh, this message translates to:
  /// **'条'**
  String get entries;

  /// No description provided for @appSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'专业的网络计算工具集'**
  String get appSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In zh, this message translates to:
  /// **'开始使用'**
  String get getStarted;

  /// No description provided for @cannotOpenLink.
  ///
  /// In zh, this message translates to:
  /// **'无法打开链接'**
  String get cannotOpenLink;

  /// No description provided for @clearCalculatorStates.
  ///
  /// In zh, this message translates to:
  /// **'清除计算器状态'**
  String get clearCalculatorStates;

  /// No description provided for @confirmClearCalculatorStates.
  ///
  /// In zh, this message translates to:
  /// **'确定要清除所有计算器的输入和结果吗？'**
  String get confirmClearCalculatorStates;

  /// No description provided for @calculatorStatesCleared.
  ///
  /// In zh, this message translates to:
  /// **'已清除所有计算器的输入和结果'**
  String get calculatorStatesCleared;

  /// No description provided for @references.
  ///
  /// In zh, this message translates to:
  /// **'参考资料'**
  String get references;

  /// No description provided for @referenceBasicTools.
  ///
  /// In zh, this message translates to:
  /// **'基础 IP 与子网工具'**
  String get referenceBasicTools;

  /// No description provided for @referenceIpAddressCalc.
  ///
  /// In zh, this message translates to:
  /// **'IP地址计算与进制转换'**
  String get referenceIpAddressCalc;

  /// No description provided for @referenceIpAddressCalcDesc.
  ///
  /// In zh, this message translates to:
  /// **'适用场景：基础 IP 地址换算、进制转换、网段划分。'**
  String get referenceIpAddressCalcDesc;

  /// No description provided for @referenceIpCalculator.
  ///
  /// In zh, this message translates to:
  /// **'IP计算器'**
  String get referenceIpCalculator;

  /// No description provided for @referenceSubnetCidr.
  ///
  /// In zh, this message translates to:
  /// **'子网与 CIDR 工具'**
  String get referenceSubnetCidr;

  /// No description provided for @referenceSubnetCidrDesc.
  ///
  /// In zh, this message translates to:
  /// **'适用场景：可视化子网划分、CIDR 地址块展示。'**
  String get referenceSubnetCidrDesc;

  /// No description provided for @referenceRouteAggregation.
  ///
  /// In zh, this message translates to:
  /// **'路由聚合与超网拆分'**
  String get referenceRouteAggregation;

  /// No description provided for @referenceSupernetSplit.
  ///
  /// In zh, this message translates to:
  /// **'超网拆分'**
  String get referenceSupernetSplit;

  /// No description provided for @referenceSupernetSplitDesc.
  ///
  /// In zh, this message translates to:
  /// **'适用场景：将大地址块拆分为多个小网段。'**
  String get referenceSupernetSplitDesc;

  /// No description provided for @referenceRouteAggregationTitle.
  ///
  /// In zh, this message translates to:
  /// **'路由聚合'**
  String get referenceRouteAggregationTitle;

  /// No description provided for @referenceRouteAggregationDesc.
  ///
  /// In zh, this message translates to:
  /// **'适用场景：合并多个子网为一个 CIDR，优化路由表。'**
  String get referenceRouteAggregationDesc;

  /// No description provided for @referenceLearningResources.
  ///
  /// In zh, this message translates to:
  /// **'学习与速查资源'**
  String get referenceLearningResources;

  /// No description provided for @referenceTechBlogs.
  ///
  /// In zh, this message translates to:
  /// **'技术博客参考'**
  String get referenceTechBlogs;

  /// No description provided for @referenceSubnetRouteBlog.
  ///
  /// In zh, this message translates to:
  /// **'子网划分与路由聚合详解'**
  String get referenceSubnetRouteBlog;

  /// No description provided for @referenceCheatSheets.
  ///
  /// In zh, this message translates to:
  /// **'网络速查表'**
  String get referenceCheatSheets;

  /// No description provided for @advanced.
  ///
  /// In zh, this message translates to:
  /// **'高级'**
  String get advanced;

  /// No description provided for @advancedSettings.
  ///
  /// In zh, this message translates to:
  /// **'高级设置'**
  String get advancedSettings;

  /// No description provided for @webPlatformNotSupported.
  ///
  /// In zh, this message translates to:
  /// **'Web 平台不支持自定义目录选择'**
  String get webPlatformNotSupported;

  /// No description provided for @webPlatformStorageInfo.
  ///
  /// In zh, this message translates to:
  /// **'Web 平台不支持自定义目录选择，将使用浏览器默认存储位置'**
  String get webPlatformStorageInfo;

  /// No description provided for @windowSize.
  ///
  /// In zh, this message translates to:
  /// **'窗口尺寸'**
  String get windowSize;

  /// No description provided for @windowSizeDescription.
  ///
  /// In zh, this message translates to:
  /// **'设置软件窗口的宽度和高度'**
  String get windowSizeDescription;

  /// No description provided for @windowWidth.
  ///
  /// In zh, this message translates to:
  /// **'窗口宽度'**
  String get windowWidth;

  /// No description provided for @windowHeight.
  ///
  /// In zh, this message translates to:
  /// **'窗口高度'**
  String get windowHeight;

  /// No description provided for @windowSizeHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入尺寸（最小：800x700）'**
  String get windowSizeHint;

  /// No description provided for @windowSizeSaved.
  ///
  /// In zh, this message translates to:
  /// **'窗口尺寸已保存，重启应用后生效'**
  String get windowSizeSaved;

  /// No description provided for @minWindowSize.
  ///
  /// In zh, this message translates to:
  /// **'最小窗口尺寸：800x700'**
  String get minWindowSize;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'HK':
            return AppLocalizationsZhHk();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
