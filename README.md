# ことばかくれんぼ

カタカナを使わずに言葉を説明するゲームアプリです。

## プロジェクト概要

このプロジェクトでは、development、staging、productionの3つの環境（Flavor）をサポートしています。
各環境で異なる広告設定やアプリ設定を使用できます。

## 環境別設定

### Development（開発環境）
- アプリ名: ことばかくれんぼ (Dev)
- Application ID: com.kotoba.kakurenbo.dev
- 広告: テスト用広告ID

### Staging（ステージング環境）
- アプリ名: ことばかくれんぼ (Stg)
- Application ID: com.kotoba.kakurenbo.stg
- 広告: テスト用広告ID

### Production（本番環境）
- アプリ名: ことばかくれんぼ
- Application ID: com.kotoba.kakurenbo
- 広告: 本番用広告ID
  - Android: `ca-app-pub-2716829166250639/3387528627`
  - iOS: `ca-app-pub-2716829166250639/9936269880`

## ビルドコマンド

### 🤖 Android APK ファイル作成

#### Development環境
```bash
flutter build apk --target lib/main_development.dart
flutter build apk --target lib/main_development.dart --release
```

#### Staging環境
```bash
flutter build apk --target lib/main_staging.dart --release --flavor staging
```

#### Production環境
```bash
flutter build apk --target lib/main_production.dart --release --flavor production
```

**注意**: フレーバー機能は一部環境で動作しない場合があります。その場合は以下のコマンドを使用してください：
```bash
# Production環境（フレーバーなし）
flutter build apk --target lib/main_production.dart --release
```

### 📦 Android AAB ファイル作成（Google Play Store用）

#### Development環境
```bash
flutter build appbundle --target lib/main_development.dart
flutter build appbundle --target lib/main_development.dart --release
```

#### Staging環境
```bash
flutter build appbundle --target lib/main_staging.dart --release --flavor staging
```

#### Production環境
```bash
flutter build appbundle --target lib/main_production.dart --release --flavor production
```

### 🍎 iOS IPA ファイル作成（App Store用）

#### Development環境
```bash
flutter build ios --target lib/main_development.dart
flutter build ios --target lib/main_development.dart --release
```

#### Staging環境
```bash
flutter build ios --target lib/main_staging.dart --release
```

#### Production環境
```bash
flutter build ios --target lib/main_production.dart --release
```

**注意**: iOS IPAファイルの作成にはXcodeでの追加設定とArchive処理が必要です。
**推奨**: Xcodeで直接archiveを実行する方が確実です：
1. `open ios/Runner.xcworkspace`
2. Product → Scheme → Runner-Production を選択
3. Product → Archive を実行

## 実行コマンド

### 開発環境で実行
```bash
flutter run --target lib/main_development.dart
```

### ステージング環境で実行
```bash
flutter run --target lib/main_staging.dart --release
```

### 本番環境で実行
```bash
flutter run --target lib/main_production.dart --release
```

**注意**: フレーバー付きコマンドは現在の設定では動作しません。上記のコマンドを使用してください。

## 広告ID確認機能

本番環境で実行すると、アプリ起動時に以下のような広告ID確認ログが表示されます：

```
🚨🚨🚨 アプリ起動 - 環境確認 🚨🚨🚨
現在の環境: Environment.production
isDebugMode: false

=== 本番用広告ID確認 ===
環境: Environment.production
プラットフォーム: ios
現在使用中の広告ID: ca-app-pub-2716829166250639/9936269880
========================
```

これにより、archiveビルド時に正しい本番用広告IDが使用されていることを確認できます。

## 出力ファイル場所

- **APKファイル**: `build/app/outputs/flutter-apk/`
- **AABファイル**: `build/app/outputs/bundle/`
- **iOSファイル**: `build/ios/iphoneos/`

## Getting Started

このプロジェクトを初めて使用する場合：

1. 依存関係をインストール:
```bash
flutter pub get
```

2. 開発環境で実行:
```bash
flutter run --flavor development -t lib/main_development.dart
```

## 参考資料

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter development documentation](https://docs.flutter.dev/)
