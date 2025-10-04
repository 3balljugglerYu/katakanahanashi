import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:katakanahanashi/ui/home/ad/ad_display_page.dart';
import 'congratulations_view_model.dart';
import 'congratulations_state.dart';

class CongratulationsPage extends ConsumerStatefulWidget {
  const CongratulationsPage({super.key});

  @override
  ConsumerState<CongratulationsPage> createState() =>
      _CongratulationsPageState();
}

class _CongratulationsPageState extends ConsumerState<CongratulationsPage>
    with TickerProviderStateMixin {
  late final CongratulationsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(congratulationsViewModelProvider.notifier);

    // 軽量初期化と遷移完了検知を遅延実行（Riverpodルール遵守）
    Future.microtask(() {
      // 軽量初期化（アニメーションコントローラーのみ）
      _viewModel.initializeLightweight(this);
      // 遷移完了検知でリソース読み込み開始
      _waitForTransitionComplete();
    });
  }

  /// 画面遷移完了を検知してリソース読み込みとアニメーション開始
  void _waitForTransitionComplete() {
    // マウント状態チェック
    if (!mounted) return;

    final route = ModalRoute.of(context);

    if (route?.animation?.status == AnimationStatus.completed) {
      // 既に遷移完了済み - 即座にリソース読み込み開始
      _startResourceLoadingAndAnimation();
    } else {
      // 遷移完了を待機
      void statusListener(AnimationStatus status) {
        if (!mounted) return;
        if (status == AnimationStatus.completed) {
          route?.animation?.removeStatusListener(statusListener);
          _startResourceLoadingAndAnimation();
        }
      }

      route?.animation?.addStatusListener(statusListener);

      // フォールバック: 最大1秒待機後に強制開始
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) return;
        if (route?.animation?.status != AnimationStatus.completed) {
          route?.animation?.removeStatusListener(statusListener);
          _startResourceLoadingAndAnimation();
        }
      });
    }
  }

  /// リソース読み込みとアニメーション開始
  void _startResourceLoadingAndAnimation() async {
    // マウント状態チェック
    if (!mounted) return;

    // 段階的リソース読み込み開始
    await _viewModel.loadResourcesGradually();

    // マウント状態再チェック（非同期処理後）
    if (!mounted) return;

    // 全リソース読み込み完了後にアニメーション開始
    _viewModel.startInitializationImmediately();
  }

  @override
  void dispose() {
    // 画面破棄時はリソースのみ即座に解放（状態変更は行わない）
    _viewModel.disposeResourcesOnly();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // StateNotifierの状態を監視
    final state = ref.watch(congratulationsViewModelProvider);
    final resources = ref.watch(congratulationsResourcesProvider);

    // 基本リソース（コントローラー）が未準備の場合はローディング表示
    // 段階的初期化では、isControllersReadyがtrueになればresourcesも利用可能になる
    if (!state.canShowBasicUI) {
      return Scaffold(
        backgroundColor: Colors.orange.shade50,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
              SizedBox(height: 16),
              Text(
                '準備中...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // resourcesがnullの場合のフォールバック（理論的には起こらないはず）
    if (resources == null) {
      return Scaffold(
        backgroundColor: Colors.orange.shade50,
        body: const Center(
          child: Text(
            'リソース読み込みエラー',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return _CongratulationsContent(state: state, resources: resources);
  }
}

class _CongratulationsContent extends StatelessWidget {
  final CongratulationsState state;
  final CongratulationsResources resources;

  const _CongratulationsContent({required this.state, required this.resources});

  /// タブレット判定メソッド
  bool _isTablet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return screenWidth >= 800 || screenHeight >= 1000;
  }

  /// レスポンシブ対応アニメーションサイズ取得
  double _getResponsiveAnimationSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (_isTablet(context)) {
      return screenWidth * 0.6; // タブレット: 画面幅の60%
    } else {
      return screenWidth * 0.9; // スマートフォン: 画面幅の90%
    }
  }

  /// レスポンシブ対応フォントサイズ取得
  double _getResponsiveFontSize(BuildContext context, double baseRatio) {
    return MediaQuery.of(context).size.width * baseRatio;
  }

  /// レスポンシブ対応パディング取得
  EdgeInsets _getResponsivePadding(
    BuildContext context, {
    double horizontalRatio = 0.04,
    double verticalRatio = 0.015,
  }) {
    return EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * horizontalRatio,
      vertical: MediaQuery.of(context).size.height * verticalRatio,
    );
  }

  /// レスポンシブ対応スペーシング取得
  double _getResponsiveSpacing(BuildContext context, double ratio) {
    return MediaQuery.of(context).size.height * ratio;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.orange.shade50,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            // 背景：紙吹雪（段階的表示）
            if (state.canShowConfetti)
              Positioned.fill(
                child: Center(
                  child: Transform.translate(
                    offset: Offset.zero, // 中央配置のためのTransform
                    child: resources.confettiLottie,
                  ),
                ),
              ),

            // 中央の Congratulations をシンプルに拡大（段階的表示）
            if (state.canShowCongrats)
              AnimatedBuilder(
                animation: resources.positionAnimation,
                builder: (context, child) {
                  return Positioned(
                    top:
                        size.height * resources.positionAnimation.value -
                        _getResponsiveSpacing(context, 0.0), // レスポンシブ対応の高さ補正
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ScaleTransition(
                        scale: resources.scaleAnimation,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: _getResponsiveAnimationSize(context),
                          child: FittedBox(
                            fit: BoxFit.scaleDown, // はみ出す時だけ縮小
                            child: DefaultTextStyle(
                              style: TextStyle(
                                fontSize: _getResponsiveFontSize(
                                  context,
                                  0.15,
                                ), // 基準サイズを大きく（15%）
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                              child: Text(
                                'Congratulations!',
                                maxLines: 1,
                                softWrap: false, // 改行しない
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            // 画面の真ん中にロケット猫アニメーション（段階的表示 + 条件付きレンダリング）
            if (state.canShowRocket)
              AnimatedBuilder(
                animation: resources.rocketPositionAnimation,
                builder: (context, child) {
                  final animationSize = _getResponsiveAnimationSize(context);
                  return Positioned(
                    top:
                        size.height *
                            resources.rocketPositionAnimation.value.dy -
                        animationSize / 2, // レスポンシブ対応の高さ補正
                    left:
                        size.width *
                            resources.rocketPositionAnimation.value.dx -
                        animationSize / 2, // ロケット猫の中心を画面中央に配置するための補正
                    child: SizedBox(
                      width: animationSize,
                      height: animationSize,
                      child: resources.rocketLottie,
                    ),
                  );
                },
              ),
            Positioned(
              bottom: _getResponsiveSpacing(
                context,
                0.12,
              ), // レスポンシブ対応のボトムスペーシング
              left: MediaQuery.of(context).size.width * 0.05, // レスポンシブ対応の左マージン
              right: MediaQuery.of(context).size.width * 0.05, // レスポンシブ対応の右マージン
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const AdDisplayPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: _getResponsivePadding(
                    context,
                    horizontalRatio: 0.08,
                    verticalRatio: 0.022,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      _isTablet(context) ? 48 : 36, // タブレット用の大きな角丸
                    ),
                  ),
                  elevation: 10,
                  shadowColor: Colors.orange.withOpacity(0.5),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(context, 0.045),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
