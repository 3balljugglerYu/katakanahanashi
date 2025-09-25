import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'config/app_config.dart';
import 'locator.dart';
import 'ui/app.dart';
import 'data/services/supabase_service.dart';
import 'data/services/lottie_cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 本番環境の設定
  AppConfig.setEnvironment(Environment.production);

  // AdMobの初期化
  MobileAds.instance.initialize();

  // 本番環境ではテストデバイス設定なし

  // Supabase初期化
  await SupabaseService.initialize();

  // Lottieアニメーションのプリキャッシュ
  await LottieCacheService().preloadAssets();

  setupLocator();
  runApp(const ProviderScope(child: KatakanaNashiApp()));
}
