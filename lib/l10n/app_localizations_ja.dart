// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ネットワーク計算機';

  @override
  String get ipCalculator => 'IPアドレス計算機';

  @override
  String get subnetCalculator => 'サブネットマスク計算機';

  @override
  String get baseConverter => 'IP進数変換機';

  @override
  String get networkMerge => 'ルート集約計算機';

  @override
  String get networkSplit => 'スーパーネット分割計算機';

  @override
  String get ipInclusionChecker => 'IP包含検出機';

  @override
  String get history => '履歴';

  @override
  String get settings => '設定';

  @override
  String get about => 'について';

  @override
  String get language => '言語';

  @override
  String get chinese => '中文';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get followSystem => 'システムに従う';

  @override
  String get preserveInputs => '入力と結果を保持';

  @override
  String get preserveInputsDescription => '計算機を切り替える際に入力内容と計算結果を保持';

  @override
  String get calculate => '計算';

  @override
  String get clear => 'クリア';

  @override
  String get inputIpAddress => 'IPアドレスを入力してください';

  @override
  String get inputSubnetMask => 'サブネットマスクを入力してください';

  @override
  String get inputHosts => 'ホスト数を入力してください';

  @override
  String get inputSubnetOrCidr => 'サブネットマスクまたはCIDRを入力してください';

  @override
  String get inputBaseValue => 'IPアドレスまたは数値を入力してください';

  @override
  String get inputNetworks => 'CIDR形式のネットワークを入力してください（改行で区切る）';

  @override
  String get inputSupernet => '分割するスーパーネットを入力してください（CIDR形式）';

  @override
  String get inputTargetMask => 'ターゲットサブネットマスク長を入力してください（1〜32）';

  @override
  String get inputCheckCidr => '検証するCIDRまたはIPを入力してください';

  @override
  String get inputTargetCidr => 'ターゲットCIDRネットワークを入力してください';

  @override
  String get ipAddress => 'IPアドレス';

  @override
  String get networkAddress => 'ネットワークアドレス';

  @override
  String get broadcastAddress => 'ブロードキャストアドレス';

  @override
  String get usableIps => '使用可能IP数';

  @override
  String get firstUsableIp => '最初の使用可能IP';

  @override
  String get lastUsableIp => '最後の使用可能IP';

  @override
  String get networkClass => 'ネットワーククラス';

  @override
  String get cidr => 'CIDR';

  @override
  String get subnetMask => 'サブネットマスク';

  @override
  String get invertedMask => '反転マスク';

  @override
  String get binary => '2進数';

  @override
  String get hexadecimal => '16進数';

  @override
  String get decimal => '10進数';

  @override
  String get complement => '補数';

  @override
  String get result => '結果';

  @override
  String get error => 'エラー';

  @override
  String get invalidInput => '無効な入力';

  @override
  String get copy => 'コピー';

  @override
  String get delete => '削除';

  @override
  String get export => 'エクスポート';

  @override
  String get merge => 'ネットワークをマージ';

  @override
  String get mergeAlgorithm => 'マージアルゴリズム';

  @override
  String get selectAlgorithm => 'アルゴリズムを選択';

  @override
  String get algorithmSummarizationSource =>
      'Route Summarization Calculator (calcip.com) に基づく';

  @override
  String get algorithmMergeSource =>
      'CIDR Merger & Deduplicator (networks.tools) に基づく';

  @override
  String get algorithmSummarization => 'Summarization';

  @override
  String get algorithmSummarizationDescription =>
      '最大カバレッジの要約、すべてのネットワークの共通プレフィックスを見つける';

  @override
  String get algorithmMerge => 'Merge';

  @override
  String get algorithmMergeDescription =>
      'ルーター性能に基づく最適なマージソリューション、隣接または重複するCIDR範囲をマージ';

  @override
  String get split => 'ネットワークを分割';

  @override
  String get check => '検出';

  @override
  String get noHistory => '履歴がありません';

  @override
  String get deleteAll => 'すべて削除';

  @override
  String get exportHistory => '履歴をエクスポート';

  @override
  String get importHistory => '履歴をインポート';

  @override
  String get search => '検索';

  @override
  String get searchHint => '計算機、入力または結果を検索...';

  @override
  String get exportSuccess => 'エクスポート成功';

  @override
  String get exportFailed => 'エクスポート失敗';

  @override
  String get importSuccess => 'インポート成功';

  @override
  String get importFailed => 'インポート失敗';

  @override
  String get invalidFile => '無効なファイル形式';

  @override
  String get version => 'バージョン';

  @override
  String get developer => '開発者';

  @override
  String get github => 'GitHub';

  @override
  String get email => 'メール';

  @override
  String get confirmDeleteAll => 'すべての履歴を削除してもよろしいですか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get noResultsFound => '結果が見つかりません';

  @override
  String get copiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get inputs => '入力';

  @override
  String get hosts => 'ホスト数';

  @override
  String get usableHosts => '使用可能ホスト数';

  @override
  String get subnetInput => 'サブネット入力';

  @override
  String get decimalNoDot => 'ドットなし10進数';

  @override
  String get trueText => 'はい';

  @override
  String get falseText => 'いいえ';

  @override
  String get pleaseEnter => '入力してください';

  @override
  String get or => 'または';

  @override
  String get theme => 'テーマ';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get system => 'システムに従う';

  @override
  String get pleaseEnterBothIpAndSubnet => 'IPアドレスとサブネットマスクの両方を入力してください';

  @override
  String get pleaseEnterHostOrSubnet => 'ホスト数またはサブネットマスクのいずれかを入力してください（両方は不可）';

  @override
  String get hostCountMustBeAtLeast2 => 'ホスト数は少なくとも2である必要があります';

  @override
  String get pleaseEnterBothCidr => '2つのCIDR値を入力してください';

  @override
  String get pleaseEnterSupernetAndMask => 'スーパーネットとターゲットマスク長の両方を入力してください';

  @override
  String get targetMaskMustBeBetween1And32 => 'ターゲットマスク長は1から32の間である必要があります';

  @override
  String get invalidSupernetFormat => '無効なスーパーネット形式またはターゲットマスク長';

  @override
  String get errorInvalidIpAddressFormat => '無効なIPアドレス形式';

  @override
  String get errorInvalidIpOrSubnetMaskFormat => '無効なIPアドレスまたはサブネットマスク形式';

  @override
  String get errorInvalidSubnetMaskFormat => '無効なサブネットマスク形式';

  @override
  String get errorInvalidCidrFormat => '無効なCIDR形式';

  @override
  String get errorInvalidCidrRange => '無効なCIDR、/0から/32の間である必要があります';

  @override
  String get errorInvalidNetworkFormat => '無効なネットワーク形式';

  @override
  String get errorInvalidInput => '無効な入力';

  @override
  String get errorConversionFailed => '変換に失敗しました';

  @override
  String get errorCheckFailed => '検出に失敗しました';

  @override
  String get errorGeneral => 'エラーが発生しました';

  @override
  String get errorDecimalOutOfRange => '10進数値が範囲外です';

  @override
  String get errorHostCountMustBeAtLeast2 => 'ホスト数は少なくとも2である必要があります';

  @override
  String get errorNoNetworksProvided => 'ネットワークが提供されていません';

  @override
  String get aboutAppDescription => 'これは、ユーザーがIPアドレスの計画と計算を支援する強力なツールです。';

  @override
  String get aboutFeatures => '主な機能：';

  @override
  String get aboutFeature1 => '• IPアドレス計画と計算';

  @override
  String get aboutFeature2 => '• IPアドレス進数変換';

  @override
  String get aboutFeature3 => '• IPアドレスネットワークセグメント検出';

  @override
  String get aboutFeature4 => '• サブネットマスクとホスト数の変換';

  @override
  String get aboutFeature5 => '• ルート集約とスーパーネット分割';

  @override
  String get aboutFeature6 => '• 計算履歴管理';

  @override
  String get aboutTargetUsers => 'このツールは、ネットワークエンジニア、開発者、学習者に適しています。';

  @override
  String get aboutVersionInfo => '現在のバージョンはユーザーインターフェースを最適化し、いくつかの問題を修正しました。';

  @override
  String get author => '作者';

  @override
  String get bluesky => 'Bluesky';

  @override
  String get colorTheme => '色';

  @override
  String get presetThemes => 'プリセット色';

  @override
  String get customThemes => 'カスタムテーマ';

  @override
  String get createCustomTheme => 'カスタムテーマを作成';

  @override
  String get themeName => 'テーマ名';

  @override
  String get selectColor => '色を選択';

  @override
  String get save => '保存';

  @override
  String get reset => 'リセット';

  @override
  String get resetToDefault => 'デフォルトにリセット';

  @override
  String get resetToDefaultConfirm =>
      'デフォルトテーマにリセットしてもよろしいですか？これにより、すべてのカスタムテーマが削除されます。';

  @override
  String get deleteTheme => 'テーマを削除';

  @override
  String deleteThemeConfirm(String themeName) {
    return 'テーマ \"$themeName\" を削除してもよろしいですか？';
  }

  @override
  String get neteaseRed => 'NetEase・赤';

  @override
  String get facebookBlue => 'Facebook 青';

  @override
  String get spotifyGreen => 'Spotify 緑';

  @override
  String get qqMusicYellow => 'QQ音楽・黄';

  @override
  String get bilibiliPink => 'BiliBili・ピンク';

  @override
  String get calculatorSortOrder => '計算機の並び順';

  @override
  String get calculatorSortOrderDescription => 'ドラッグして計算機の順序を調整';

  @override
  String get sidebarSortOrder => 'サイドバーの並び順';

  @override
  String get sidebarSortOrderDescription => 'ドラッグしてサイドバー項目の順序を調整';

  @override
  String get resetSortOrder => '並び順をリセット';

  @override
  String get resetSortOrderConfirm => 'デフォルトの並び順にリセットしてもよろしいですか？';

  @override
  String get resetSidebarSortOrder => 'サイドバーの並び順をリセット';

  @override
  String get resetSidebarSortOrderConfirm => 'デフォルトのサイドバーの並び順にリセットしてもよろしいですか？';

  @override
  String get lockItem => '項目をロック';

  @override
  String get unlockItem => '項目のロックを解除';

  @override
  String get sidebarDragEnabled => 'サイドバーのドラッグ並び替えを有効化';

  @override
  String get sidebarDragEnabledDescription =>
      '有効にすると、サイドバーで長押ししてドラッグして項目を並び替えることができます';

  @override
  String get historyLimit => '履歴数の制限';

  @override
  String get historyLimitDescription => '保存する履歴レコードの最大数を設定';

  @override
  String get historyLimitHint => '数を入力してください（10-100000）';

  @override
  String get dataStoragePath => 'データ記録読み書きディレクトリ';

  @override
  String get dataStoragePathDefault => 'デフォルト：アプリケーションデータディレクトリ';

  @override
  String get dataStoragePathDefaultPath => 'デフォルト読み書き位置';

  @override
  String get dataStoragePathCustom => 'カスタム読み書き位置';

  @override
  String get dataStoragePathSet => 'データ記録読み書きディレクトリが設定されました';

  @override
  String get dataStoragePathReset => 'デフォルト読み書き位置にリセットされました';

  @override
  String get historyDetailSettings => '履歴詳細設定';

  @override
  String get historyDetailSettingsDescription => '履歴記録の詳細設定オプション';

  @override
  String get currentLimit => '現在の制限';

  @override
  String get entries => '件';

  @override
  String get appSubtitle => 'プロフェッショナルなネットワーク計算機ツールセット';

  @override
  String get getStarted => '始める';

  @override
  String get cannotOpenLink => 'リンクを開けません';

  @override
  String get clearCalculatorStates => '計算機の状態をクリア';

  @override
  String get confirmClearCalculatorStates => 'すべての計算機の入力と結果をクリアしてもよろしいですか？';

  @override
  String get calculatorStatesCleared => 'すべての計算機の入力と結果がクリアされました';

  @override
  String get references => '参考資料';

  @override
  String get referenceBasicTools => '基本IPとサブネットツール';

  @override
  String get referenceIpAddressCalc => 'IPアドレス計算と基数変換';

  @override
  String get referenceIpAddressCalcDesc => '使用例：基本IPアドレス変換、基数変換、ネットワークセグメント分割。';

  @override
  String get referenceIpCalculator => 'IP計算機';

  @override
  String get referenceSubnetCidr => 'サブネットとCIDRツール';

  @override
  String get referenceSubnetCidrDesc => '使用例：視覚的なサブネット分割、CIDRアドレスブロック表示。';

  @override
  String get referenceRouteAggregation => 'ルート集約とスーパーネット分割';

  @override
  String get referenceSupernetSplit => 'スーパーネット分割';

  @override
  String get referenceSupernetSplitDesc =>
      '使用例：大きなアドレスブロックを複数の小さなネットワークセグメントに分割。';

  @override
  String get referenceRouteAggregationTitle => 'ルート集約';

  @override
  String get referenceRouteAggregationDesc =>
      '使用例：複数のサブネットを1つのCIDRにマージし、ルーティングテーブルを最適化。';

  @override
  String get referenceLearningResources => '学習とリファレンスリソース';

  @override
  String get referenceTechBlogs => '技術ブログリファレンス';

  @override
  String get referenceSubnetRouteBlog => 'サブネット分割とルート集約の説明';

  @override
  String get referenceCheatSheets => 'ネットワークチートシート';

  @override
  String get advanced => '詳細設定';

  @override
  String get advancedSettings => '詳細設定';
}
