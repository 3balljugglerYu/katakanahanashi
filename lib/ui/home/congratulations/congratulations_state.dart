import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'congratulations_state.freezed.dart';

/// Congratulations画面の状態定義
@freezed
class CongratulationsState with _$CongratulationsState {
  const factory CongratulationsState({
    required AnimationController scaleController,
    required Animation<double> scaleAnimation,
    required AnimationController lottieController,
    required Widget congratsLottie,
    required AnimationController confettiController,
    required Widget confettiLottie,
    @Default(false) bool isAnimationStarted,
    @Default(false) bool isScaleAnimating,
    @Default(false) bool isConfettiAnimating,
    @Default(0.0) double animationProgress,
  }) = _CongratulationsState;

  const CongratulationsState._();

  /// アニメーションが実行中かどうか
  bool get isAnimating => isScaleAnimating || isConfettiAnimating;

  /// スケールアニメーションの現在値
  double get scaleValue => scaleAnimation.value;

  /// アニメーションが初期状態かどうか
  bool get isInitialState => !isAnimationStarted;

  /// アニメーションをリセットできる状態かどうか
  bool get canReset => !isAnimating;

  /// リソースの解放
  void dispose() {
    scaleController.dispose();
    lottieController.dispose();
    confettiController.dispose();
  }
}
