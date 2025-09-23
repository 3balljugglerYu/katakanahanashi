import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'congratulations_state.dart';

/// Congratulations画面のViewModel（Provider）
final congratulationsViewModelProvider = Provider<CongratulationsViewModel>((
  ref,
) {
  return CongratulationsViewModel();
});

/// Congratulations画面のビジネスロジックを管理
class CongratulationsViewModel {
  CongratulationsState? _state;

  /// 初期化
  CongratulationsState initialize(TickerProvider vsync) {
    // 既に初期化済みの場合は既存の状態を返す
    if (_state != null) return _state!;

    // スケールアニメーションコントローラー
    final scaleController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: vsync,
    );

    // スケールアニメーション
    final scaleAnimation = CurvedAnimation(
      parent: scaleController,
      curve: Curves.elasticOut,
    ).drive(Tween(begin: 0.3, end: 2.0));

    // Lottieコントローラー
    final lottieController = AnimationController(vsync: vsync);

    // Congratulations Lottieアニメーション
    final congratsLottie = LottieBuilder.asset(
      'assets/animations/Congratulations.json',
      controller: lottieController,
      fit: BoxFit.contain,
      onLoaded: (composition) {
        lottieController
          ..duration = composition.duration
          ..repeat();

        // スケールアニメーションを開始
        if (!scaleController.isAnimating && scaleController.value == 0.0) {
          scaleController.forward();
        }
      },
    );

    // 状態を作成
    _state = CongratulationsState(
      scaleController: scaleController,
      scaleAnimation: scaleAnimation,
      lottieController: lottieController,
      congratsLottie: congratsLottie,
    );

    // スケールアニメーションを即座に開始
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scaleController.isAnimating && scaleController.value == 0.0) {
        scaleController.forward();
      }
    });

    return _state!;
  }

  /// 状態を取得
  CongratulationsState? get state => _state;

  /// リソースの解放
  void dispose() {
    _state?.dispose();
  }
}
