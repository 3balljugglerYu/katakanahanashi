import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:katakanahanashi/ui/home/start/start_page.dart';

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
        body:
            "カタカナ禁止のことば遊びゲームです。\n\n遊びながら日本語の言い換え力を鍛えましょう！",
        image: _buildImageWidget(
          context,
          imagePath: 'assets/images/tutorial_1.png',
          semanticsLabel: "カタカナ禁止ルールの説明イラスト",
        ),
        decoration: _buildPageDecoration(context),
      ),

      // 2ページ目: ゲームの遊び方
      PageViewModel(
        title: "ルールは『カタカナ禁止』",
        body:
        "出題者が「お題」を確認し、カタカナを使わずに説明しましょう。\n\n"
            "『パン』→「小麦で作られた主食の...」\n\n"
            "回答者が正解したら[次へ]をタップ！",
        image: _buildImageWidget(
          context,
          imagePath: 'assets/images/tutorial_2.png',
          semanticsLabel: "カタカナ禁止ルールの説明イラスト",
        ),
        decoration: _buildPageDecoration(context),
      ),

      // 3ページ目: 楽しみ方
      PageViewModel(
        title: "評価して次の「お題」へ！",
        body:
            "評価をつけて、[決定]をタップすると次のお題に進みます！\n"
            "評価は、このアプリをより良くする為に利用させて頂きます。",
        image: _buildImageWidget(
          context,
          imagePath: 'assets/images/tutorial_3.png',
          semanticsLabel: "説明を聞いて答えを当てる場面のイラスト",
        ),
        decoration: _buildPageDecoration(context),
      ),

      // 4ページ目: 楽しみ方
      PageViewModel(
        title: "待ち時間に最適 ♪",
        body:
            "ドライブやお散歩、ちょっとした待ち時間などに、遊んでみて下さいね！\n\nきっと盛り上がりますよ♪",
        image: _buildImageWidget(
          context,
          imagePath: 'assets/images/tutorial_4.png',
          semanticsLabel: "複数人で遊び、難易度を評価するイラスト",
        ),
        decoration: _buildPageDecoration(context),
      ),
    ];
  }

  /// 画像ウィジェットを作成
  Widget _buildImageWidget(
    BuildContext context, {
    String? imagePath,
    required String semanticsLabel,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    // デバイスサイズに応じた動的調整
    double imageRatio;
    if (screenWidth > 600) {
      // タブレット: 30%
      imageRatio = 0.6;
    } else if (screenWidth > 400) {
      // 大きめのスマホ: 35%
      imageRatio = 0.65;
    } else {
      // 小さめのスマホ: 40%
      imageRatio = 0.70;
    }

    final imageWidth = screenWidth * imageRatio;

    return Semantics(
      label: semanticsLabel,
      child: Column(
        children: [
          const SizedBox(height: 100),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: imageWidth,
              // 高さは親（IntroductionScreenのimageFlex）に委ねる
              margin: EdgeInsets.zero,
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
                  imagePath ?? 'assets/icon/app_icon.png',
                  width: imageWidth,
                  // 高さは制約に合わせて自動調整
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // 画像が読み込めない場合のフォールバック
                    return Container(
                      width: imageWidth,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        Icons.games,
                        size: imageWidth * 0.5,
                        color: Colors.orange,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
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
        fontWeight: FontWeight.bold,
        color: Colors.orange.shade500,
        height: 1.6,
      ),
      // 画面全体を使用し、image領域がflexで60%程度になるよう調整
      fullScreen: true,
      imageFlex: 6,
      bodyFlex: 4,
      contentMargin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.08,
        vertical: 12,
      ),
      imagePadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.1,
        vertical: 0,
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
