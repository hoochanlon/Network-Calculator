// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Network Calculator';

  @override
  String get ipCalculator => 'IP Calculator';

  @override
  String get subnetCalculator => 'Subnet Calculator';

  @override
  String get baseConverter => 'Base Converter';

  @override
  String get networkMerge => 'Network Merge';

  @override
  String get networkSplit => 'Network Split';

  @override
  String get ipInclusionChecker => 'IP Inclusion Checker';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get language => 'Language';

  @override
  String get chinese => '中文';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get followSystem => 'Follow System';

  @override
  String get preserveInputs => 'Preserve Inputs and Results';

  @override
  String get preserveInputsDescription =>
      'Keep input content and calculation results when switching calculators';

  @override
  String get calculate => 'Calculate';

  @override
  String get clear => 'Clear';

  @override
  String get inputIpAddress => 'Enter IP Address';

  @override
  String get inputSubnetMask => 'Enter Subnet Mask';

  @override
  String get inputHosts => 'Enter Host Count';

  @override
  String get inputSubnetOrCidr => 'Enter Subnet Mask or CIDR';

  @override
  String get inputBaseValue => 'Enter IP Address or Value';

  @override
  String get inputNetworks =>
      'Enter networks in CIDR format, separated by newlines';

  @override
  String get inputSupernet => 'Enter supernet to split (CIDR format)';

  @override
  String get inputTargetMask => 'Enter target subnet mask length (1~32)';

  @override
  String get inputCheckCidr => 'Enter CIDR or IP to verify';

  @override
  String get inputTargetCidr => 'Enter target CIDR network';

  @override
  String get ipAddress => 'IP Address';

  @override
  String get networkAddress => 'Network Address';

  @override
  String get broadcastAddress => 'Broadcast Address';

  @override
  String get usableIps => 'Usable IPs';

  @override
  String get firstUsableIp => 'First Usable IP';

  @override
  String get lastUsableIp => 'Last Usable IP';

  @override
  String get networkClass => 'Network Class';

  @override
  String get cidr => 'CIDR';

  @override
  String get subnetMask => 'Subnet Mask';

  @override
  String get invertedMask => 'Inverted Mask';

  @override
  String get binary => 'Binary';

  @override
  String get hexadecimal => 'Hexadecimal';

  @override
  String get decimal => 'Decimal';

  @override
  String get complement => 'Complement';

  @override
  String get result => 'Result';

  @override
  String get error => 'Error';

  @override
  String get invalidInput => 'Invalid Input';

  @override
  String get copy => 'Copy';

  @override
  String get delete => 'Delete';

  @override
  String get export => 'Export';

  @override
  String get merge => 'Merge Networks';

  @override
  String get mergeAlgorithm => 'Merge Algorithm';

  @override
  String get selectAlgorithm => 'Select Algorithm';

  @override
  String get algorithmSummarizationSource =>
      'Based on Route Summarization Calculator (calcip.com)';

  @override
  String get algorithmMergeSource =>
      'Based on CIDR Merger & Deduplicator (networks.tools)';

  @override
  String get algorithmSummarization => 'Summarization';

  @override
  String get algorithmSummarizationDescription =>
      'Maximize coverage summary, find common prefix of all networks';

  @override
  String get algorithmMerge => 'Merge';

  @override
  String get algorithmMergeDescription =>
      'Optimal merge solution based on router performance, merge adjacent or overlapping CIDR ranges';

  @override
  String get split => 'Split Network';

  @override
  String get check => 'Check';

  @override
  String get noHistory => 'No History';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get exportHistory => 'Export History';

  @override
  String get importHistory => 'Import History';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search calculator, input or result...';

  @override
  String get exportSuccess => 'Export successful';

  @override
  String get exportFailed => 'Export failed';

  @override
  String get importSuccess => 'Import successful';

  @override
  String get importFailed => 'Import failed';

  @override
  String get invalidFile => 'Invalid file format';

  @override
  String get version => 'Version';

  @override
  String get developer => 'Developer';

  @override
  String get github => 'GitHub';

  @override
  String get email => 'Email';

  @override
  String get confirmDeleteAll => 'Are you sure you want to delete all history?';

  @override
  String get cancel => 'Cancel';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get inputs => 'Inputs';

  @override
  String get hosts => 'Hosts';

  @override
  String get usableHosts => 'Usable Hosts';

  @override
  String get subnetInput => 'Subnet Input';

  @override
  String get decimalNoDot => 'Decimal (no dot)';

  @override
  String get trueText => 'True';

  @override
  String get falseText => 'False';

  @override
  String get pleaseEnter => 'Please enter';

  @override
  String get or => 'or';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get pleaseEnterBothIpAndSubnet =>
      'Please enter both IP address and subnet mask';

  @override
  String get pleaseEnterHostOrSubnet =>
      'Please enter either host count or subnet mask, not both';

  @override
  String get hostCountMustBeAtLeast2 => 'Host count must be at least 2';

  @override
  String get pleaseEnterBothCidr => 'Please enter both CIDR values';

  @override
  String get pleaseEnterSupernetAndMask =>
      'Please enter both supernet and target mask length';

  @override
  String get targetMaskMustBeBetween1And32 =>
      'Target mask length must be between 1 and 32';

  @override
  String get invalidSupernetFormat =>
      'Invalid supernet format or target mask length';

  @override
  String get errorInvalidIpAddressFormat => 'Invalid IP address format';

  @override
  String get errorInvalidIpOrSubnetMaskFormat =>
      'Invalid IP or subnet mask format';

  @override
  String get errorInvalidSubnetMaskFormat => 'Invalid subnet mask format';

  @override
  String get errorInvalidCidrFormat => 'Invalid CIDR format';

  @override
  String get errorInvalidCidrRange =>
      'Invalid CIDR, must be between /0 and /32';

  @override
  String get errorInvalidNetworkFormat => 'Invalid network format';

  @override
  String get errorInvalidInput => 'Invalid input';

  @override
  String get errorConversionFailed => 'Conversion failed';

  @override
  String get errorCheckFailed => 'Check failed';

  @override
  String get errorGeneral => 'An error occurred';

  @override
  String get errorDecimalOutOfRange => 'Decimal value out of range';

  @override
  String get errorHostCountMustBeAtLeast2 => 'Host count must be at least 2';

  @override
  String get errorNoNetworksProvided => 'No networks provided';

  @override
  String get aboutAppDescription =>
      'This is a powerful tool to help users plan and calculate IP addresses.';

  @override
  String get aboutFeatures => 'Main features include:';

  @override
  String get aboutFeature1 => '• IP address planning and calculation';

  @override
  String get aboutFeature2 => '• IP address base conversion';

  @override
  String get aboutFeature3 => '• IP address network segment detection';

  @override
  String get aboutFeature4 => '• Subnet mask and host count conversion';

  @override
  String get aboutFeature5 => '• Route aggregation and supernet splitting';

  @override
  String get aboutFeature6 => '• Calculation history management';

  @override
  String get aboutTargetUsers =>
      'This tool is suitable for network engineers, developers and learners.';

  @override
  String get aboutVersionInfo =>
      'The current version has optimized the user interface and fixed some issues.';

  @override
  String get author => 'Author';

  @override
  String get bluesky => 'Bluesky';

  @override
  String get colorTheme => 'Color';

  @override
  String get presetThemes => 'Preset Colors';

  @override
  String get customThemes => 'Custom Themes';

  @override
  String get createCustomTheme => 'Create Custom Theme';

  @override
  String get themeName => 'Theme Name';

  @override
  String get selectColor => 'Select Color';

  @override
  String get save => 'Save';

  @override
  String get reset => 'Reset';

  @override
  String get resetToDefault => 'Reset to Default';

  @override
  String get resetToDefaultConfirm =>
      'Are you sure you want to reset to the default theme? This will delete all custom themes.';

  @override
  String get deleteTheme => 'Delete Theme';

  @override
  String deleteThemeConfirm(String themeName) {
    return 'Are you sure you want to delete theme \"$themeName\"?';
  }

  @override
  String get neteaseRed => 'Netease Red';

  @override
  String get facebookBlue => 'Facebook Blue';

  @override
  String get spotifyGreen => 'Spotify Green';

  @override
  String get qqMusicYellow => 'QQ Music Yellow';

  @override
  String get bilibiliPink => 'BiliBili Pink';

  @override
  String get calculatorSortOrder => 'Calculator Sort Order';

  @override
  String get calculatorSortOrderDescription =>
      'Drag to adjust calculator order';

  @override
  String get sidebarSortOrder => 'Sidebar Sort Order';

  @override
  String get sidebarSortOrderDescription => 'Drag to adjust sidebar item order';

  @override
  String get resetSortOrder => 'Reset Order';

  @override
  String get resetSortOrderConfirm =>
      'Are you sure you want to reset to default order?';

  @override
  String get resetSidebarSortOrder => 'Reset Sidebar Order';

  @override
  String get resetSidebarSortOrderConfirm =>
      'Are you sure you want to reset to default sidebar order?';

  @override
  String get lockItem => 'Lock Item';

  @override
  String get unlockItem => 'Unlock Item';

  @override
  String get sidebarDragEnabled => 'Enable Sidebar Drag Sort';

  @override
  String get sidebarDragEnabledDescription =>
      'Long press and drag items in the sidebar to reorder when enabled';

  @override
  String get historyLimit => 'History Limit';

  @override
  String get historyLimitDescription =>
      'Set the maximum number of history records to keep';

  @override
  String get historyLimitHint => 'Enter a number (10-100000)';

  @override
  String get dataStoragePath => 'Data Storage Directory';

  @override
  String get dataStoragePathDefault => 'Default: Application data directory';

  @override
  String get dataStoragePathDefaultPath => 'Default read/write location';

  @override
  String get dataStoragePathCustom => 'Custom read/write location';

  @override
  String get dataStoragePathSet => 'Data storage directory set to';

  @override
  String get dataStoragePathReset => 'Reset to default read/write location';

  @override
  String get historyDetailSettings => 'History Detail Settings';

  @override
  String get historyDetailSettingsDescription =>
      'Detailed configuration options for history records';

  @override
  String get currentLimit => 'Current limit';

  @override
  String get entries => 'entries';

  @override
  String get appSubtitle => 'Professional Network Calculator Toolset';

  @override
  String get getStarted => 'Get Started';

  @override
  String get cannotOpenLink => 'Cannot open link';

  @override
  String get clearCalculatorStates => 'Clear Calculator States';

  @override
  String get confirmClearCalculatorStates =>
      'Are you sure you want to clear all calculator inputs and results?';

  @override
  String get calculatorStatesCleared =>
      'All calculator inputs and results have been cleared';

  @override
  String get references => 'References';

  @override
  String get referenceBasicTools => 'Basic IP and Subnet Tools';

  @override
  String get referenceIpAddressCalc =>
      'IP Address Calculation and Base Conversion';

  @override
  String get referenceIpAddressCalcDesc =>
      'Use cases: Basic IP address conversion, base conversion, network segment division.';

  @override
  String get referenceIpCalculator => 'IP Calculator';

  @override
  String get referenceSubnetCidr => 'Subnet and CIDR Tools';

  @override
  String get referenceSubnetCidrDesc =>
      'Use cases: Visual subnet division, CIDR address block display.';

  @override
  String get referenceRouteAggregation =>
      'Route Aggregation and Supernet Splitting';

  @override
  String get referenceSupernetSplit => 'Supernet Splitting';

  @override
  String get referenceSupernetSplitDesc =>
      'Use cases: Split large address blocks into multiple small network segments.';

  @override
  String get referenceRouteAggregationTitle => 'Route Aggregation';

  @override
  String get referenceRouteAggregationDesc =>
      'Use cases: Merge multiple subnets into one CIDR, optimize routing tables.';

  @override
  String get referenceLearningResources => 'Learning and Reference Resources';

  @override
  String get referenceTechBlogs => 'Technical Blog References';

  @override
  String get referenceSubnetRouteBlog =>
      'Subnet Division and Route Aggregation Explained';

  @override
  String get referenceCheatSheets => 'Network Cheat Sheets';

  @override
  String get advanced => 'Advanced';

  @override
  String get advancedSettings => 'Advanced Settings';

  @override
  String get webPlatformNotSupported =>
      'Custom directory selection is not supported on Web platform';

  @override
  String get webPlatformStorageInfo =>
      'Custom directory selection is not supported on Web platform, browser default storage will be used';
}
