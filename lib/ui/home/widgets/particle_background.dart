import 'package:flutter/material.dart';
import 'package:particles_flutter/particles_engine.dart';
import 'package:particles_flutter/component/particle/particle.dart';
import 'dart:math';

/// オレンジを基調としたパーティクルアニメーション背景ウィジェット
class ParticleBackground extends StatelessWidget {
  /// パーティクルの数（デフォルト: 50）
  final int particleCount;

  /// タップアニメーションの有効化（デフォルト: true）
  final bool onTapAnimation;

  /// ホバー効果の有効化（デフォルト: false）
  final bool enableHover;

  /// パーティクル同士を線で接続するかどうか（デフォルト: false）
  final bool connectDots;

  /// パーティクルが離れる半径（デフォルト: 100）
  final double awayRadius;

  /// ホバー効果の半径（デフォルト: 80）
  final double hoverRadius;

  const ParticleBackground({
    super.key,
    this.particleCount = 50,
    this.onTapAnimation = true,
    this.enableHover = false,
    this.connectDots = false,
    this.awayRadius = 100,
    this.hoverRadius = 80,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Particles(
      awayRadius: awayRadius,
      particles: _createOrangeParticles(),
      height: screenHeight,
      width: screenWidth,
      onTapAnimation: onTapAnimation,
      awayAnimationDuration: const Duration(milliseconds: 200),
      awayAnimationCurve: Curves.easeOut,
      enableHover: enableHover,
      hoverRadius: hoverRadius,
      connectDots: connectDots,
    );
  }

  /// オレンジを基調としたパーティクルを作成
  List<Particle> _createOrangeParticles() {
    final rng = Random();
    List<Particle> particles = [];

    // オレンジ系の色を定義
    final orangeColors = [
      Colors.orange.withValues(alpha: 0.6),
      Colors.orange.shade300.withValues(alpha: 0.5),
      Colors.orange.shade500.withValues(alpha: 0.4),
      Colors.deepOrange.shade400.withValues(alpha: 0.5),
      Colors.amber.shade400.withValues(alpha: 0.4),
    ];

    // 指定された数のパーティクルを作成
    for (int i = 0; i < particleCount; i++) {
      particles.add(
        Particle(
          color: orangeColors[rng.nextInt(orangeColors.length)],
          size: rng.nextDouble() * 20 + 10, // 10-30のサイズ
          velocity: Offset(
            rng.nextDouble() * 50 * _randomSign(), // -25 to 25の速度
            rng.nextDouble() * 50 * _randomSign(),
          ),
        ),
      );
    }
    return particles;
  }

  /// ランダムに正負の符号を返す
  double _randomSign() {
    final rng = Random();
    return rng.nextBool() ? 1 : -1;
  }
}
