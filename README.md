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

## ビルドコマンド

### 🤖 Android APK ファイル作成

#### Development環境
```bash
flutter build apk --flavor development -t lib/main_development.dart --debug
flutter build apk --flavor development -t lib/main_development.dart --release
```

#### Staging環境
```bash
flutter build apk --flavor staging -t lib/main_staging.dart --debug
flutter build apk --flavor staging -t lib/main_staging.dart --release
```

#### Production環境
```bash
flutter build apk --flavor production -t lib/main_production.dart --release
```

### 📦 Android AAB ファイル作成（Google Play Store用）

#### Development環境
```bash
flutter build appbundle --flavor development -t lib/main_development.dart --debug
flutter build appbundle --flavor development -t lib/main_development.dart --release
```

#### Staging環境
```bash
flutter build appbundle --flavor staging -t lib/main_staging.dart --debug
flutter build appbundle --flavor staging -t lib/main_staging.dart --release
```

#### Production環境
```bash
flutter build appbundle --flavor production -t lib/main_production.dart --release
```

### 🍎 iOS IPA ファイル作成（App Store用）

#### Development環境
```bash
flutter build ios --flavor development -t lib/main_development.dart --debug
flutter build ios --flavor development -t lib/main_development.dart --release
```

#### Staging環境
```bash
flutter build ios --flavor staging -t lib/main_staging.dart --debug
flutter build ios --flavor staging -t lib/main_staging.dart --release
```

#### Production環境
```bash
flutter build ios --flavor production -t lib/main_production.dart --release
```

**注意**: iOS IPAファイルの作成にはXcodeでの追加設定とArchive処理が必要です。

## 実行コマンド

### 開発環境で実行
```bash
flutter run --flavor development -t lib/main_development.dart
```

### ステージング環境で実行
```bash
flutter run --flavor staging -t lib/main_staging.dart
```

### 本番環境で実行
```bash
flutter run --flavor production -t lib/main_production.dart
```

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
