import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:katakanahanashi/data/models/simple_rating.dart';
import 'package:katakanahanashi/data/models/word_rating.dart';
import 'package:katakanahanashi/domain/repository/katakana_word.dart';

class RatingDialog extends HookConsumerWidget {
  final KatakanaWord word;
  final Function(SimpleRating) onSubmit;

  const RatingDialog({super.key, required this.word, required this.onSubmit});

  /// タブレット判定メソッド
  bool _isTablet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return screenWidth >= 800 || screenHeight >= 1000;
  }

  /// レスポンシブ対応フォントサイズ取得
  double _getResponsiveFontSize(BuildContext context, double baseRatio) {
    return MediaQuery.of(context).size.width * baseRatio;
  }

  /// レスポンシブ対応パディング取得
  EdgeInsets _getResponsivePadding(
    BuildContext context, {
    double horizontalRatio = 0.04,
    double verticalRatio = 0.015,
  }) {
    return EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * horizontalRatio,
      vertical: MediaQuery.of(context).size.height * verticalRatio,
    );
  }

  /// レスポンシブ対応スペーシング取得
  double _getResponsiveSpacing(BuildContext context, double ratio) {
    return MediaQuery.of(context).size.height * ratio;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDifficulty = useState<Difficulty?>(null);
    final selectedGoodBad = useState<bool?>(null);

    return Container(
      constraints: _isTablet(context)
          ? const BoxConstraints(maxWidth: 500)
          : const BoxConstraints(maxWidth: 350),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: _isTablet(context)
            ? const EdgeInsets.symmetric(horizontal: 100, vertical: 50)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        title: Row(
          children: [
            Text(
              '⭐',
              style: TextStyle(fontSize: _getResponsiveFontSize(context, 0.06)),
            ),
            SizedBox(width: _getResponsiveSpacing(context, 0.01)),
            Expanded(
              child: Text(
                '「${word.word}」の評価',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(context, 0.045),
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 難易度選択
            Text(
              '🎯 難易度はどうでしたか？',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context, 0.04),
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade700,
              ),
            ),
            SizedBox(height: _getResponsiveSpacing(context, 0.015)),
            Column(
              children: Difficulty.values.map((difficulty) {
                final isSelected = selectedDifficulty.value == difficulty;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: _getResponsiveSpacing(context, 0.01),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () => selectedDifficulty.value = difficulty,
                      child: Container(
                        padding: _getResponsivePadding(
                          context,
                          horizontalRatio: 0.04,
                          verticalRatio: 0.015,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.orange
                              : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.orange.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          difficulty.displayName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.orange.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: _getResponsiveFontSize(context, 0.035),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: _getResponsiveSpacing(context, 0.03)),

            // Good/Bad評価
            Text(
              '👍 良いお題でしたか？',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context, 0.04),
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade700,
              ),
            ),
            SizedBox(height: _getResponsiveSpacing(context, 0.015)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Goodボタン
                GestureDetector(
                  onTap: () => selectedGoodBad.value =
                      selectedGoodBad.value == true ? null : true,
                  child: Container(
                    padding: _getResponsivePadding(
                      context,
                      horizontalRatio: 0.05,
                      verticalRatio: 0.012,
                    ),
                    decoration: BoxDecoration(
                      color: selectedGoodBad.value == true
                          ? Colors.green
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.green.shade300,
                        width: selectedGoodBad.value == true ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '👍',
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(context, 0.045),
                          ),
                        ),
                        SizedBox(width: _getResponsiveSpacing(context, 0.007)),
                        Text(
                          'Good!',
                          style: TextStyle(
                            color: selectedGoodBad.value == true
                                ? Colors.white
                                : Colors.green.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: _getResponsiveFontSize(context, 0.035),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Badボタン
                GestureDetector(
                  onTap: () => selectedGoodBad.value =
                      selectedGoodBad.value == false ? null : false,
                  child: Container(
                    padding: _getResponsivePadding(
                      context,
                      horizontalRatio: 0.05,
                      verticalRatio: 0.012,
                    ),
                    decoration: BoxDecoration(
                      color: selectedGoodBad.value == false
                          ? Colors.red
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.red.shade300,
                        width: selectedGoodBad.value == false ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '👎',
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(context, 0.045),
                          ),
                        ),
                        SizedBox(width: _getResponsiveSpacing(context, 0.007)),
                        Text(
                          'Bad!',
                          style: TextStyle(
                            color: selectedGoodBad.value == false
                                ? Colors.white
                                : Colors.red.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: _getResponsiveFontSize(context, 0.035),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: _getResponsiveSpacing(context, 0.02)),
            Text(
              '※ 難易度は必須、Good/Badは任意です',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context, 0.03),
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          // キャンセルボタン
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'キャンセル',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: _getResponsiveFontSize(context, 0.035),
              ),
            ),
          ),

          // 送信ボタン
          ElevatedButton(
            onPressed: selectedDifficulty.value == null
                ? null
                : () {
                    final rating = SimpleRating(
                      wordId: word.id ?? 'local_${word.word}', // ローカル用の仮ID
                      difficulty: selectedDifficulty.value!,
                      isGood: selectedGoodBad.value == true,
                      isBad: selectedGoodBad.value == false,
                    );

                    onSubmit(rating);
                    Navigator.of(context).pop();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              '決定',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _getResponsiveFontSize(context, 0.035),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
