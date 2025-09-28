import 'dart:io';
import '../../config/app_config.dart';

class AdService {
  // プラットフォーム別の広告ユニットIDを取得
  static String get interstitialAdUnitId {
    if (Platform.isIOS) {
      return AppConfig.iosInterstitialAdUnitId;
    } else if (Platform.isAndroid) {
      return AppConfig.androidInterstitialAdUnitId;
    } else {
      // その他のプラットフォーム（テスト用）
      return AppConfig.iosInterstitialAdUnitId;
    }
  }

  // デバッグ情報出力
  static void logAdInfo() {
    if (AppConfig.isDebugMode) {
      print('=== 広告設定情報 ===');
      print('環境: ${AppConfig.environment}');
      print('プラットフォーム: ${Platform.operatingSystem}');
      print('広告ユニットID: $interstitialAdUnitId');
      print('================');
    }
  }

  // 本番用広告IDをログ出力（archiveビルド確認用）
  static void logProductionAdId() {
    print('=== 本番用広告ID確認 ===');
    print('環境: ${AppConfig.environment}');
    print('プラットフォーム: ${Platform.operatingSystem}');

    // Environment.productionから直接取得して表示
    print('--- Environment.production から取得 ---');
    print('Android本番用広告ID: ${_getAndroidProductionAdId()}');
    print('iOS本番用広告ID: ${_getIosProductionAdId()}');

    print('--- AppConfig経由で取得 ---');
    print('Android本番用広告ID: ${AppConfig.androidInterstitialAdUnitId}');
    print('iOS本番用広告ID: ${AppConfig.iosInterstitialAdUnitId}');
    print('現在使用中の広告ID: $interstitialAdUnitId');
    print('========================');
  }

  // Environment.productionから直接取得するメソッド
  static String _getAndroidProductionAdId() {
    switch (Environment.production) {
      case Environment.development:
      case Environment.staging:
        return 'ca-app-pub-3940256099942544/1033173712';
      case Environment.production:
        return 'ca-app-pub-2716829166250639/3387528627';
    }
  }

  static String _getIosProductionAdId() {
    switch (Environment.production) {
      case Environment.development:
      case Environment.staging:
        return 'ca-app-pub-3940256099942544/4411468910';
      case Environment.production:
        return 'ca-app-pub-2716829166250639/9936269880';
    }
  }
}
