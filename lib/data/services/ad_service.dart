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
}
