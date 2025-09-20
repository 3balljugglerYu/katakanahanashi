import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../navigator/app_router.dart';
import 'game_page.dart';

class AdDisplayPage extends StatefulWidget {
  const AdDisplayPage({super.key});

  @override
  State<AdDisplayPage> createState() => _AdDisplayPageState();
}

class _AdDisplayPageState extends State<AdDisplayPage> with TickerProviderStateMixin {
  // プラットフォーム別の広告ユニットIDを取得
  static String get _interstitialAdUnitId {
    if (Platform.isIOS) {
      // iOS
      // テスト用: 'ca-app-pub-3940256099942544/4411468910'
      // 本番用: 'ca-app-pub-2716829166250639/9936269880'
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      // Android
      // テスト用: 'ca-app-pub-3940256099942544/1033173712'
      // 本番用: 'ca-app-pub-2716829166250639/3387528627'
      return 'ca-app-pub-3940256099942544/1033173712';
    } else {
      // その他のプラットフォーム（テスト用）
      return 'ca-app-pub-3940256099942544/4411468910';
    }
  }
  
  InterstitialAd? _interstitialAd;
  bool _adLoaded = false;
  bool _showCloseButton = false;
  
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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // 下から開始
      end: const Offset(0.0, 0.0),   // 通常位置まで
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
    
    _loadInterstitialAd();
    
    // 画面表示後、少し遅延してからスライドアニメーション開始
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });
    
  }

  void _loadInterstitialAd() {
    // まず事前読み込み済み広告があるかチェック
    final preloadedAd = GamePage.getPreloadedAd();
    if (preloadedAd != null) {
      print('事前読み込み済み広告を使用します');
      _interstitialAd = preloadedAd;
      setState(() {
        _adLoaded = true;
      });
      // 即座に表示
      _showInterstitialAd();
      return;
    }
    
    // 事前読み込み済み広告がない場合は通常の読み込み
    print('事前読み込み済み広告がないため、新しく読み込みます');
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('広告が読み込まれました');
          _interstitialAd = ad;
          setState(() {
            _adLoaded = true;
          });
          
          // 広告読み込み完了後、自動で表示
          _showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('広告読み込みに失敗しました: ${error.message}');
          // 広告読み込み失敗時も画面は表示し続ける
          setState(() {
            _adLoaded = false;
          });
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          print('広告が終了されました');
          ad.dispose();
          _interstitialAd = null;
          // 広告終了後、逆アニメーション（黒→白）と×ボタン表示を並行処理
          _slideController.reverse();
          
          // ×ボタンを即座に表示してからトップ画面に戻る
          if (context.mounted) {
            setState(() {
              _showCloseButton = true;
            });
            // ×ボタン表示後、少し遅延してからトップ画面に戻る
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                _navigateToTop();
              }
            });
          }
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print('広告表示に失敗しました: ${error.message}');
          ad.dispose();
          _interstitialAd = null;
        },
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          print('広告が表示されました');
        },
      );
      _interstitialAd!.show();
    }
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
                  Icon(
                    Icons.ads_click,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '広告表示中...',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
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
                child: const Icon(
                  Icons.close,
                  color: Colors.white38,
                  size: 32,
                ),
              ),
            ),
        ],
      ),
    );
  }
}