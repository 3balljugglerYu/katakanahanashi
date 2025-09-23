import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Lottieアニメーションのキャッシュ管理サービス
class LottieCacheService {
  static final LottieCacheService _instance = LottieCacheService._internal();
  factory LottieCacheService() => _instance;
  LottieCacheService._internal();

  // キャッシュされたLottieコンポジション
  final Map<String, LottieComposition> _cache = {};

  // プリロード対象のアセット一覧
  static const List<String> _preloadAssets = [
    'assets/animations/Congratulations.json',
    'assets/animations/confetti on transparent background.json',
    'assets/animations/Cat in a rocket.json',
  ];

  /// アプリ起動時のプリロード
  Future<void> preloadAssets() async {
    try {
      final futures = _preloadAssets.map((assetPath) async {
        final composition = await AssetLottie(assetPath).load();
        _cache[assetPath] = composition;
        return composition;
      }).toList();

      await Future.wait(futures);
      print('INFO: ${_cache.length} Lottie assets preloaded');
    } catch (e) {
      print('WARNING: Lottie preload failed: $e');
    }
  }

  /// キャッシュされたLottieBuilder取得
  Widget getCachedLottie(
    String assetPath, {
    AnimationController? controller,
    bool repeat = false,
    BoxFit fit = BoxFit.contain,
  }) {
    final cachedComposition = _cache[assetPath];

    if (cachedComposition != null) {
      // キャッシュヒット: 高速表示（compositionから直接作成）
      controller?.duration = cachedComposition.duration;
      return Lottie(
        composition: cachedComposition,
        controller: controller,
        repeat: repeat,
        fit: fit,
      );
    } else {
      // キャッシュミス: 通常読み込み（フォールバック）
      return LottieBuilder.asset(
        assetPath,
        controller: controller,
        repeat: repeat,
        fit: fit,
        onLoaded: (composition) {
          // 読み込み完了時にキャッシュに保存
          _cache[assetPath] = composition;
          controller?.duration = composition.duration;
        },
      );
    }
  }

  /// キャッシュクリア
  void clearCache() {
    _cache.clear();
  }

  /// キャッシュ状態確認
  bool isAssetCached(String assetPath) => _cache.containsKey(assetPath);

  /// キャッシュサイズ
  int get cacheSize => _cache.length;
}
