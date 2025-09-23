import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'congratulations_state.freezed.dart';

/// Congratulations画面の純粋な状態定義（Freezedで管理）
@freezed
class CongratulationsState with _$CongratulationsState {
  const factory CongratulationsState({
    @Default(false) bool isAnimationStarted,
    @Default(false) bool isScaleAnimating,
    @Default(false) bool isConfettiAnimating,
    @Default(0.0) double animationProgress,
  }) = _CongratulationsState;

  const CongratulationsState._();

  /// アニメーションが実行中かどうか
  bool get isAnimating => isScaleAnimating || isConfettiAnimating;

  /// アニメーションが初期状態かどうか
  bool get isInitialState => !isAnimationStarted;

  /// アニメーションをリセットできる状態かどうか
  bool get canReset => !isAnimating;

  /// アニメーションが完了したかどうか
  bool get isCompleted => animationProgress >= 1.0;
}

/// Congratulations画面のリソース管理クラス
class CongratulationsResources {
  final AnimationController scaleController;
  final Animation<double> scaleAnimation;
  final AnimationController lottieController;
  final Widget congratsLottie;
  final AnimationController confettiController;
  final Widget confettiLottie;
  final AnimationController rocketController;
  final Widget rocketLottie;

  const CongratulationsResources({
    required this.scaleController,
    required this.scaleAnimation,
    required this.lottieController,
    required this.congratsLottie,
    required this.confettiController,
    required this.confettiLottie,
    required this.rocketController,
    required this.rocketLottie,
  });

  /// リソースの解放
  void dispose() {
    scaleController.dispose();
    lottieController.dispose();
    confettiController.dispose();
    rocketController.dispose();
  }
}
