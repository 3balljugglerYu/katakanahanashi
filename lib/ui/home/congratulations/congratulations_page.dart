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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final baseWidth = size.width;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.orange.shade50,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            // 背景：紙吹雪（段階的表示）
            if (state.canShowConfetti)
              Positioned.fill(child: resources.confettiLottie),

            // 中央の Congratulations をシンプルに拡大（段階的表示）
            if (state.canShowCongrats)
              AnimatedBuilder(
                animation: resources.positionAnimation,
                builder: (context, child) {
                  return Positioned(
                    top:
                        size.height * resources.positionAnimation.value -
                        100, // 高さの半分を補正
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ScaleTransition(
                        scale: resources.scaleAnimation,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: baseWidth,
                          child: resources.congratsLottie,
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
                  return Positioned(
                    top:
                        size.height *
                            resources.rocketPositionAnimation.value.dy -
                        200, // 400pxの半分を引く
                    left:
                        size.width * resources.rocketPositionAnimation.value.dx,
                    child: SizedBox(
                      width: 400,
                      height: 400,
                      child: resources.rocketLottie,
                    ),
                  );
                },
              ),
            Positioned(
              bottom: 100,
              left: 24,
              right: 24,
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
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36),
                  ),
                  elevation: 10,
                  shadowColor: Colors.orange.withOpacity(0.5),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
