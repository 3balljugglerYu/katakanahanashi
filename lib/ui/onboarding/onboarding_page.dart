import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../home/start_page.dart';
import 'onboarding_view_model.dart';

/// オンボーディング（チュートリアル）ページ
class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntroductionScreen(
      pages: _buildPages(context),
      onDone: () => _completeOnboarding(context, ref),
      onSkip: () => _completeOnboarding(context, ref),
      showSkipButton: true,
      skip: const Text(
        'スキップ',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.orange,
        ),
      ),
      next: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          '次へ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      done: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          '始める',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Colors.orange.shade200,
        activeSize: const Size(22.0, 10.0),
        activeColor: Colors.orange,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      globalBackgroundColor: Colors.orange.shade50,
    );
  }

  /// オンボーディングページのリストを作成
  List<PageViewModel> _buildPages(BuildContext context) {
    return [
      // 1ページ目: アプリの紹介
      PageViewModel(
        title: "カタカナハナシへ\nようこそ！",
        body: "カタカナを使わずに説明して当て合う、ことば遊びゲームです！\n遊びながら日本語の言い換え力を鍛えよう！",
        image: _buildImageWidget(context, semanticsLabel: "カタカナハナシのアプリアイコン"),
        decoration: _buildPageDecoration(context),
      ),

      // 2ページ目: ゲームの遊び方
      PageViewModel(
        title: "ルール\nカタカナは使わない",
        body: "お題を、カタカナを一切使わずに説明してください。\n"
            "『コンピューター』→「計算をする電子の機械」",
        image: _buildImageWidget(context, semanticsLabel: "カタカナ禁止ルールの説明イラスト"),
        decoration: _buildPageDecoration(context),
      ),

      // 3ページ目: 楽しみ方
      PageViewModel(
        title: "聞いて想像し、\nズバリ当てよう！",
        body: "説明を手がかりに、思い浮かんだ答えを言いましょう！正解したら次へ！\n"
            "※1セット10個のお題が表示されます。\n",
        image: _buildImageWidget(context, semanticsLabel: "説明を聞いて答えを当てる場面のイラスト"),
        decoration: _buildPageDecoration(context),
      ),

      // 4ページ目: 楽しみ方
      PageViewModel(
        title: "みんなで遊んで、\nそして、難易度を評価！",
        body: "家族や友だちとプレイして、楽しもう！\n"
            "お題終了後に難しさを評価してください。今後のゲームバランス調整に役立ちます。",
        image: _buildImageWidget(context, semanticsLabel: "複数人で遊び、難易度を評価するイラスト"),
        decoration: _buildPageDecoration(context),
      ),
    ];
  }

  /// 画像ウィジェットを作成
  Widget _buildImageWidget(
    BuildContext context, {
    required String semanticsLabel,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.4; // 画面幅の40%

    return Semantics(
      label: semanticsLabel,
      child: Container(
        width: imageSize,
        height: imageSize,
        margin: const EdgeInsets.symmetric(vertical: 32),
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
            width: imageSize,
            height: imageSize,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // 画像が読み込めない場合のフォールバック
              return Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.games,
                  size: imageSize * 0.5,
                  color: Colors.orange,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// ページのデコレーションを作成
  PageDecoration _buildPageDecoration(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: screenWidth * 0.065,
        fontWeight: FontWeight.bold,
        color: Colors.orange.shade800,
        height: 1.3,
      ),
      bodyTextStyle: TextStyle(
        fontSize: screenWidth * 0.045,
        color: Colors.orange.shade700,
        height: 1.6,
      ),
      contentMargin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.08,
        vertical: 24,
      ),
      imagePadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.1,
        vertical: 32,
      ),
    );
  }

  /// オンボーディング完了時の処理
  Future<void> _completeOnboarding(BuildContext context, WidgetRef ref) async {
    final viewModel = ref.read(onboardingViewModelProvider.notifier);
    await viewModel.completeOnboarding();

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const StartPage()),
      );
    }
  }
}
