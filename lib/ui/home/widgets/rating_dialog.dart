import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../domain/repository/katakana_word.dart';
import '../../../data/models/simple_rating.dart';
import '../../../data/models/word_rating.dart';

class RatingDialog extends HookConsumerWidget {
  final KatakanaWord word;
  final Function(SimpleRating) onSubmit;

  const RatingDialog({
    super.key,
    required this.word,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDifficulty = useState<Difficulty?>(null);
    final selectedGoodBad = useState<bool?>(null);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          const Text('⭐', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '「${word.word}」の評価',
              style: TextStyle(
                fontSize: 18,
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
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.orange.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: Difficulty.values.map((difficulty) {
              final isSelected = selectedDifficulty.value == difficulty;
              return GestureDetector(
                onTap: () => selectedDifficulty.value = difficulty,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
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
                    style: TextStyle(
                      color: isSelected 
                          ? Colors.white 
                          : Colors.orange.shade800,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Good/Bad評価
          Text(
            '👍 この問題はどうでしたか？',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.orange.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Goodボタン
              GestureDetector(
                onTap: () => selectedGoodBad.value = 
                    selectedGoodBad.value == true ? null : true,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
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
                      const Text('👍', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(
                        'グッド',
                        style: TextStyle(
                          color: selectedGoodBad.value == true 
                              ? Colors.white 
                              : Colors.green.shade800,
                          fontWeight: FontWeight.w600,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
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
                      const Text('👎', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(
                        'バッド',
                        style: TextStyle(
                          color: selectedGoodBad.value == false 
                              ? Colors.white 
                              : Colors.red.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          if (word.id == null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ローカルデータのため評価は保存されません',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              '※ 難易度は必須、Good/Badは任意です',
              style: TextStyle(
                fontSize: 12,
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
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
        
        // 送信ボタン
        ElevatedButton(
          onPressed: selectedDifficulty.value == null ? null : () {
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
          child: const Text(
            '送信',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}