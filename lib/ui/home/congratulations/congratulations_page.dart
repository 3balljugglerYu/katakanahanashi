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
    // 遅延実行でアニメーション開始
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.startInitialization();
    });
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
                  top: size.height * resources.positionAnimation.value,
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

            // 画面の真ん中にロケット猫アニメーション
            AnimatedBuilder(
              animation: resources.rocketPositionAnimation,
              builder: (context, child) {
                return Positioned(
                  top: size.height * resources.rocketPositionAnimation.value.dy,
                  left: size.width * resources.rocketPositionAnimation.value.dx,
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
