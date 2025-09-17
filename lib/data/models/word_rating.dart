import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_rating.freezed.dart';
part 'word_rating.g.dart';

@freezed
class WordRating with _$WordRating {
  const factory WordRating({
    String? id,
    @JsonKey(name: 'word_id') required String wordId,
    required Difficulty difficulty,
    @JsonKey(name: 'is_good') bool? isGood,
    @JsonKey(name: 'is_bad') bool? isBad,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _WordRating;

  factory WordRating.fromJson(Map<String, dynamic> json) =>
      _$WordRatingFromJson(json);
}

enum Difficulty {
  @JsonValue('easy')
  easy,
  @JsonValue('normal')
  normal,
  @JsonValue('hard')
  hard,
}

extension DifficultyExtension on Difficulty {
  int get points {
    switch (this) {
      case Difficulty.easy:
        return 1;
      case Difficulty.normal:
        return 3;
      case Difficulty.hard:
        return 5;
    }
  }

  String get displayName {
    switch (this) {
      case Difficulty.easy:
        return 'かんたん';
      case Difficulty.normal:
        return 'ふつう';
      case Difficulty.hard:
        return 'むつかしい';
    }
  }
}
