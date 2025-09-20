import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../navigator/app_router.dart';
import 'game_view_model.dart';
import 'widgets/rating_dialog.dart';
import 'widgets/completion_dialog.dart';

class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  // プラットフォーム別の広告ユニットIDを取得
  static String get _interstitialAdUnitId {
    if (Platform.isIOS) {
      // iOS
      // テスト用: 'ca-app-pub-3940256099942544/4411468910'
      // 本番用: 'ca-app-pub-2716829166250639/9936269880'
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      // Android
      // テスト用: 'ca-app-pub-3940256099942544/1033173712'
      // 本番用: 'ca-app-pub-2716829166250639/3387528627'
      return 'ca-app-pub-3940256099942544/1033173712';
    } else {
      // その他のプラットフォーム（テスト用）
      return 'ca-app-pub-3940256099942544/4411468910';
    }
  }
  
  // 事前読み込み用の広告インスタンス
  static InterstitialAd? _preloadedAd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameViewModelProvider);
    final gameViewModel = ref.read(gameViewModelProvider.notifier);

    // ローディング状態を表示
    if (gameState.isLoading || gameState.shuffledWords.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.orange.shade50,
        appBar: AppBar(
          title: const Text('カタカナハナシ'),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
              const SizedBox(height: 16),
              Text(
                'ゲームを準備中...',
                style: TextStyle(fontSize: 16, color: Colors.orange.shade700),
              ),
              if (gameState.errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          gameState.errorMessage!,
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // 安全にcurrentWordを取得
    if (gameState.shuffledWords.isEmpty ||
        gameState.currentQuestionIndex >= gameState.shuffledWords.length) {
      return Scaffold(
        backgroundColor: Colors.orange.shade50,
        appBar: AppBar(
          title: const Text('カタカナハナシ'),
          backgroundColor: Colors.orange,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('ゲームを準備しています...'),
            ],
          ),
        ),
      );
    }

    final currentWord = gameState.shuffledWords[gameState.currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text('カタカナハナシ'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.012,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Text(
                '🎯 問題 ${gameState.currentQuestionIndex + 1} / ${gameState.totalQuestions}',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  color: Colors.orange.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.075,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.orange.shade50],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: Colors.orange.shade200, width: 2),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('📝 ', style: TextStyle(fontSize: 20)),
                      Text(
                        'お題',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: MediaQuery.of(context).size.height * 0.018,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        currentWord.word,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.105,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.024),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.0375,
                      vertical: MediaQuery.of(context).size.height * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '📂 ${currentWord.category}',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.yellow.shade100, Colors.orange.shade100],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.shade300, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text('💡 ', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'カタカナを使わずに説明してください！',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            // メモ化されたボタンでパフォーマンス最適化
            SizedBox(
              width: double.infinity,
              child: _NextButton(
                isLastQuestion: gameViewModel.isLastQuestion,
                onPressed: () => _handleNext(context, ref, gameViewModel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context, GameViewModel gameViewModel) {
    // ゲーム終了処理を先に実行
    _proceedToGameEnd(gameViewModel);
    
    // 広告の事前読み込みを開始
    _preloadInterstitialAd();
    
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CompletionDialog(),
    );
  }
  
  static void _preloadInterstitialAd() {
    print("広告の事前読み込みを開始します");
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print("広告の事前読み込みが完了しました");
          _preloadedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print("広告の事前読み込みに失敗しました: ${error.message}");
          _preloadedAd = null;
        },
      ),
    );
  }
  
  // 事前読み込み済み広告を取得するメソッド
  static InterstitialAd? getPreloadedAd() {
    final ad = _preloadedAd;
    _preloadedAd = null; // 使用後はクリア
    return ad;
  }
  
  void _proceedToGameEnd(GameViewModel gameViewModel) {
    // 最後の問題の場合は、nextQuestion()を呼び出す
    // これにより最後のワードがSharedPreferencesに登録される
    gameViewModel.nextQuestion();

    // ゲーム終了後のリセット判定と実行（非同期で実行）
    gameViewModel.checkAndResetIfNeeded().then((wasReset) {
      if (wasReset) {
        print("GameViewModel - Reset executed after game completion");
      }
    });
  }

  void _showInterstitialAd(BuildContext context, VoidCallback onAdClosed) {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // 広告のコールバックを先に設定
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              print("広告が終了されました");
              ad.dispose();
              // 広告終了時はコールバックを呼ばない（既にトップ画面に遷移済み）
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              print("広告表示に失敗しました: ${error.message}");
              ad.dispose();
              onAdClosed();
            },
            onAdShowedFullScreenContent: (InterstitialAd ad) {
              print("広告が表示されました");
              // 少し遅延してからトップ画面に遷移
              Future.delayed(const Duration(milliseconds: 100), () {
                onAdClosed();
              });
            },
          );
          // コールバック設定後に広告を表示
          ad.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print("広告読み込みに失敗しました: ${error.message}");
          // 広告読み込み失敗時はコールバックを実行
          onAdClosed();
        },
      ),
    );
  }

  void _proceedToNext(BuildContext context, GameViewModel gameViewModel) {
    print("_proceedToNext called. isLastQuestion: ${gameViewModel.isLastQuestion}");
    
    // 10問目の場合のみトップ画面に戻る
    if (gameViewModel.isLastQuestion) {
      // 最後の問題の場合は、nextQuestion()を呼び出してからトップ画面に戻る
      // これにより最後のワードがSharedPreferencesに登録される
      gameViewModel.nextQuestion();

      // ゲーム終了後のリセット判定と実行（非同期で実行）
      gameViewModel.checkAndResetIfNeeded().then((wasReset) {
        if (wasReset) {
          print("GameViewModel - Reset executed after game completion");
        }
      });

      if (context.mounted) {
        print("Navigating to start route");
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.startRoute,
          (route) => false,
        );
      } else {
        print("Context not mounted, cannot navigate");
      }
    } else {
      // 1〜9問目の場合は次の問題に進む
      print("Moving to next question");
      gameViewModel.nextQuestion();
    }
  }

  void _handleNext(
    BuildContext context,
    WidgetRef ref,
    GameViewModel gameViewModel,
  ) {
    final currentWord = gameViewModel.currentWord;

    // 評価ダイアログを表示
    final gameState = ref.read(gameViewModelProvider);
    final isLastQuestion = gameState.currentQuestionIndex == 9;
    
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => RatingDialog(
        word: currentWord,
        onSubmit: (rating) async {
          // ローディングダイアログを表示
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('評価を送信中...'),
                    ],
                  ),
                ),
              ),
            ),
          );

          // 評価を送信
          final result = await gameViewModel.submitRating(rating);

          // ローディングダイアログを閉じる
          if (context.mounted) {
            Navigator.of(context).pop();
          }

          // 10問目の場合は完了ダイアログを表示
          if (isLastQuestion) {
            _showCompletionDialog(context, gameViewModel);
          } else {
            _proceedToNext(context, gameViewModel);
          }
        },
      ),
    );
  }
}

// パフォーマンス最適化のためのメモ化されたボタンウィジェット
class _NextButton extends StatelessWidget {
  final bool isLastQuestion;
  final VoidCallback onPressed;

  const _NextButton({required this.isLastQuestion, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isLastQuestion ? Colors.red : Colors.orange,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.022,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 8,
        shadowColor: isLastQuestion
            ? Colors.red.withValues(alpha: 0.4)
            : Colors.orange.withValues(alpha: 0.4),
      ),
      child: Text(
        isLastQuestion ? '🏁 終了' : '次へ',
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.055,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
