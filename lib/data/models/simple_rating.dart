import '../models/word_rating.dart';

class SimpleRating {
  final String wordId;
  final Difficulty difficulty;
  final bool isGood;
  final bool isBad;

  const SimpleRating({
    required this.wordId,
    required this.difficulty,
    required this.isGood,
    required this.isBad,
  });

  // difficultyのポイント値を取得（ポイントシステム用）
  int get difficultyPoints {
    switch (difficulty) {
      case Difficulty.easy:
        return 1;
      case Difficulty.normal:
        return 3;
      case Difficulty.hard:
        return 5;
    }
  }
  
  // 各カテゴリの増加値（選択されたら1、されなかったら0）
  int get easyIncrement => difficulty == Difficulty.easy ? 1 : 0;
  int get normalIncrement => difficulty == Difficulty.normal ? 1 : 0;
  int get hardIncrement => difficulty == Difficulty.hard ? 1 : 0;
  int get goodIncrement => isGood ? 1 : 0;
  int get badIncrement => isBad ? 1 : 0;
}