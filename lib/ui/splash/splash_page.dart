import 'package:flutter/material.dart';

import 'package:katakanahanashi/data/services/onboarding_service.dart';
import 'package:katakanahanashi/ui/home/start/start_page.dart';
import 'package:katakanahanashi/ui/onboarding/onboarding_page.dart';

/// スプラッシュページ - 初回起動時の制御を行う
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  /// オンボーディング状態をチェックして適切なページに遷移
  Future<void> _checkOnboardingStatus() async {
    // 少し待機してスプラッシュ画面を表示
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final hasSeenOnboarding = await OnboardingService.hasSeenOnboarding();

    if (hasSeenOnboarding) {
      // オンボーディングを見た場合はスタートページへ
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const StartPage()),
      );
    } else {
      // 初回起動の場合はオンボーディングページへ
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // アプリアイコンを表示
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/icon/app_icon.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // 画像が読み込めない場合のフォールバック
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.games,
                        size: 60,
                        color: Colors.orange,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            // アプリ名
            Text(
              'ことばかくれんぼ',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade800,
              ),
            ),
            const SizedBox(height: 16),
            // ローディングインジケーター
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade600),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
