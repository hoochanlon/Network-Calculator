# ネットワーク計算機 (Network Calculator)

![](./assets/images/demo/2025-12-31-12-17-06.png)

IPアドレス計算、サブネット分割、ルート集約などの専門的な機能を提供するモダンなネットワーク計算機アプリケーション。Flutterで開発され、WindowsデスクトップとWebプラットフォームをサポートしています。

**语言 / Language / げんご**: [简体中文](README.md) | [English](README_EN.md) | [日本語](README_JA.md)

![Version](https://img.shields.io/badge/version-1.6.0-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## ✨ 機能

設計アーキテクチャについては、[Architecture-Diagrams](./docs/Architecture-Diagrams.md) を参照してください。

### コア計算機能

- **IPアドレス計算機** - IPアドレスのネットワーク情報、ブロードキャストアドレス、利用可能なホスト数などを計算
- **サブネットマスク計算機** - ホスト数またはサブネットマスクに基づいてネットワークパラメータを計算、バイナリと16進数の表示をサポート
- **IP進数変換器** - IPアドレスをバイナリ、10進数、16進数の間で変換
- **ルート集約計算機** - 複数のサブネットをCIDRアドレスブロックにマージ、2つの集約アルゴリズムをサポート
- **スーパーネット分割計算機** - 大きなアドレスブロックを複数の小さなネットワークセグメントに分割
- **IP包含検出器** - IPアドレスまたはネットワークセグメントが別のネットワークセグメントに含まれているかどうかを検出

### ユーザー体験

- 🎨 **モダンなUI** - Webドキュメントスタイルのインターフェースデザイン
- 🌓 **テーマ切り替え** - ライト/ダークテーマをサポート、複数のカラーテーマオプション
- 🌍 **多言語サポート** - 簡体字中国語、繁体字中国語、英語、日本語
- 📝 **履歴記録** - 計算履歴を自動保存、検索、インポート、エクスポートをサポート
- 🔄 **状態保存** - 入力状態を自動保存、ページを切り替えてもデータが失われません
- 📱 **レスポンシブデザイン** - 異なる画面サイズに適応、サイドバー幅が自動調整
- 🎯 **サイドバーソート** - ドラッグアンドドロップによるソートとアイテムロック機能をサポート

## 🚀 クイックスタート

### 1. プロジェクトのクローンと依存関係のインストール

```bash
git clone <repository-url> && cd Network-Calculator
flutter clean && flutter pub get
```

### 2. プロジェクトの実行

**デスクトップ版 (Windows):**

```bash
flutter run -d windows
```

**Web版:**

```bash
flutter run -d chrome
```

### 3. トラブルシューティング

Windowsプラットフォーム関連の問題（シンボリックリンクエラー、プラグイン登録失敗、ビルドキャッシュの問題など）が発生した場合、ワンクリック修復スクリプトを使用できます：

**PowerShell (推奨):**

```powershell
.\scripts\fix_flutter_issues.ps1
```

このスクリプトは、以下の修復手順を自動的に実行します：

- 破損したシンボリックリンクディレクトリの削除
- CMakeキャッシュのクリーンアップ
- Flutterビルドキャッシュのクリーンアップ
- 依存パッケージの再取得
- プラグイン登録ファイルの再生成
- ビルド設定の検証

修復が完了したら、アプリケーションを正常に実行できます。

## 📦 配布

### 1. 実行可能プログラムの作成

**Windowsデスクトップアプリケーションのビルド:**

```bash
flutter build windows --release
```

インストーラーを作成するためのInnoSetupパッケージング手順を確認するには、以下のバッチファイルを実行してください：

```powershell
InnoSetup.bat
```

単一の実行可能ファイルを作成するためのEnigma Virtual Boxパッケージング手順を確認するには、以下のバッチファイルを実行してください：

```powershell
EnigmaVirtualBox.bat
```

### 2. Webデプロイ

**Webアプリケーションのビルド:**

```bash
flutter build web --release
```

1. Setting > Pages > Build and deployment > Action
2. GitHub Pagesにデプロイ

    ```bash
    # GitHub Actionデプロイコードを参照
    cat .github/deploy.yml
    ```

