import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../data/services/lottie_cache_service.dart';
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
  // StateNotifierの状態変化を監視してProviderを再評価
  ref.watch(congratulationsViewModelProvider);
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

  /// 軽量初期化（アニメーションコントローラーのみ作成）
  void initializeLightweight(TickerProvider vsync) {
    // 初期化時に状態を完全にリセット（2回目以降の表示対応）
    _forceResetState();

    // 既に初期化済みの場合は早期リターン
    if (_resources != null) {
      state = state.copyWith(isControllersReady: true);
      return;
    }

    // 軽量リソース（アニメーションコントローラー）のみ作成
    _createControllers(vsync);

    // コントローラー準備完了を通知
    state = state.copyWith(isControllersReady: true);
  }

  /// 従来の初期化（後方互換性のため保持）
  CongratulationsResources initialize(TickerProvider vsync) {
    // 初期化時に状態を完全にリセット（2回目以降の表示対応）
    _forceResetState();

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
          end: const Offset(0.5, 0.5), // 画面中央（50%, 50%）
        ).animate(
          CurvedAnimation(
            parent: rocketPositionController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Lottieコントローラー（初期durationを設定してrepeat()エラーを防止）
    final lottieController = AnimationController(
      duration: const Duration(seconds: 3), // デフォルト値（onLoadedで上書き）
      vsync: vsync,
    );
    final confettiController = AnimationController(
      duration: const Duration(seconds: 2), // デフォルト値（onLoadedで上書き）
      vsync: vsync,
    );
    final rocketController = AnimationController(
      duration: const Duration(seconds: 2), // デフォルト値（onLoadedで上書き）
      vsync: vsync,
    );

    // Congratulations Lottieアニメーション（キャッシュサービス使用）
    final congratsLottie = LottieCacheService().getCachedLottie(
      'assets/animations/Congratulations.json',
      controller: lottieController,
      repeat: false, // 自動再生しない
      fit: BoxFit.contain,
    );

    // 背景紙吹雪 Lottieアニメーション（キャッシュサービス使用）
    final confettiLottie = LottieCacheService().getCachedLottie(
      'assets/animations/confetti on transparent background.json',
      controller: confettiController,
      repeat: false,
      fit: BoxFit.cover,
    );

    // ロケット猫 Lottieアニメーション（キャッシュサービス使用）
    final rocketLottie = LottieCacheService().getCachedLottie(
      'assets/animations/Cat in a rocket.json',
      controller: rocketController,
      repeat: false,
      fit: BoxFit.contain,
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

  /// アニメーションコントローラーのみ作成（軽量）
  void _createControllers(TickerProvider vsync) {
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
          end: const Offset(0.5, 0.5), // 画面中央（50%, 50%）
        ).animate(
          CurvedAnimation(
            parent: rocketPositionController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Lottieコントローラー（初期durationを設定してrepeat()エラーを防止）
    final lottieController = AnimationController(
      duration: const Duration(seconds: 3), // デフォルト値（onLoadedで上書き）
      vsync: vsync,
    );
    final confettiController = AnimationController(
      duration: const Duration(seconds: 2), // デフォルト値（onLoadedで上書き）
      vsync: vsync,
    );
    final rocketController = AnimationController(
      duration: const Duration(seconds: 2), // デフォルト値（onLoadedで上書き）
      vsync: vsync,
    );

    // 仮のLottieウィジェット（後で段階的に差し替え）
    final placeholderWidget = Container();

    // 軽量リソースを作成（LottieはプレースホルダーでCPU負荷なし）
    _resources = CongratulationsResources(
      scaleController: scaleController,
      scaleAnimation: scaleAnimation,
      positionController: positionController,
      positionAnimation: positionAnimation,
      rocketPositionController: rocketPositionController,
      rocketPositionAnimation: rocketPositionAnimation,
      lottieController: lottieController,
      congratsLottie: placeholderWidget,
      confettiController: confettiController,
      confettiLottie: placeholderWidget,
      rocketController: rocketController,
      rocketLottie: placeholderWidget,
    );
  }

  /// 段階的リソース読み込み開始
  Future<void> loadResourcesGradually() async {
    if (_resources == null) return;

    // フェーズ1: Congratulations Lottie（最優先）
    await _loadCongratsLottie();

    // フェーズ2: 紙吹雪 Lottie（中優先）
    await Future.microtask(() => _loadConfettiLottie());

    // フェーズ3: ロケット猫 Lottie（低優先・遅延）
    await Future.microtask(() => _loadRocketLottie());
  }

  /// Congratulations Lottie読み込み
  Future<void> _loadCongratsLottie() async {
    if (_resources == null) return;

    await Future.microtask(() {
      // キャッシュサービスから高速取得
      final congratsLottie = LottieCacheService().getCachedLottie(
        'assets/animations/Congratulations.json',
        controller: _resources!.lottieController,
        repeat: false,
        fit: BoxFit.contain,
      );

      // リソースを更新
      _resources = CongratulationsResources(
        scaleController: _resources!.scaleController,
        scaleAnimation: _resources!.scaleAnimation,
        positionController: _resources!.positionController,
        positionAnimation: _resources!.positionAnimation,
        rocketPositionController: _resources!.rocketPositionController,
        rocketPositionAnimation: _resources!.rocketPositionAnimation,
        lottieController: _resources!.lottieController,
        congratsLottie: congratsLottie,
        confettiController: _resources!.confettiController,
        confettiLottie: _resources!.confettiLottie,
        rocketController: _resources!.rocketController,
        rocketLottie: _resources!.rocketLottie,
      );

      state = state.copyWith(isCongratsReady: true);
    });
  }

  /// 紙吹雪 Lottie読み込み
  Future<void> _loadConfettiLottie() async {
    if (_resources == null) return;

    await Future.microtask(() {
      // キャッシュサービスから高速取得
      final confettiLottie = LottieCacheService().getCachedLottie(
        'assets/animations/confetti on transparent background.json',
        controller: _resources!.confettiController,
        repeat: false,
        fit: BoxFit.cover,
      );

      // リソースを更新
      _resources = CongratulationsResources(
        scaleController: _resources!.scaleController,
        scaleAnimation: _resources!.scaleAnimation,
        positionController: _resources!.positionController,
        positionAnimation: _resources!.positionAnimation,
        rocketPositionController: _resources!.rocketPositionController,
        rocketPositionAnimation: _resources!.rocketPositionAnimation,
        lottieController: _resources!.lottieController,
        congratsLottie: _resources!.congratsLottie,
        confettiController: _resources!.confettiController,
        confettiLottie: confettiLottie,
        rocketController: _resources!.rocketController,
        rocketLottie: _resources!.rocketLottie,
      );

      state = state.copyWith(isConfettiReady: true);
    });
  }

  /// ロケット猫 Lottie読み込み
  Future<void> _loadRocketLottie() async {
    if (_resources == null) return;

    await Future.microtask(() {
      // キャッシュサービスから高速取得
      final rocketLottie = LottieCacheService().getCachedLottie(
        'assets/animations/Cat in a rocket.json',
        controller: _resources!.rocketController,
        repeat: false,
        fit: BoxFit.contain,
      );

      // リソースを更新
      _resources = CongratulationsResources(
        scaleController: _resources!.scaleController,
        scaleAnimation: _resources!.scaleAnimation,
        positionController: _resources!.positionController,
        positionAnimation: _resources!.positionAnimation,
        rocketPositionController: _resources!.rocketPositionController,
        rocketPositionAnimation: _resources!.rocketPositionAnimation,
        lottieController: _resources!.lottieController,
        congratsLottie: _resources!.congratsLottie,
        confettiController: _resources!.confettiController,
        confettiLottie: _resources!.confettiLottie,
        rocketController: _resources!.rocketController,
        rocketLottie: rocketLottie,
      );

      state = state.copyWith(isRocketReady: true);
    });
  }

  /// アニメーション開始（初期化後）
  void startInitialization() {
    if (_resources == null) return;

    // 既に初期化済みの場合はリセット
    if (state.isAnimationStarted) {
      resetAnimations();
    } else {
      // 初回の場合は遅延開始（後方互換性のため残す）
      _startAnimationsWithDelay();
    }
  }

  /// アニメーション即座開始（遷移完了検知用）
  void startInitializationImmediately() {
    if (_resources == null) return;

    // 既に初期化済みの場合はリセット
    if (state.isAnimationStarted) {
      resetAnimations();
    } else {
      // 即座にアニメーション開始
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_resources != null && state.canReset) {
          startAnimations();
        }
      });
    }
  }

  /// アニメーションを遅延開始（後方互換性のため保持）
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

    // Congratulations Lottieアニメーション開始（durationチェック付き）
    if (!_resources!.lottieController.isAnimating &&
        _resources!.lottieController.duration != null) {
      _resources!.lottieController.repeat();
    }

    // 紙吹雪アニメーション開始
    if (!_resources!.confettiController.isAnimating) {
      _resources!.confettiController.forward();
    }

    // 2秒後に位置移動アニメーション開始
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (_resources != null && !_resources!.positionController.isAnimating) {
        _resources!.positionController.forward();
      }
    });

    // 1.8秒後にロケット猫を表示準備（条件付きレンダリング最適化）
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (_resources != null) {
        state = state.copyWith(isRocketVisible: true);
      }
    });

    // 2秒後にロケット猫の飛び込みアニメーション開始
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (_resources != null &&
          !_resources!.rocketPositionController.isAnimating) {
        // ロケット猫のアニメーションを開始
        _resources!.rocketPositionController.forward();
        // ロケット猫のLottieアニメーションも開始（遅延開始でリソース節約、durationチェック付き）
        if (!_resources!.rocketController.isAnimating &&
            _resources!.rocketController.duration != null) {
          _resources!.rocketController.repeat();
        }
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
      isRocketVisible: false,
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

  /// 画面破棄時の完全リセット（状態変更は遅延実行で安全に）
  void resetForDispose() {
    // リソースのみ即座に解放（状態変更なし）
    disposeResourcesOnly();

    // 状態リセットは遅延実行（Riverpodルール遵守）
    Future.microtask(() {
      _forceResetState();
    });
  }

  /// リソースのみ解放（状態変更なし）- 外部からも呼び出し可能
  void disposeResourcesOnly() {
    if (_resources != null) {
      // アニメーションを完全停止
      _resources!.scaleController.stop();
      _resources!.positionController.stop();
      _resources!.rocketPositionController.stop();
      _resources!.lottieController.stop();
      _resources!.confettiController.stop();
      _resources!.rocketController.stop();

      // アニメーションコントローラーをリセット
      _resources!.scaleController.reset();
      _resources!.positionController.reset();
      _resources!.rocketPositionController.reset();
      _resources!.lottieController.reset();
      _resources!.confettiController.reset();
      _resources!.rocketController.reset();
    }
  }

  /// 状態の強制リセット（内部用）
  void _forceResetState() {
    state = const CongratulationsState(
      isAnimationStarted: false,
      isScaleAnimating: false,
      isConfettiAnimating: false,
      isRocketVisible: false,
      animationProgress: 0.0,
      // 段階的初期化フィールドもリセット
      isControllersReady: false,
      isCongratsReady: false,
      isConfettiReady: false,
      isRocketReady: false,
    );
  }

  /// リソースの解放
  @override
  void dispose() {
    _resources?.dispose();
    super.dispose();
  }
}
