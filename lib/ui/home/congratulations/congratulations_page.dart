import 'package:flutter/material.dart';

import 'package:katakanahanashi/ui/home/ad/ad_display_page.dart';
import 'package:lottie/lottie.dart';

class CongratulationsPage extends StatefulWidget {
  const CongratulationsPage({super.key});

  @override
  State<CongratulationsPage> createState() => _CongratulationsPageState();
}

class _CongratulationsPageState extends State<CongratulationsPage>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  late final AnimationController _lottieController; // 追加: Lottie用

  late final Widget _congratsLottie;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 10000),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ).drive(Tween(begin: 0.3, end: 2.0));

    _lottieController = AnimationController(vsync: this);

    _congratsLottie = LottieBuilder.asset(
      'assets/animations/Congratulations.json',
      controller: _lottieController,
      fit: BoxFit.contain, // 明示しておくと安心
      onLoaded: (composition) {
        _lottieController
          ..duration = composition.duration
          ..repeat(); // repeat()メソッドを使用
        if (!_scaleController.isAnimating && _scaleController.value == 0.0) {
          _scaleController.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final baseWidth = size.width * 0.45;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.orange.shade50,
        body: Stack(
          clipBehavior: Clip.none, // クリップしない
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
                  scale: _scaleAnimation,
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.red),
                    ),
                    child: SizedBox(width: baseWidth, child: _congratsLottie),
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
