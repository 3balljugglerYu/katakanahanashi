import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:katakanahanashi/navigator/app_router.dart';
import 'package:katakanahanashi/ui/home/game/game_view_model.dart';
import 'package:katakanahanashi/ui/home/widgets/background/particle_background.dart';
import 'package:katakanahanashi/ui/onboarding/onboarding_page.dart';
import 'package:katakanahanashi/data/services/supabase_service.dart';
import 'package:katakanahanashi/config/app_config.dart';
import 'package:katakanahanashi/ui/subscription/subscription_view_model.dart';

class StartPage extends ConsumerWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionState = ref.watch(subscriptionViewModelProvider);
    final isSubscribed = subscriptionState.isSubscribed;

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: Stack(
        children: [
          // パーティクルアニメーション背景
          const ParticleBackground(),
          // メインコンテンツ
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // アプリアイコンを角丸で表示
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/icon/app_icon.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'ことばかくれんぼ',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'カタカナを使わずに説明しよう！',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w900,

                      color: Colors.orange.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () async {
                    // Supabase接続確認を実行
                    await _checkSupabaseConnectionAndStart(context, ref);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: Colors.orange.withValues(alpha: 0.4),
                  ),
                  child: Text(
                    'スタート',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (Platform.isIOS) ...[
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.subscriptionRoute);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.orange.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.workspace_premium,
                          size: 18,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isSubscribed ? '広告オフの状態を確認' : '広告なしで遊ぶ',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSubscribed) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 18,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '広告オフが有効です',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                ] else
                  const SizedBox(height: 16),
                // ルール再確認ボタン
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingPage(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.orange.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.help_outline,
                        size: 18,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'ルールを再確認',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                // 使用ワードのリセット機能：一旦、不要
                // const SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () async {
                //     // 確認ダイアログを表示
                //     final shouldReset = await showDialog<bool>(
                //       context: context,
                //       builder: (context) => AlertDialog(
                //         title: const Text('🔄 リセット確認'),
                //         content: const Text(
                //           '使用済みワード履歴をリセットしますか？\n\nこれにより、次回のゲームから全てのワードが再び表示されるようになります。',
                //         ),
                //         actions: [
                //           TextButton(
                //             onPressed: () => Navigator.of(context).pop(false),
                //             child: const Text('キャンセル'),
                //           ),
                //           ElevatedButton(
                //             onPressed: () => Navigator.of(context).pop(true),
                //             style: ElevatedButton.styleFrom(
                //               backgroundColor: Colors.red,
                //               foregroundColor: Colors.white,
                //             ),
                //             child: const Text('リセット'),
                //           ),
                //         ],
                //       ),
                //     );
                //
                //     if (shouldReset == true) {
                //       // SharedPreferencesをクリア
                //       await WordDuplicationService.resetUsedWords();
                //
                //       // 成功メッセージを表示
                //       if (context.mounted) {
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           const SnackBar(
                //             content: Row(
                //               children: [
                //                 Icon(Icons.check_circle, color: Colors.white),
                //                 SizedBox(width: 8),
                //                 Text('使用済みワード履歴をリセットしました'),
                //               ],
                //             ),
                //             backgroundColor: Colors.green,
                //             duration: Duration(seconds: 2),
                //           ),
                //         );
                //       }
                //     }
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.grey.shade600,
                //     foregroundColor: Colors.white,
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 30,
                //       vertical: 12,
                //     ),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(25),
                //     ),
                //     elevation: 4,
                //     shadowColor: Colors.grey.withValues(alpha: 0.3),
                //   ),
                //   child: Text(
                //     '履歴リセット',
                //     style: TextStyle(
                //       fontSize: MediaQuery.of(context).size.width * 0.045,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Supabase接続確認とゲーム開始処理
  Future<void> _checkSupabaseConnectionAndStart(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // 接続確認中のローディングダイアログを表示
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
            const SizedBox(height: 16),
            Text(
              'お題を作成中...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.orange.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );

    try {
      // Supabase接続テスト（3秒でタイムアウト）
      final isConnected = await SupabaseService.checkConnection().timeout(
        const Duration(seconds: 3),
        onTimeout: () => false,
      );

      // ローディングダイアログを閉じる
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (isConnected) {
        // 接続成功：ゲーム開始
        await _startGame(context, ref, true);
      } else {
        // 接続失敗：警告ダイアログを表示
        await _showConnectionWarningDialog(context, ref);
      }
    } catch (e) {
      // ローディングダイアログを閉じる
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // エラー発生：警告ダイアログを表示
      await _showConnectionWarningDialog(context, ref);
    }
  }

  /// 接続警告ダイアログを表示
  Future<void> _showConnectionWarningDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final connectionInfo = SupabaseService.getConnectionInfo();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange.shade600),
            const SizedBox(width: 8),
            Text('接続に関する通知'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConfig.isDebugMode
                  ? 'Supabaseへの接続に問題があります。\n\nローカルデータでゲームを続行します。本番環境ではユーザー向けのテキストが表示されます。'
                  : 'ネットワーク接続に問題があります。\n\nオフラインでゲームを続行できますが、同じ「お題」が表示される場合があります。',
              style: const TextStyle(fontSize: 14),
            ),
            if (AppConfig.isDebugMode) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                '接続情報:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'URL: ${connectionInfo['url']}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'API Key: ${connectionInfo['hasAnonKey']}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startGame(context, ref, false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('続行'),
          ),
        ],
      ),
    );
  }

  /// ゲーム開始処理
  Future<void> _startGame(
    BuildContext context,
    WidgetRef ref,
    bool isSupabaseConnected,
  ) async {
    // GameViewModelをリセットしてから新しいゲームを開始
    final gameViewModel = ref.read(gameViewModelProvider.notifier);
    gameViewModel.resetGame();

    print('StartPage - Reset GameViewModel and starting new game');
    print('StartPage - Supabase connection status: $isSupabaseConnected');

    if (context.mounted) {
      // 接続成功の場合は成功メッセージを短時間表示（デバッグモードのみ）
      if (isSupabaseConnected && AppConfig.isDebugMode) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Supabase接続成功！'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );

        // 少し遅延してからゲーム画面に遷移
        await Future.delayed(const Duration(milliseconds: 800));
      }

      Navigator.pushNamed(context, AppRouter.gameRoute);
    }
  }
}
