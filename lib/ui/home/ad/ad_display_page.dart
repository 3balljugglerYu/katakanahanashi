import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:katakanahanashi/data/services/ad_service.dart';
import 'package:katakanahanashi/navigator/app_router.dart';
import 'package:katakanahanashi/ui/home/game/game_page.dart';

class AdDisplayPage extends StatefulWidget {
  const AdDisplayPage({super.key});

  @override
  State<AdDisplayPage> createState() => _AdDisplayPageState();
}

class _AdDisplayPageState extends State<AdDisplayPage>
    with TickerProviderStateMixin {
  InterstitialAd? _interstitialAd;
  bool _adLoaded = false;
  bool _showCloseButton = false;
  Timer? _closeButtonTimer;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // スライドアニメーションの初期化
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0.0, 1.0), // 下から開始
          end: const Offset(0.0, 0.0), // 通常位置まで
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
        );

    _loadInterstitialAd();

    // 画面表示後、少し遅延してからスライドアニメーション開始
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });

    // ページ遷移から3秒後に×ボタンを表示できるよう準備
    _closeButtonTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showCloseButton = true;
      });
    });
  }

  void _loadInterstitialAd() {
    // まず事前読み込み済み広告があるかチェック
    final preloadedAd = GamePage.getPreloadedAd();
    if (preloadedAd != null) {
      _interstitialAd = preloadedAd;
      setState(() {
        _adLoaded = true;
      });
      // 即座に表示
      _showInterstitialAd();
      return;
    }

    // 事前読み込み済み広告がない場合は通常の読み込み
    AdService.logAdInfo(); // デバッグ情報出力
    InterstitialAd.load(
      adUnitId: AdService.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          setState(() {
            _adLoaded = true;
          });

          // 広告読み込み完了後、自動で表示
          _showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError _) {
          // 広告読み込み失敗時も画面は表示し続ける
          setState(() {
            _adLoaded = false;
          });
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      return;
    }

    final interstitial = _interstitialAd!;

    interstitial.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _interstitialAd = null;
        // 広告終了後、逆アニメーション（黒→白）と×ボタン表示を並行処理
        _slideController.reverse();

        _closeButtonTimer?.cancel();

        // ×ボタンが表示されるようにしてからトップ画面に戻る
        if (context.mounted) {
          if (!_showCloseButton) {
            setState(() {
              _showCloseButton = true;
            });
          }
          // ×ボタン表示後、少し遅延してからトップ画面に戻る
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              _navigateToTop();
            }
          });
        }
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError _) {
        ad.dispose();
        _interstitialAd = null;
      },
    );
    interstitial.show();
  }

  void _navigateToTop() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouter.startRoute,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _closeButtonTimer?.cancel();
    _slideController.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 白い背景画面（常に表示）
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.ads_click, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    '広告表示中...',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          // 黒色スライドオーバーレイ（下から上へ）
          SlideTransition(
            position: _slideAnimation,
            child: Container(
              color: Colors.black,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // 左上の×ボタン（広告終了後に表示、シンプルなグレー）
          if (_showCloseButton)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              child: GestureDetector(
                onTap: _navigateToTop,
                child: const Icon(Icons.close, color: Colors.white38, size: 32),
              ),
            ),
        ],
      ),
    );
  }
}
