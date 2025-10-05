import '../models/word_rating.dart';

class SimpleRating {
  final String wordId;
  final Difficulty difficulty;
  final bool isGood;
  final bool isBad;
  final DateTime createdAt;

  SimpleRating({
    required this.wordId,
    required this.difficulty,
    required this.isGood,
    required this.isBad,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

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

  Map<String, dynamic> toJson() => {
    'wordId': wordId,
    'difficulty': difficulty.name,
    'isGood': isGood,
    'isBad': isBad,
    'createdAt': createdAt.toIso8601String(),
  };

  factory SimpleRating.fromJson(Map<String, dynamic> json) {
    return SimpleRating(
      wordId: json['wordId'] as String,
      difficulty: Difficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => Difficulty.normal,
      ),
      isGood: json['isGood'] as bool,
      isBad: json['isBad'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'SimpleRating(wordId: $wordId, difficulty: $difficulty, isGood: $isGood, isBad: $isBad, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SimpleRating &&
        other.wordId == wordId &&
        other.difficulty == difficulty &&
        other.isGood == isGood &&
        other.isBad == isBad &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return wordId.hashCode ^
        difficulty.hashCode ^
        isGood.hashCode ^
        isBad.hashCode ^
        createdAt.hashCode;
  }
}