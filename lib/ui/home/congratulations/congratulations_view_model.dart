import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'congratulations_state.dart';

/// Congratulations画面のViewModel（Provider）
final congratulationsViewModelProvider =
    StateNotifierProvider<CongratulationsViewModel, CongratulationsState?>((
      ref,
    ) {
      return CongratulationsViewModel();
    });

/// Congratulations画面のビジネスロジックを管理
class CongratulationsViewModel extends StateNotifier<CongratulationsState?> {
  CongratulationsViewModel() : super(null);

  /// 初期化
  CongratulationsState initialize(TickerProvider vsync) {
    // 既に初期化済みの場合は、アニメーションをリセットしてから返す
    if (state != null) {
      resetAnimations();
      return state!;
    }

    // スケールアニメーションコントローラー
    final scaleController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: vsync,
    );

    // スケールアニメーション
    final scaleAnimation = CurvedAnimation(
      parent: scaleController,
      curve: Curves.elasticOut,
    ).drive(Tween(begin: 0.3, end: 1.0));

    // Lottieコントローラー
    final lottieController = AnimationController(vsync: vsync);
    final confettiController = AnimationController(vsync: vsync);

    // Congratulations Lottieアニメーション
    final congratsLottie = LottieBuilder.asset(
      'assets/animations/Congratulations.json',
      controller: lottieController,
      fit: BoxFit.contain,
      onLoaded: (composition) {
        lottieController
          ..duration = composition.duration
          ..repeat();

        // スケールアニメーションは遅延開始（画面遷移完了後0.4秒）
        // ここでは開始しない
      },
    );

    // 背景紙吹雪 Lottieアニメーション
    final confettiLottie = LottieBuilder.asset(
      'assets/animations/confetti on transparent background.json',
      controller: confettiController,
      repeat: false,
      fit: BoxFit.cover,
      onLoaded: (composition) {
        confettiController..duration = composition.duration;
        // 遅延開始は後で設定
      },
    );

    // 状態を作成してStateNotifierで管理
    state = CongratulationsState(
      scaleController: scaleController,
      scaleAnimation: scaleAnimation,
      lottieController: lottieController,
      congratsLottie: congratsLottie,
      confettiController: confettiController,
      confettiLottie: confettiLottie,
    );

    // 画面遷移完了後4秒後にアニメーション開始
    _startAnimationsWithDelay();

    return state!;
  }

  /// アニメーションを遅延開始
  void _startAnimationsWithDelay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 4000), () {
        if (state != null && state!.canReset) {
          startAnimations();
        }
      });
    });
  }

  /// アニメーションを開始
  void startAnimations() {
    if (state == null) return;

    // 状態を更新：アニメーション開始フラグをON
    state = state!.copyWith(
      isAnimationStarted: true,
      isScaleAnimating: true,
      isConfettiAnimating: true,
    );

    // スケールアニメーション開始
    if (!state!.scaleController.isAnimating) {
      state!.scaleController.forward();
    }

    // 紙吹雪アニメーション開始
    if (!state!.confettiController.isAnimating) {
      state!.confettiController.forward();
    }
  }

  /// アニメーションをリセット
  void resetAnimations() {
    if (state == null) return;

    // アニメーションコントローラーをリセット
    state!.scaleController.reset();
    state!.confettiController.reset();

    // 状態を更新：リセット状態に
    state = state!.copyWith(
      isAnimationStarted: false,
      isScaleAnimating: false,
      isConfettiAnimating: false,
      animationProgress: 0.0,
    );

    // 遅延してアニメーション開始
    _startAnimationsWithDelay();
  }

  /// アニメーション完了時の処理
  void onAnimationComplete() {
    if (state == null) return;

    state = state!.copyWith(
      isScaleAnimating: false,
      isConfettiAnimating: false,
      animationProgress: 1.0,
    );
  }

  /// リソースの解放
  @override
  void dispose() {
    state?.dispose();
    super.dispose();
  }
}
