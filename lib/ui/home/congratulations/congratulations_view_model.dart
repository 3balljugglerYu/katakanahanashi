import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'congratulations_state.dart';

/// Congratulations画面のViewModel（Provider）
final congratulationsViewModelProvider =
    StateNotifierProvider<CongratulationsViewModel, CongratulationsState>((
      ref,
    ) {
      return CongratulationsViewModel();
    });

/// Congratulations画面のリソース管理Provider
final congratulationsResourcesProvider = Provider<CongratulationsResources?>((
  ref,
) {
  final viewModel = ref.watch(congratulationsViewModelProvider.notifier);
  return viewModel.resources;
});

/// 初期化専用のProvider
final congratulationsInitializerProvider = Provider<void>((ref) {
  // このProviderは初期化のトリガーとして使用
});

/// Congratulations画面のビジネスロジックを管理
class CongratulationsViewModel extends StateNotifier<CongratulationsState> {
  CongratulationsResources? _resources;

  CongratulationsViewModel() : super(const CongratulationsState());

  /// リソースを取得
  CongratulationsResources? get resources => _resources;

  /// 初期化（リソース作成のみ）
  CongratulationsResources initialize(TickerProvider vsync) {
    // 既に初期化済みの場合は既存のリソースを返す
    if (_resources != null) {
      return _resources!;
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

    // 位置移動アニメーション（2秒後に上に移動）
    final positionController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    );
    final positionAnimation =
        Tween<double>(
          begin: 0.40, // 画面の40%の位置
          end: 0.2, // 画面の20%の位置
        ).animate(
          CurvedAnimation(parent: positionController, curve: Curves.easeInOut),
        );

    // ロケット猫の飛び込みアニメーション（2秒後に左下から右上へ）
    final rocketPositionController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    );
    final rocketPositionAnimation =
        Tween<Offset>(
          begin: const Offset(-1.0, 0.8), // 画面外左下（-100%, 120%）
          end: const Offset(0.0, 0.5), // 画面中央（0%, 50%）
        ).animate(
          CurvedAnimation(
            parent: rocketPositionController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Lottieコントローラー
    final lottieController = AnimationController(vsync: vsync);
    final confettiController = AnimationController(vsync: vsync);
    final rocketController = AnimationController(vsync: vsync);

    // Congratulations Lottieアニメーション
    final congratsLottie = LottieBuilder.asset(
      'assets/animations/Congratulations.json',
      controller: lottieController,
      repeat: false, // 自動再生しない
      fit: BoxFit.contain,
      onLoaded: (composition) {
        lottieController.duration = composition.duration;
        // 遅延開始は後で設定
      },
    );

    // 背景紙吹雪 Lottieアニメーション
    final confettiLottie = LottieBuilder.asset(
      'assets/animations/confetti on transparent background.json',
      controller: confettiController,
      repeat: false,
      fit: BoxFit.cover,
      onLoaded: (composition) {
        confettiController.duration = composition.duration;
        // 遅延開始は後で設定
      },
    );

    // ロケット猫 Lottieアニメーション
    final rocketLottie = LottieBuilder.asset(
      'assets/animations/Cat in a rocket.json',
      controller: rocketController,
      repeat: false,
      fit: BoxFit.contain,
      onLoaded: (composition) {
        rocketController.duration = composition.duration;
        // 遅延開始は後で設定
      },
    );

    // リソースを作成
    _resources = CongratulationsResources(
      scaleController: scaleController,
      scaleAnimation: scaleAnimation,
      positionController: positionController,
      positionAnimation: positionAnimation,
      rocketPositionController: rocketPositionController,
      rocketPositionAnimation: rocketPositionAnimation,
      lottieController: lottieController,
      congratsLottie: congratsLottie,
      confettiController: confettiController,
      confettiLottie: confettiLottie,
      rocketController: rocketController,
      rocketLottie: rocketLottie,
    );

    return _resources!;
  }

  /// アニメーション開始（初期化後）
  void startInitialization() {
    if (_resources == null) return;

    // 既に初期化済みの場合はリセット
    if (state.isAnimationStarted) {
      resetAnimations();
    } else {
      // 初回の場合は遅延開始
      _startAnimationsWithDelay();
    }
  }

  /// アニメーションを遅延開始
  void _startAnimationsWithDelay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (_resources != null && state.canReset) {
          startAnimations();
        }
      });
    });
  }

  /// アニメーションを開始
  void startAnimations() {
    if (_resources == null) return;

    // 状態を更新：アニメーション開始フラグをON
    state = state.copyWith(
      isAnimationStarted: true,
      isScaleAnimating: true,
      isConfettiAnimating: true,
    );

    // スケールアニメーション開始
    if (!_resources!.scaleController.isAnimating) {
      _resources!.scaleController.forward();
    }

    // Congratulations Lottieアニメーション開始
    if (!_resources!.lottieController.isAnimating) {
      _resources!.lottieController.repeat();
    }

    // 紙吹雪アニメーション開始
    if (!_resources!.confettiController.isAnimating) {
      _resources!.confettiController.forward();
    }

    // ロケット猫アニメーション開始
    if (!_resources!.rocketController.isAnimating) {
      _resources!.rocketController.repeat();
    }

    // 2秒後に位置移動アニメーション開始
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (_resources != null && !_resources!.positionController.isAnimating) {
        _resources!.positionController.forward();
      }
    });

    // 2秒後にロケット猫の飛び込みアニメーション開始
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (_resources != null &&
          !_resources!.rocketPositionController.isAnimating) {
        _resources!.rocketPositionController.forward();
      }
    });
  }

  /// アニメーションをリセット
  void resetAnimations() {
    if (_resources == null) return;

    // アニメーションコントローラーをリセット
    _resources!.scaleController.reset();
    _resources!.positionController.reset();
    _resources!.rocketPositionController.reset();
    _resources!.lottieController.stop();
    _resources!.confettiController.reset();
    _resources!.rocketController.reset();

    // 状態を更新：リセット状態に
    state = state.copyWith(
      isAnimationStarted: false,
      isScaleAnimating: false,
      isConfettiAnimating: false,
      animationProgress: 0.0,
    );

    // 遅延してアニメーション開始
    _startAnimationsWithDelay();
  }

  /// アニメーション進行状況を更新
  void updateAnimationProgress(double progress) {
    state = state.copyWith(animationProgress: progress);
  }

  /// アニメーション完了時の処理
  void onAnimationComplete() {
    state = state.copyWith(
      isScaleAnimating: false,
      isConfettiAnimating: false,
      animationProgress: 1.0,
    );
  }

  /// リソースの解放
  @override
  void dispose() {
    _resources?.dispose();
    super.dispose();
  }
}
