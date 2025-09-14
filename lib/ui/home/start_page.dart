import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../navigator/app_router.dart';
import '../../data/services/word_duplication_service.dart';
import 'game_view_model.dart';
import 'widgets/particle_background.dart';

class StartPage extends ConsumerWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                const Text('🎮', style: TextStyle(fontSize: 80)),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'カタカナハナシ',
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
                    'カタカナ語を使わずに説明しよう！',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      color: Colors.orange.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    // GameViewModelをリセットしてから新しいゲームを開始
                    final gameViewModel = ref.read(
                      gameViewModelProvider.notifier,
                    );
                    gameViewModel.resetGame();
                    print(
                      'StartPage - Reset GameViewModel and starting new game',
                    );

                    Navigator.pushNamed(context, AppRouter.gameRoute);
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
                    '🎯 スタート',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // 確認ダイアログを表示
                    final shouldReset = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('🔄 リセット確認'),
                        content: const Text(
                          '使用済みワード履歴をリセットしますか？\n\nこれにより、次回のゲームから全てのワードが再び表示されるようになります。',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('キャンセル'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('リセット'),
                          ),
                        ],
                      ),
                    );

                    if (shouldReset == true) {
                      // SharedPreferencesをクリア
                      await WordDuplicationService.resetUsedWords();

                      // 成功メッセージを表示
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 8),
                                Text('使用済みワード履歴をリセットしました'),
                              ],
                            ),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 4,
                    shadowColor: Colors.grey.withValues(alpha: 0.3),
                  ),
                  child: Text(
                    '🔄 履歴リセット',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
