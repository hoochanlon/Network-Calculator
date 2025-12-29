// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '网络计算器';

  @override
  String get ipCalculator => 'IP地址计算器';

  @override
  String get subnetCalculator => '子网掩码计算器';

  @override
  String get baseConverter => 'IP进制转换器';

  @override
  String get networkMerge => '路由聚合计算器';

  @override
  String get networkSplit => '超网拆分计算器';

  @override
  String get ipInclusionChecker => 'IP包含检测器';

  @override
  String get history => '历史记录';

  @override
  String get settings => '设置';

  @override
  String get about => '关于';

  @override
  String get language => '语言';

  @override
  String get chinese => '中文';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get followSystem => '跟随系统';

  @override
  String get preserveInputs => '保留输入和结果';

  @override
  String get preserveInputsDescription => '切换计算器时保留输入内容和计算结果';

  @override
  String get calculate => '计算';

  @override
  String get clear => '清空';

  @override
  String get inputIpAddress => '请输入IP地址';

  @override
  String get inputSubnetMask => '请输入子网掩码';

  @override
  String get inputHosts => '请输入主机数';

  @override
  String get inputSubnetOrCidr => '请输入子网掩码或CIDR';

  @override
  String get inputBaseValue => '请输入IP地址或数值';

  @override
  String get inputNetworks => '请输入CIDR格式的网段，以换行做分隔';

  @override
  String get inputSupernet => '请输入需拆分的超网（CIDR格式）';

  @override
  String get inputTargetMask => '请输入目标子网掩码长度（1~32）';

  @override
  String get inputCheckCidr => '请输入需要验证的CIDR或IP';

  @override
  String get inputTargetCidr => '请输入目标CIDR网段';

  @override
  String get ipAddress => 'IP地址';

  @override
  String get networkAddress => '网络地址';

  @override
  String get broadcastAddress => '广播地址';

  @override
  String get usableIps => '可用IP数量';

  @override
  String get firstUsableIp => '第一可用IP';

  @override
  String get lastUsableIp => '最后可用IP';

  @override
  String get networkClass => '网络类别';

  @override
  String get cidr => 'CIDR';

  @override
  String get subnetMask => '子网掩码';

  @override
  String get invertedMask => '反掩码';

  @override
  String get binary => '二进制';

  @override
  String get hexadecimal => '十六进制';

  @override
  String get decimal => '十进制';

  @override
  String get complement => '反码';

  @override
  String get result => '结果';

  @override
  String get error => '错误';

  @override
  String get invalidInput => '无效的输入';

  @override
  String get copy => '复制';

  @override
  String get delete => '删除';

  @override
  String get export => '导出';

  @override
  String get merge => '合并网段';

  @override
  String get mergeAlgorithm => '合并算法';

  @override
  String get selectAlgorithm => '选择算法';

  @override
  String get algorithmSummarizationSource =>
      '基于 Route Summarization Calculator (calcip.com)';

  @override
  String get algorithmMergeSource =>
      '基于 CIDR Merger & Deduplicator (networks.tools)';

  @override
  String get algorithmSummarization => 'Summarization';

  @override
  String get algorithmSummarizationDescription => '最大化覆盖的汇总，找到所有网络的公共前缀';

  @override
  String get algorithmMerge => 'Merge';

  @override
  String get algorithmMergeDescription => '基于路由器性能的合并最优解，合并相邻或重叠的CIDR范围';

  @override
  String get split => '拆分网络';

  @override
  String get check => '检测';

  @override
  String get noHistory => '暂无历史记录';

  @override
  String get deleteAll => '清空全部';

  @override
  String get exportHistory => '导出历史记录';

  @override
  String get importHistory => '导入历史记录';

  @override
  String get search => '搜索';

  @override
  String get searchHint => '搜索计算器、输入或结果...';

  @override
  String get exportSuccess => '导出成功';

  @override
  String get exportFailed => '导出失败';

  @override
  String get importSuccess => '导入成功';

  @override
  String get importFailed => '导入失败';

  @override
  String get invalidFile => '无效的文件格式';

  @override
  String get version => '版本';

  @override
  String get developer => '开发者';

  @override
  String get github => 'GitHub';

  @override
  String get email => '邮箱';

  @override
  String get confirmDeleteAll => '确定要清空所有历史记录吗？';

  @override
  String get cancel => '取消';

  @override
  String get noResultsFound => '未找到结果';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get inputs => '输入';

  @override
  String get hosts => '主机数';

  @override
  String get usableHosts => '可用主机数';

  @override
  String get subnetInput => '子网输入';

  @override
  String get decimalNoDot => '无点分十进制';

  @override
  String get trueText => '是';

  @override
  String get falseText => '否';

  @override
  String get pleaseEnter => '请输入';

  @override
  String get or => '或';

  @override
  String get theme => '主题';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get system => '跟随系统';

  @override
  String get pleaseEnterBothIpAndSubnet => '请输入IP地址和子网掩码';

  @override
  String get pleaseEnterHostOrSubnet => '请输入主机数或子网掩码，不能同时输入';

  @override
  String get hostCountMustBeAtLeast2 => '主机数必须至少为2';

  @override
  String get pleaseEnterBothCidr => '请输入两个CIDR值';

  @override
  String get pleaseEnterSupernetAndMask => '请输入超网和目标掩码长度';

  @override
  String get targetMaskMustBeBetween1And32 => '目标掩码长度必须在1到32之间';

  @override
  String get invalidSupernetFormat => '无效的超网格式或目标掩码长度';

  @override
  String get errorInvalidIpAddressFormat => '无效的IP地址格式';

  @override
  String get errorInvalidIpOrSubnetMaskFormat => '无效的IP地址或子网掩码格式';

  @override
  String get errorInvalidSubnetMaskFormat => '无效的子网掩码格式';

  @override
  String get errorInvalidCidrFormat => '无效的CIDR格式';

  @override
  String get errorInvalidCidrRange => '无效的CIDR，必须在/0到/32之间';

  @override
  String get errorInvalidNetworkFormat => '无效的网络格式';

  @override
  String get errorInvalidInput => '无效的输入';

  @override
  String get errorConversionFailed => '转换失败';

  @override
  String get errorCheckFailed => '检测失败';

  @override
  String get errorGeneral => '发生错误';

  @override
  String get errorDecimalOutOfRange => '十进制值超出范围';

  @override
  String get errorHostCountMustBeAtLeast2 => '主机数必须至少为2';

  @override
  String get errorNoNetworksProvided => '未提供网络';

  @override
  String get aboutAppDescription => '这是一个功能强大的工具，帮助用户进行IP地址规划和计算。';

  @override
  String get aboutFeatures => '主要功能包括：';

  @override
  String get aboutFeature1 => '• IP地址规划计算';

  @override
  String get aboutFeature2 => '• IP地址进制转换';

  @override
  String get aboutFeature3 => '• IP地址归属网段检测';

  @override
  String get aboutFeature4 => '• 子网掩码与主机数换算';

  @override
  String get aboutFeature5 => '• 路由聚合及超网拆分';

  @override
  String get aboutFeature6 => '• 计算历史记录管理';

  @override
  String get aboutTargetUsers => '该工具适合网络工程师、开发者和学习者。';

  @override
  String get aboutVersionInfo => '当前版本已优化用户界面并修复了一些问题。';

  @override
  String get author => '作者';

  @override
  String get bluesky => 'Bluesky';

  @override
  String get colorTheme => '颜色';

  @override
  String get presetThemes => '预设颜色';

  @override
  String get customThemes => '自定义主题';

  @override
  String get createCustomTheme => '创建自定义主题';

  @override
  String get themeName => '主题名称';

  @override
  String get selectColor => '选择颜色';

  @override
  String get save => '保存';

  @override
  String get reset => '重置';

  @override
  String get resetToDefault => '重置为默认';

  @override
  String get resetToDefaultConfirm => '确定要重置为默认主题吗？这将删除所有自定义主题。';

  @override
  String get deleteTheme => '删除主题';

  @override
  String deleteThemeConfirm(String themeName) {
    return '确定要删除主题 \"$themeName\" 吗？';
  }

  @override
  String get neteaseRed => '网易云·红';

  @override
  String get facebookBlue => 'Facebook 蓝';

  @override
  String get spotifyGreen => 'Spotify 绿';

  @override
  String get qqMusicYellow => 'QQ音乐·黄';

  @override
  String get bilibiliPink => 'BiliBili·粉红';

  @override
  String get calculatorSortOrder => '计算器排序';

  @override
  String get calculatorSortOrderDescription => '拖拽调整计算器顺序';

  @override
  String get resetSortOrder => '重置排序';

  @override
  String get resetSortOrderConfirm => '确定要重置为默认排序吗？';

  @override
  String get historyLimit => '历史记录数量限制';

  @override
  String get historyLimitDescription => '设置最多保存的历史记录条数';

  @override
  String get historyLimitHint => '请输入数量（10-100000）';

  @override
  String get dataStoragePath => '数据记录读写目录';

  @override
  String get dataStoragePathDefault => '默认：应用数据目录';

  @override
  String get dataStoragePathDefaultPath => '默认读写位置';

  @override
  String get dataStoragePathCustom => '自定义读写位置';

  @override
  String get dataStoragePathSet => '数据记录读写目录已设置为';

  @override
  String get dataStoragePathReset => '已重置为默认读写位置';

  @override
  String get historyDetailSettings => '历史记录详细设置';

  @override
  String get historyDetailSettingsDescription => '历史记录的详细配置选项';

  @override
  String get currentLimit => '当前限制';

  @override
  String get entries => '条';

  @override
  String get appSubtitle => '专业的网络计算工具集';

  @override
  String get getStarted => '开始使用';

  @override
  String get cannotOpenLink => '无法打开链接';

  @override
  String get clearCalculatorStates => '清除计算器状态';

  @override
  String get confirmClearCalculatorStates => '确定要清除所有计算器的输入和结果吗？';

  @override
  String get calculatorStatesCleared => '已清除所有计算器的输入和结果';

  @override
  String get references => '参考资料';

  @override
  String get referenceBasicTools => '基础 IP 与子网工具';

  @override
  String get referenceIpAddressCalc => 'IP地址计算与进制转换';

  @override
  String get referenceIpAddressCalcDesc => '适用场景：基础 IP 地址换算、进制转换、网段划分。';

  @override
  String get referenceIpCalculator => 'IP计算器';

  @override
  String get referenceSubnetCidr => '子网与 CIDR 工具';

  @override
  String get referenceSubnetCidrDesc => '适用场景：可视化子网划分、CIDR 地址块展示。';

  @override
  String get referenceRouteAggregation => '路由聚合与超网拆分';

  @override
  String get referenceSupernetSplit => '超网拆分';

  @override
  String get referenceSupernetSplitDesc => '适用场景：将大地址块拆分为多个小网段。';

  @override
  String get referenceRouteAggregationTitle => '路由聚合';

  @override
  String get referenceRouteAggregationDesc => '适用场景：合并多个子网为一个 CIDR，优化路由表。';

  @override
  String get referenceLearningResources => '学习与速查资源';

  @override
  String get referenceTechBlogs => '技术博客参考';

  @override
  String get referenceSubnetRouteBlog => '子网划分与路由聚合详解';

  @override
  String get referenceCheatSheets => '网络速查表';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => '網路計算器';

  @override
  String get ipCalculator => 'IP位址計算器';

  @override
  String get subnetCalculator => '子網路遮罩計算器';

  @override
  String get baseConverter => 'IP進制轉換器';

  @override
  String get networkMerge => '路由聚合計算器';

  @override
  String get networkSplit => '超網拆分計算器';

  @override
  String get ipInclusionChecker => 'IP包含檢測器';

  @override
  String get history => '歷史記錄';

  @override
  String get settings => '設定';

  @override
  String get about => '關於';

  @override
  String get language => '語言';

  @override
  String get chinese => '中文';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get followSystem => '跟隨系統';

  @override
  String get preserveInputs => '保留輸入和結果';

  @override
  String get preserveInputsDescription => '切換計算器時保留輸入內容和計算結果';

  @override
  String get calculate => '計算';

  @override
  String get clear => '清空';

  @override
  String get inputIpAddress => '請輸入IP位址';

  @override
  String get inputSubnetMask => '請輸入子網路遮罩';

  @override
  String get inputHosts => '請輸入主機數';

  @override
  String get inputSubnetOrCidr => '請輸入子網路遮罩或CIDR';

  @override
  String get inputBaseValue => '請輸入IP位址或數值';

  @override
  String get inputNetworks => '請輸入CIDR格式的網段，以換行做分隔';

  @override
  String get inputSupernet => '請輸入需拆分的超網（CIDR格式）';

  @override
  String get inputTargetMask => '請輸入目標子網路遮罩長度（1~32）';

  @override
  String get inputCheckCidr => '請輸入需要驗證的CIDR或IP';

  @override
  String get inputTargetCidr => '請輸入目標CIDR網段';

  @override
  String get ipAddress => 'IP位址';

  @override
  String get networkAddress => '網路位址';

  @override
  String get broadcastAddress => '廣播位址';

  @override
  String get usableIps => '可用IP數量';

  @override
  String get firstUsableIp => '第一可用IP';

  @override
  String get lastUsableIp => '最後可用IP';

  @override
  String get networkClass => '網路類別';

  @override
  String get cidr => 'CIDR';

  @override
  String get subnetMask => '子網路遮罩';

  @override
  String get invertedMask => '反遮罩';

  @override
  String get binary => '二進制';

  @override
  String get hexadecimal => '十六進制';

  @override
  String get decimal => '十進制';

  @override
  String get complement => '反碼';

  @override
  String get result => '結果';

  @override
  String get error => '錯誤';

  @override
  String get invalidInput => '無效的輸入';

  @override
  String get copy => '複製';

  @override
  String get delete => '刪除';

  @override
  String get export => '匯出';

  @override
  String get merge => '合併網段';

  @override
  String get mergeAlgorithm => '合併算法';

  @override
  String get selectAlgorithm => '選擇算法';

  @override
  String get algorithmSummarizationSource =>
      '基於 Route Summarization Calculator (calcip.com)';

  @override
  String get algorithmMergeSource =>
      '基於 CIDR Merger & Deduplicator (networks.tools)';

  @override
  String get algorithmSummarization => 'Summarization';

  @override
  String get algorithmSummarizationDescription => '最大化覆蓋的匯總，找到所有網路的公共前綴';

  @override
  String get algorithmMerge => 'Merge';

  @override
  String get algorithmMergeDescription => '基於路由器性能的合併最優解，合併相鄰或重疊的CIDR範圍';

  @override
  String get split => '拆分網路';

  @override
  String get check => '檢測';

  @override
  String get noHistory => '暫無歷史記錄';

  @override
  String get deleteAll => '清空全部';

  @override
  String get exportHistory => '匯出歷史記錄';

  @override
  String get importHistory => '匯入歷史記錄';

  @override
  String get search => '搜尋';

  @override
  String get searchHint => '搜尋計算器、輸入或結果...';

  @override
  String get exportSuccess => '匯出成功';

  @override
  String get exportFailed => '匯出失敗';

  @override
  String get importSuccess => '匯入成功';

  @override
  String get importFailed => '匯入失敗';

  @override
  String get invalidFile => '無效的檔案格式';

  @override
  String get version => '版本';

  @override
  String get developer => '開發者';

  @override
  String get github => 'GitHub';

  @override
  String get email => '電子郵件';

  @override
  String get confirmDeleteAll => '確定要清空所有歷史記錄嗎？';

  @override
  String get cancel => '取消';

  @override
  String get noResultsFound => '未找到結果';

  @override
  String get copiedToClipboard => '已複製到剪貼簿';

  @override
  String get inputs => '輸入';

  @override
  String get hosts => '主機數';

  @override
  String get usableHosts => '可用主機數';

  @override
  String get subnetInput => '子網路輸入';

  @override
  String get decimalNoDot => '無點分十進制';

  @override
  String get trueText => '是';

  @override
  String get falseText => '否';

  @override
  String get pleaseEnter => '請輸入';

  @override
  String get or => '或';

  @override
  String get theme => '主題';

  @override
  String get light => '淺色';

  @override
  String get dark => '深色';

  @override
  String get system => '跟隨系統';

  @override
  String get pleaseEnterBothIpAndSubnet => '請輸入IP位址和子網路遮罩';

  @override
  String get pleaseEnterHostOrSubnet => '請輸入主機數或子網路遮罩，不能同時輸入';

  @override
  String get hostCountMustBeAtLeast2 => '主機數必須至少為2';

  @override
  String get pleaseEnterBothCidr => '請輸入兩個CIDR值';

  @override
  String get pleaseEnterSupernetAndMask => '請輸入超網和目標遮罩長度';

  @override
  String get targetMaskMustBeBetween1And32 => '目標遮罩長度必須在1到32之間';

  @override
  String get invalidSupernetFormat => '無效的超網格式或目標遮罩長度';

  @override
  String get errorInvalidIpAddressFormat => '無效的IP位址格式';

  @override
  String get errorInvalidIpOrSubnetMaskFormat => '無效的IP位址或子網路遮罩格式';

  @override
  String get errorInvalidSubnetMaskFormat => '無效的子網路遮罩格式';

  @override
  String get errorInvalidCidrFormat => '無效的CIDR格式';

  @override
  String get errorInvalidCidrRange => '無效的CIDR，必須在/0到/32之間';

  @override
  String get errorInvalidNetworkFormat => '無效的網路格式';

  @override
  String get errorInvalidInput => '無效的輸入';

  @override
  String get errorConversionFailed => '轉換失敗';

  @override
  String get errorCheckFailed => '檢測失敗';

  @override
  String get errorGeneral => '發生錯誤';

  @override
  String get errorDecimalOutOfRange => '十進制值超出範圍';

  @override
  String get errorHostCountMustBeAtLeast2 => '主機數必須至少為2';

  @override
  String get errorNoNetworksProvided => '未提供網路';

  @override
  String get aboutAppDescription => '這是一個功能強大的工具，幫助使用者進行IP位址規劃和計算。';

  @override
  String get aboutFeatures => '主要功能包括：';

  @override
  String get aboutFeature1 => '• IP位址規劃計算';

  @override
  String get aboutFeature2 => '• IP位址進制轉換';

  @override
  String get aboutFeature3 => '• IP位址歸屬網段檢測';

  @override
  String get aboutFeature4 => '• 子網路遮罩與主機數換算';

  @override
  String get aboutFeature5 => '• 路由聚合及超網拆分';

  @override
  String get aboutFeature6 => '• 計算歷史記錄管理';

  @override
  String get aboutTargetUsers => '該工具適合網路工程師、開發者和學習者。';

  @override
  String get aboutVersionInfo => '目前版本已優化使用者介面並修復了一些問題。';

  @override
  String get author => '作者';

  @override
  String get bluesky => 'Bluesky';

  @override
  String get colorTheme => '顏色';

  @override
  String get presetThemes => '預設顏色';

  @override
  String get customThemes => '自訂主題';

  @override
  String get createCustomTheme => '建立自訂主題';

  @override
  String get themeName => '主題名稱';

  @override
  String get selectColor => '選擇顏色';

  @override
  String get save => '儲存';

  @override
  String get reset => '重設';

  @override
  String get resetToDefault => '重設為預設';

  @override
  String get resetToDefaultConfirm => '確定要重設為預設主題嗎？這將刪除所有自訂主題。';

  @override
  String get deleteTheme => '刪除主題';

  @override
  String deleteThemeConfirm(String themeName) {
    return '確定要刪除主題 \"$themeName\" 嗎？';
  }

  @override
  String get neteaseRed => '網易雲·紅';

  @override
  String get facebookBlue => 'Facebook 藍';

  @override
  String get spotifyGreen => 'Spotify 綠';

  @override
  String get qqMusicYellow => 'QQ音樂·黃';

  @override
  String get bilibiliPink => 'BiliBili·粉紅';

  @override
  String get calculatorSortOrder => '計算器排序';

  @override
  String get calculatorSortOrderDescription => '拖曳調整計算器順序';

  @override
  String get resetSortOrder => '重設排序';

  @override
  String get resetSortOrderConfirm => '確定要重設為預設排序嗎？';

  @override
  String get historyLimit => '歷史記錄數量限制';

  @override
  String get historyLimitDescription => '設定最多儲存的歷史記錄條數';

  @override
  String get historyLimitHint => '請輸入數量（10-100000）';

  @override
  String get dataStoragePath => '資料記錄讀寫目錄';

  @override
  String get dataStoragePathDefault => '預設：應用程式資料目錄';

  @override
  String get dataStoragePathDefaultPath => '預設讀寫位置';

  @override
  String get dataStoragePathCustom => '自訂讀寫位置';

  @override
  String get dataStoragePathSet => '資料記錄讀寫目錄已設定為';

  @override
  String get dataStoragePathReset => '已重設為預設讀寫位置';

  @override
  String get historyDetailSettings => '歷史記錄詳細設定';

  @override
  String get historyDetailSettingsDescription => '歷史記錄的詳細配置選項';

  @override
  String get currentLimit => '目前限制';

  @override
  String get entries => '條';

  @override
  String get appSubtitle => '專業的網路計算工具集';

  @override
  String get getStarted => '開始使用';

  @override
  String get cannotOpenLink => '無法開啟連結';

  @override
  String get clearCalculatorStates => '清除計算機狀態';

  @override
  String get confirmClearCalculatorStates => '確定要清除所有計算機的輸入和結果嗎？';

  @override
  String get calculatorStatesCleared => '已清除所有計算機的輸入和結果';

  @override
  String get references => '參考資料';

  @override
  String get referenceBasicTools => '基礎 IP 與子網工具';

  @override
  String get referenceIpAddressCalc => 'IP地址計算與進制轉換';

  @override
  String get referenceIpAddressCalcDesc => '適用場景：基礎 IP 地址換算、進制轉換、網段劃分。';

  @override
  String get referenceIpCalculator => 'IP計算器';

  @override
  String get referenceSubnetCidr => '子網與 CIDR 工具';

  @override
  String get referenceSubnetCidrDesc => '適用場景：可視化子網劃分、CIDR 地址塊展示。';

  @override
  String get referenceRouteAggregation => '路由聚合與超網拆分';

  @override
  String get referenceSupernetSplit => '超網拆分';

  @override
  String get referenceSupernetSplitDesc => '適用場景：將大地址塊拆分為多個小網段。';

  @override
  String get referenceRouteAggregationTitle => '路由聚合';

  @override
  String get referenceRouteAggregationDesc => '適用場景：合併多個子網為一個 CIDR，優化路由表。';

  @override
  String get referenceLearningResources => '學習與速查資源';

  @override
  String get referenceTechBlogs => '技術部落格參考';

  @override
  String get referenceSubnetRouteBlog => '子網劃分與路由聚合詳解';

  @override
  String get referenceCheatSheets => '網路速查表';
}
