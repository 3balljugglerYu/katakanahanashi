// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'katakana_word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KatakanaWordImpl _$$KatakanaWordImplFromJson(Map<String, dynamic> json) =>
    _$KatakanaWordImpl(
      id: json['id'] as String?,
      word: json['word'] as String,
      category: json['category'] as String,
      goodCount: (json['good_count'] as num?)?.toInt() ?? 0,
      badCount: (json['bad_count'] as num?)?.toInt() ?? 0,
      easyCount: (json['easy_count'] as num?)?.toInt() ?? 0,
      normalCount: (json['normal_count'] as num?)?.toInt() ?? 0,
      hardCount: (json['hard_count'] as num?)?.toInt() ?? 0,
      difficultyRating: (json['difficulty_rating'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$KatakanaWordImplToJson(_$KatakanaWordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'category': instance.category,
      'good_count': instance.goodCount,
      'bad_count': instance.badCount,
      'easy_count': instance.easyCount,
      'normal_count': instance.normalCount,
      'hard_count': instance.hardCount,
      'difficulty_rating': instance.difficultyRating,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
