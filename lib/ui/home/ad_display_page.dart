import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../navigator/app_router.dart';

class AdDisplayPage extends StatefulWidget {
  const AdDisplayPage({super.key});

  @override
  State<AdDisplayPage> createState() => _AdDisplayPageState();
}

class _AdDisplayPageState extends State<AdDisplayPage> {
  // テスト用: 'ca-app-pub-3940256099942544/4411468910'
  // 本番用: 'ca-app-pub-2716829166250639/9936269880'
  static const String _interstitialAdUnitId = 'ca-app-pub-3940256099942544/4411468910';
  
  InterstitialAd? _interstitialAd;
  bool _adLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
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
          // 広告終了後は何もしない（ユーザーが×ボタンを押すまで待つ）
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
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // メイン画面（白い画面）
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.ads_click,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '広告表示中...',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // 左上の×ボタン
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: _navigateToTop,
                  tooltip: 'トップ画面に戻る',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}