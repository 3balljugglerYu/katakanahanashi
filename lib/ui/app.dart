import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../config/app_config.dart';
import '../data/services/ad_service.dart';
import '../navigator/app_router.dart';
import '../theme/app_theme.dart';

class KatakanaNashiApp extends ConsumerWidget {
  const KatakanaNashiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // アプリ起動時に環境と広告ID確認ログを出力
    print('🚨🚨🚨 アプリ起動 - 環境確認 🚨🚨🚨');
    print('現在の環境: ${AppConfig.environment}');
    print('isDebugMode: ${AppConfig.isDebugMode}');
    AdService.logProductionAdId();
    print('🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨');

    return MaterialApp(
      title: 'ことばかくれんぼ',
      theme: AppTheme.lightTheme,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.splashRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
