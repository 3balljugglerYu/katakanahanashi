import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_state.freezed.dart';

/// スプラッシュページの状態
@freezed
class SplashState with _$SplashState {
  const factory SplashState({
    @Default(true) bool isLoading,
    @Default(false) bool hasSeenOnboarding,
    String? errorMessage,
  }) = _SplashState;
}
