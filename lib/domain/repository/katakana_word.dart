import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/word_rating.dart';

part 'katakana_word.freezed.dart';
part 'katakana_word.g.dart';

@freezed
class KatakanaWord with _$KatakanaWord {
  const factory KatakanaWord({
    String? id,
    required String word,
    required String category,
    @JsonKey(name: 'good_count') @Default(0) int goodCount,
    @JsonKey(name: 'bad_count') @Default(0) int badCount,
    @JsonKey(name: 'easy_count') @Default(0) int easyCount,
    @JsonKey(name: 'normal_count') @Default(0) int normalCount,
    @JsonKey(name: 'hard_count') @Default(0) int hardCount,
    @JsonKey(name: 'difficulty_rating') @Default(0) int difficultyRating,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _KatakanaWord;

  factory KatakanaWord.fromJson(Map<String, dynamic> json) =>
      _$KatakanaWordFromJson(json);
}

extension KatakanaWordExtension on KatakanaWord {
  // 総評価数
  int get totalEvaluations => easyCount + normalCount + hardCount;
  
  // 平均難易度ポイント
  double get averageDifficultyRating {
    if (totalEvaluations == 0) return 0.0;
    return difficultyRating / totalEvaluations;
  }
  
  // 難易度レベル判定
  Difficulty get difficultyLevel {
    final avg = averageDifficultyRating;
    if (avg < 2.0) return Difficulty.easy;
    if (avg < 4.0) return Difficulty.normal;
    return Difficulty.hard;
  }
  
  // 人気度スコア
  double get popularityScore {
    final total = goodCount + badCount;
    if (total == 0) return 0.0;
    return goodCount / total;
  }
}