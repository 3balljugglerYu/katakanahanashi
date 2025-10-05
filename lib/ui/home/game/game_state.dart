import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:katakanahanashi/domain/repository/katakana_word.dart';
import '../../../data/models/simple_rating.dart';

part 'game_state.freezed.dart';

@freezed
class GameState with _$GameState {
  const factory GameState({
    @Default([]) List<KatakanaWord> shuffledWords,
    @Default(0) int currentQuestionIndex,
    @Default(10) int totalQuestions,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    String? errorMessage,
    @Default([]) List<UsedWord> recentlyUsedWords, // 最近使用されたワード
    @Default([]) List<SimpleRating> pendingRatings, // バッチ送信待ちの評価
  }) = _GameState;
}

// 使用済みワード情報
@freezed
class UsedWord with _$UsedWord {
  const factory UsedWord({
    required String wordId,
    required String word,
    required DateTime usedAt,
  }) = _UsedWord;
}