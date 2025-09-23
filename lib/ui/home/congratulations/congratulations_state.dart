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
  }) = _CongratulationsState;

  const CongratulationsState._();

  /// アニメーションが実行中かどうか
  bool get isAnimating => scaleController.isAnimating;

  /// スケールアニメーションの現在値
  double get scaleValue => scaleAnimation.value;

  /// アニメーションが初期状態（0.0）かどうか
  bool get isInitialState => scaleController.value == 0.0;

  /// リソースの解放
  void dispose() {
    scaleController.dispose();
    lottieController.dispose();
  }
}
