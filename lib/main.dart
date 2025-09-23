import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'locator.dart';
import 'ui/app.dart';
import 'data/services/supabase_service.dart';
import 'data/services/lottie_cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // AdMobの初期化
  MobileAds.instance.initialize();

  // テストデバイスの設定（開発時のみ）
  RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: [
      '7D528A79-1710-422B-9E1A-8BAC0F94E051', // iOS
      'f1aafff0-b1c2-44c7-9fd3-10ca1ad1abe1', // Android
    ],
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  // Supabase初期化
  await SupabaseService.initialize();

  // Lottieアニメーションのプリキャッシュ
  await LottieCacheService().preloadAssets();

  setupLocator();
  runApp(const ProviderScope(child: KatakanaNashiApp()));
}
