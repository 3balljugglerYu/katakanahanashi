import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:katakanahanashi/ui/home/ad/ad_display_page.dart';
import 'package:lottie/lottie.dart';
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
  late final CongratulationsState _state;

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(congratulationsViewModelProvider);
    _state = _viewModel.initialize(this);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _CongratulationsContent(state: _state);
  }
}

class _CongratulationsContent extends StatelessWidget {
  final CongratulationsState state;

  const _CongratulationsContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final baseWidth = size.width * 0.45;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.orange.shade50,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            // 背景：紙吹雪
            Positioned.fill(
              child: Lottie.asset(
                'assets/animations/confetti on transparent background.json',
                repeat: false,
                fit: BoxFit.cover,
              ),
            ),

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
