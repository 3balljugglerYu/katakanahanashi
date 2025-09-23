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
    // リソース初期化（状態変更なし）
    _viewModel.initialize(this);
    // 遷移完了検知でアニメーション開始
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waitForTransitionComplete();
    });
  }

  /// 画面遷移完了を検知してアニメーション開始
  void _waitForTransitionComplete() {
    final route = ModalRoute.of(context);

    if (route?.animation?.status == AnimationStatus.completed) {
      // 既に遷移完了済み - 即座に開始
      _viewModel.startInitializationImmediately();
    } else {
      // 遷移完了を待機
      void statusListener(AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          route?.animation?.removeStatusListener(statusListener);
          _viewModel.startInitializationImmediately();
        }
      }

      route?.animation?.addStatusListener(statusListener);

      // フォールバック: 最大1秒待機後に強制開始
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (route?.animation?.status != AnimationStatus.completed) {
          route?.animation?.removeStatusListener(statusListener);
          _viewModel.startInitializationImmediately();
        }
      });
    }
  }

  @override
  void dispose() {
    // 画面破棄時に状態とリソースをリセット
    _viewModel.resetForDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // StateNotifierの状態を監視
    final state = ref.watch(congratulationsViewModelProvider);
    final resources = ref.watch(congratulationsResourcesProvider);

    if (resources == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
            // 背景：紙吹雪
            Positioned.fill(child: resources.confettiLottie),

            // 中央の Congratulations をシンプルに拡大
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

            // 画面の真ん中にロケット猫アニメーション（条件付きレンダリング）
            if (state.isRocketVisible)
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
