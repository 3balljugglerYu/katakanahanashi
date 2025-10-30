import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'config/app_config.dart';
import 'locator.dart';
import 'ui/app.dart';
import 'data/services/supabase_service.dart';
import 'data/services/lottie_cache_service.dart';
import 'data/services/ad_service.dart';
import 'data/services/remote_config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🚨 main_production.dart が実行されていることを確認
  print('🚨🚨🚨 main_production.dart が実行されました 🚨🚨🚨');
  print('🚨🚨🚨 PRODUCTION ENVIRONMENT STARTING 🚨🚨🚨');

  // 本番環境の設定（最初に設定）
  AppConfig.setEnvironment(Environment.production);

  // 環境設定を確認
  print('=== 環境設定確認 ===');
  print('設定された環境: ${AppConfig.environment}');
  print('isDebugMode: ${AppConfig.isDebugMode}');
  print('==================');

  // 本番用広告IDをログ出力（archiveビルド確認用）
  AdService.logProductionAdId();

  // 再度確認
  print('=== 再確認 ===');
  print('現在の環境: ${AppConfig.environment}');
  print('===============');

  // AdMobの初期化
  MobileAds.instance.initialize();

  // 本番環境ではテストデバイス設定なし

  await Firebase.initializeApp();

  final remoteConfigService = RemoteConfigService.firebase(
    FirebaseRemoteConfig.instance,
  );
  await remoteConfigService.initialize();

  // Supabase初期化
  await SupabaseService.initialize();

  // Lottieアニメーションのプリキャッシュ
  await LottieCacheService().preloadAssets();

  setupLocator();
  runApp(
    ProviderScope(
      overrides: [
        remoteConfigServiceProvider.overrideWithValue(remoteConfigService),
      ],
      child: const KatakanaNashiApp(),
    ),
  );
}
