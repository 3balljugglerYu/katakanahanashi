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
  CongratulationsState? _initializedState;

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(congratulationsViewModelProvider.notifier);
    _initializedState = _viewModel.initialize(this);
  }

  @override
  Widget build(BuildContext context) {
    // StateNotifierの状態を監視
    final currentState = ref.watch(congratulationsViewModelProvider);
    final displayState = currentState ?? _initializedState;

    if (displayState == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return _CongratulationsContent(state: displayState);
  }
}

class _CongratulationsContent extends StatelessWidget {
  final CongratulationsState state;

  const _CongratulationsContent({required this.state});

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
            Positioned.fill(child: state.confettiLottie),

            // 中央の Congratulations をシンプルに拡大
            Positioned(
              top: size.height * 0.2,
              left: 0,
              right: 0,
              child: Center(
                child: ScaleTransition(
                  scale: state.scaleAnimation,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: baseWidth,
                    child: state.congratsLottie,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 48,
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
