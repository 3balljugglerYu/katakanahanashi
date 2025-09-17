import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/services/onboarding_service.dart';
import 'onboarding_state.dart';

/// オンボーディングページのViewModelプロバイダー
final onboardingViewModelProvider =
    StateNotifierProvider<OnboardingViewModel, OnboardingState>(
      (ref) => OnboardingViewModel(),
    );

/// オンボーディングページのViewModel
class OnboardingViewModel extends StateNotifier<OnboardingState> {
  OnboardingViewModel() : super(const OnboardingState());

  /// ページインデックスを更新
  void updatePageIndex(int index) {
    state = state.copyWith(currentPageIndex: index);
  }

  /// オンボーディング完了処理
  Future<void> completeOnboarding() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await OnboardingService.setOnboardingSeen();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'オンボーディング完了処理でエラーが発生しました: $e',
      );
    }
  }

  /// オンボーディングスキップ処理
  Future<void> skipOnboarding() async {
    await completeOnboarding();
  }
}
