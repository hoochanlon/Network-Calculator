# ネットワーク計算機 (Network Calculator)

IPアドレス計算、サブネット分割、ルート集約などの専門的な機能を提供するモダンなネットワーク計算機アプリケーション。Flutterで開発され、WindowsデスクトップとWebプラットフォームをサポートしています。

**言語 / Language / 语言**: [简体中文](README.md) | [English](README_EN.md) | [日本語](README_JA.md)

![Version](https://img.shields.io/badge/version-1.6.0-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## ✨ 機能

### コア計算機能

- **IPアドレス計算機** - IPアドレスのネットワーク情報、ブロードキャストアドレス、利用可能ホスト数などを計算
- **サブネットマスク計算機** - ホスト数またはサブネットマスクに基づいてネットワークパラメータを計算、バイナリと16進数表示をサポート
- **IP進数変換器** - IPアドレスを2進数、10進数、16進数の間で変換
- **ルート集約計算機** - 複数のサブネットをCIDRアドレスブロックに統合、2つの集約アルゴリズムをサポート
- **スーパーネット分割計算機** - 大きなアドレスブロックを複数の小さなネットワークセグメントに分割
- **IP包含検出器** - IPアドレスまたはネットワークセグメントが別のセグメントに含まれているかを検出

### ユーザー体験

- 🎨 **モダンなUI** - 网易云音乐スタイルのインターフェースデザイン
- 🌓 **テーマ切り替え** - ライト/ダークテーマをサポート、複数のカラーテーマから選択可能
- 🌍 **多言語サポート** - 簡体字中国語、繁体字中国語、英語、日本語
- 📝 **履歴記録** - 計算履歴を自動保存、検索、インポート、エクスポートをサポート
- 🔄 **状態保存** - 入力状態を自動保存、ページ切り替え時にデータが失われない
- 📱 **レスポンシブデザイン** - 異なる画面サイズに対応、サイドバー幅が自動調整
- 🎯 **サイドバーソート** - ドラッグ&ドロップソートとアイテムロック機能をサポート

## 🛠️ 技術スタック

- **フレームワーク**: Flutter 3.0+
- **状態管理**: Provider
- **ローカライゼーション**: flutter_localizations + intl
- **データストレージ**: SharedPreferences + ファイルシステム
- **UIコンポーネント**: Material Design 3
- **アイコン**: Material Symbols Icons

## 📋 要件

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Windows 10/11 (デスクトップ版)
- モダンブラウザ (Web版)

## 🚀 クイックスタート

### 1. リポジトリをクローン

```bash
git clone <repository-url>
cd Network-Calculator
```

### 2. 依存関係をインストール

```bash
flutter pub get
```

### 3. プロジェクトを実行

**デスクトップ版 (Windows):**
```bash
flutter run -d windows
```

**Web版:**
```bash
flutter run -d chrome
```

### 4. リリース版をビルド

**Windowsデスクトップアプリケーション:**
```bash
flutter build windows --release
```

**Webアプリケーション:**
```bash
flutter build web --release
```

## 🔧 ビルド手順

### Windowsデスクトップビルド

1. **Flutter環境が正しく設定されていることを確認**
   ```bash
   flutter doctor
   ```

2. **リリース版をビルド**
   ```bash
   flutter build windows --release
   ```

3. **出力場所**
   - ビルド成果物: `build\windows\x64\runner\Release\`
   - 実行ファイル: `network_calculator.exe`

### Webビルド

1. **Web版をビルド**
   ```bash
   flutter build web --release
   ```

2. **出力場所**
   - ビルド成果物: `build\web\`
   - Webサーバーに直接デプロイ可能

### Inno Setupでインストーラーを作成

プロジェクトにはInno Setupスクリプトが含まれており、Windowsインストーラーを作成できます：

```bash
# Inno Setupビルドスクリプトを実行
.\InnoSetup.bat
```

## ❗ よくある問題

### Flutterビルド失敗

#### 1. 依存関係の問題

**問題**: `flutter pub get` が失敗する、または依存関係の競合

**解決方法**:
```bash
# キャッシュをクリーン
flutter clean
flutter pub cache repair

# 依存関係を再取得
flutter pub get
```

#### 2. Windowsプラグインビルド失敗

**問題**: Windowsプラットフォームプラグインのコンパイルエラー

**解決方法**:
```bash
# 修正スクリプトを実行
.\fix_windows_plugins.ps1
# または
.\fix_windows_plugins.bat

# 再ビルド
flutter build windows --release
```

#### 3. CMakeエラー

**問題**: CMakeの設定またはコンパイル失敗

**解決方法**:
```bash
# ビルドキャッシュをクリーン
flutter clean
rmdir /s /q build\windows

# 再ビルド
flutter build windows --release
```

#### 4. シンボリックリンクの問題 (Windows)

**問題**: ビルド時にシンボリックリンク関連のエラーが発生

**解決方法**:
```bash
# シンボリックリンク修正スクリプトを実行
.\fix_symlink_issue.ps1
# または
.\fix_symlink_issue.bat
```

#### 5. ローカライゼーションファイル生成失敗

**問題**: `flutter pub get` 後にローカライゼーションファイルが生成されない

**解決方法**:
```bash
# ローカライゼーションファイルを手動生成
flutter gen-l10n

# または再実行
flutter pub get
```

#### 6. Webプラットフォームビルド失敗

**問題**: Webビルド時にエラーが発生

**解決方法**:
```bash
# Webビルドキャッシュをクリーン
flutter clean
rmdir /s /q build\web

# Webサポートを確認
flutter config --enable-web

# 再ビルド
flutter build web --release
```

### ランタイムの問題

#### 1. 履歴のインポート/エクスポートが動作しない (Webプラットフォーム)

**問題**: Chromeブラウザで履歴記録をインポートした際に文字化けが発生

**解決方法**: 
- JSONファイルがUTF-8エンコーディングを使用していることを確認
- 修正済み: `utf8.decode()` を使用してファイル内容を正しくデコード

#### 2. サイドバーのドラッグ&ドロップソートが動作しない

**問題**: 長押しロック/アンロック機能が無効

**解決方法**: 
- 設定で「サイドバードラッグソート」機能を有効にする必要があります
- ドラッグソートが有効な場合のみ、長押しロック/アンロックが機能します

#### 3. テーマ切り替えが動作しない

**問題**: テーマを切り替えてもインターフェースが変化しない

**解決方法**:
```bash
# アプリケーションを再起動
# またはキャッシュをクリーンして再実行
flutter clean
flutter run
```

## 📁 プロジェクト構造

```
lib/
├── core/                    # コア機能
│   ├── models/              # データモデル
│   ├── providers/           # 状態管理
│   ├── services/           # ビジネスロジックサービス
│   ├── theme/               # テーマ設定
│   └── utils/               # ユーティリティクラス
├── l10n/                    # ローカライゼーションファイル
│   ├── app_zh.arb           # 簡体字中国語
│   ├── app_zh_TW.arb        # 繁体字中国語
│   ├── app_en.arb           # 英語
│   └── app_ja.arb            # 日本語
└── ui/                      # UIインターフェース
    ├── screens/             # ページ
    └── widgets/             # コンポーネント
```

## 🎨 カスタム設定

### サイドバー幅を変更

`lib/ui/screens/main_screen.dart` を編集:

```dart
// デフォルト幅: 240、大画面（幅 > 1600）最大幅: 270
final sidebarWidth = screenWidth > 1600 ? 270.0 : 240.0;
```

### 新しい計算機を追加

1. `lib/core/services/` にサービスクラスを作成
2. `lib/ui/screens/calculator_screens/` にインターフェースを作成
3. `lib/ui/screens/main_navigation_items.dart` に登録

### 新しい言語を追加

1. `lib/l10n/` に `app_xx.arb` ファイルを作成
2. `flutter gen-l10n` を実行してコードを生成
3. `lib/main.dart` の `supportedLocales` に追加

## 📝 開発ガイド

### コード規約

プロジェクトは `flutter_lints` を使用してコードチェックを行い、コード品質を確保します：

```bash
# コード解析を実行
flutter analyze
```

### ローカライゼーション開発

1. `lib/l10n/app_zh.arb` (テンプレートファイル) を変更
2. 他の言語ファイルを同期更新
3. `flutter gen-l10n` を実行してコードを生成

### テスト

```bash
# ユニットテストを実行
flutter test

# 統合テストを実行
flutter test integration_test
```

## 🤝 貢献ガイド

コードの貢献を歓迎します！以下の手順に従ってください：

1. このプロジェクトをFork
2. 機能ブランチを作成 (`git checkout -b feature/AmazingFeature`)
3. 変更をコミット (`git commit -m 'Add some AmazingFeature'`)
4. ブランチにプッシュ (`git push origin feature/AmazingFeature`)
5. Pull Requestを開く

## 📄 ライセンス

このプロジェクトはMITライセンスの下でライセンスされています - 詳細は [LICENSE](LICENSE) ファイルを参照してください

## 🙏 謝辞

- [Flutter](https://flutter.dev/) - クロスプラットフォームUIフレームワーク
- [Material Symbols Icons](https://fonts.google.com/icons) - アイコンライブラリ
- すべての貢献者とユーザーのサポート

## 📞 連絡先

質問や提案がある場合は、以下の方法でお問い合わせください：

- [Issue](https://github.com/your-repo/issues) を提出
- メールを送信

---

**注意**: このプロジェクトは積極的に開発中です。問題が発生した場合は、お気軽にフィードバックをお願いします。

