import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'config/app_config.dart';
import 'data/services/ad_service.dart';
import 'locator.dart';
import 'ui/app.dart';
import 'data/services/supabase_service.dart';
import 'data/services/lottie_cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🚨 PRODUCTION MODE - main.dart を本番用に設定 🚨
  print('🚨🚨🚨 PRODUCTION MODE ENABLED IN main.dart 🚨🚨🚨');

  // 環境設定前の確認
  print('=== 環境設定前 ===');
  print('初期環境: ${AppConfig.environment}');
  print('初期isDebugMode: ${AppConfig.isDebugMode}');
  print('================');

  // 本番環境の設定（強制的に設定）
  // 複数回設定して確実にする
  AppConfig.setEnvironment(Environment.production);
  AppConfig.setEnvironment(Environment.production);
  AppConfig.setEnvironment(Environment.production);

  // 環境設定後の確認
  print('=== 環境設定後 ===');
  print('設定された環境: ${AppConfig.environment}');
  print('isDebugMode: ${AppConfig.isDebugMode}');
  print('================');

  // 本番用広告IDをログ出力（archiveビルド確認用）
  AdService.logProductionAdId();

  // AdMobの初期化
  MobileAds.instance.initialize();

  // 本番環境ではテストデバイス設定なし（コメントアウト）
  // RequestConfiguration requestConfiguration = RequestConfiguration(
  //   testDeviceIds: [
  //     '7D528A79-1710-422B-9E1A-8BAC0F94E051', // iOS
  //     'f1aafff0-b1c2-44c7-9fd3-10ca1ad1abe1', // Android
  //   ],
  // );
  // MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  // Supabase初期化
  await SupabaseService.initialize();

  // Lottieアニメーションのプリキャッシュ
  await LottieCacheService().preloadAssets();

  setupLocator();
  runApp(const ProviderScope(child: KatakanaNashiApp()));
}
