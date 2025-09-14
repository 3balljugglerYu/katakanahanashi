import 'package:shared_preferences/shared_preferences.dart';

/// オンボーディング関連の処理を管理するサービス
class OnboardingService {
  static const String _seenOnboardingKey = 'seen_onboarding';

  /// オンボーディングを既に見たかどうかを確認
  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seenOnboardingKey) ?? false;
  }

  /// オンボーディングを見た状態に設定
  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenOnboardingKey, true);
  }

  /// オンボーディング状態をリセット（デバッグ用）
  static Future<void> resetOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_seenOnboardingKey);
  }
}
