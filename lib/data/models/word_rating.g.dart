// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WordRatingImpl _$$WordRatingImplFromJson(Map<String, dynamic> json) =>
    _$WordRatingImpl(
      id: json['id'] as String?,
      wordId: json['word_id'] as String,
      difficulty: $enumDecode(_$DifficultyEnumMap, json['difficulty']),
      isGood: json['is_good'] as bool?,
      isBad: json['is_bad'] as bool?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$WordRatingImplToJson(_$WordRatingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word_id': instance.wordId,
      'difficulty': _$DifficultyEnumMap[instance.difficulty]!,
      'is_good': instance.isGood,
      'is_bad': instance.isBad,
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$DifficultyEnumMap = {
  Difficulty.easy: 'easy',
  Difficulty.normal: 'normal',
  Difficulty.hard: 'hard',
};
