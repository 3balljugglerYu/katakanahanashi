// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'katakana_word.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KatakanaWord _$KatakanaWordFromJson(Map<String, dynamic> json) {
  return _KatakanaWord.fromJson(json);
}

/// @nodoc
mixin _$KatakanaWord {
  String? get id => throw _privateConstructorUsedError;
  String get word => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'good_count')
  int get goodCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'bad_count')
  int get badCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'easy_count')
  int get easyCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'normal_count')
  int get normalCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'hard_count')
  int get hardCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'difficulty_rating')
  int get difficultyRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this KatakanaWord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KatakanaWord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KatakanaWordCopyWith<KatakanaWord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KatakanaWordCopyWith<$Res> {
  factory $KatakanaWordCopyWith(
    KatakanaWord value,
    $Res Function(KatakanaWord) then,
  ) = _$KatakanaWordCopyWithImpl<$Res, KatakanaWord>;
  @useResult
  $Res call({
    String? id,
    String word,
    String category,
    @JsonKey(name: 'good_count') int goodCount,
    @JsonKey(name: 'bad_count') int badCount,
    @JsonKey(name: 'easy_count') int easyCount,
    @JsonKey(name: 'normal_count') int normalCount,
    @JsonKey(name: 'hard_count') int hardCount,
    @JsonKey(name: 'difficulty_rating') int difficultyRating,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$KatakanaWordCopyWithImpl<$Res, $Val extends KatakanaWord>
    implements $KatakanaWordCopyWith<$Res> {
  _$KatakanaWordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KatakanaWord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? word = null,
    Object? category = null,
    Object? goodCount = null,
    Object? badCount = null,
    Object? easyCount = null,
    Object? normalCount = null,
    Object? hardCount = null,
    Object? difficultyRating = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            word: null == word
                ? _value.word
                : word // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            goodCount: null == goodCount
                ? _value.goodCount
                : goodCount // ignore: cast_nullable_to_non_nullable
                      as int,
            badCount: null == badCount
                ? _value.badCount
                : badCount // ignore: cast_nullable_to_non_nullable
                      as int,
            easyCount: null == easyCount
                ? _value.easyCount
                : easyCount // ignore: cast_nullable_to_non_nullable
                      as int,
            normalCount: null == normalCount
                ? _value.normalCount
                : normalCount // ignore: cast_nullable_to_non_nullable
                      as int,
            hardCount: null == hardCount
                ? _value.hardCount
                : hardCount // ignore: cast_nullable_to_non_nullable
                      as int,
            difficultyRating: null == difficultyRating
                ? _value.difficultyRating
                : difficultyRating // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KatakanaWordImplCopyWith<$Res>
    implements $KatakanaWordCopyWith<$Res> {
  factory _$$KatakanaWordImplCopyWith(
    _$KatakanaWordImpl value,
    $Res Function(_$KatakanaWordImpl) then,
  ) = __$$KatakanaWordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String word,
    String category,
    @JsonKey(name: 'good_count') int goodCount,
    @JsonKey(name: 'bad_count') int badCount,
    @JsonKey(name: 'easy_count') int easyCount,
    @JsonKey(name: 'normal_count') int normalCount,
    @JsonKey(name: 'hard_count') int hardCount,
    @JsonKey(name: 'difficulty_rating') int difficultyRating,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$KatakanaWordImplCopyWithImpl<$Res>
    extends _$KatakanaWordCopyWithImpl<$Res, _$KatakanaWordImpl>
    implements _$$KatakanaWordImplCopyWith<$Res> {
  __$$KatakanaWordImplCopyWithImpl(
    _$KatakanaWordImpl _value,
    $Res Function(_$KatakanaWordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KatakanaWord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? word = null,
    Object? category = null,
    Object? goodCount = null,
    Object? badCount = null,
    Object? easyCount = null,
    Object? normalCount = null,
    Object? hardCount = null,
    Object? difficultyRating = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$KatakanaWordImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        word: null == word
            ? _value.word
            : word // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        goodCount: null == goodCount
            ? _value.goodCount
            : goodCount // ignore: cast_nullable_to_non_nullable
                  as int,
        badCount: null == badCount
            ? _value.badCount
            : badCount // ignore: cast_nullable_to_non_nullable
                  as int,
        easyCount: null == easyCount
            ? _value.easyCount
            : easyCount // ignore: cast_nullable_to_non_nullable
                  as int,
        normalCount: null == normalCount
            ? _value.normalCount
            : normalCount // ignore: cast_nullable_to_non_nullable
                  as int,
        hardCount: null == hardCount
            ? _value.hardCount
            : hardCount // ignore: cast_nullable_to_non_nullable
                  as int,
        difficultyRating: null == difficultyRating
            ? _value.difficultyRating
            : difficultyRating // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KatakanaWordImpl implements _KatakanaWord {
  const _$KatakanaWordImpl({
    this.id,
    required this.word,
    required this.category,
    @JsonKey(name: 'good_count') this.goodCount = 0,
    @JsonKey(name: 'bad_count') this.badCount = 0,
    @JsonKey(name: 'easy_count') this.easyCount = 0,
    @JsonKey(name: 'normal_count') this.normalCount = 0,
    @JsonKey(name: 'hard_count') this.hardCount = 0,
    @JsonKey(name: 'difficulty_rating') this.difficultyRating = 0,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  });

  factory _$KatakanaWordImpl.fromJson(Map<String, dynamic> json) =>
      _$$KatakanaWordImplFromJson(json);

  @override
  final String? id;
  @override
  final String word;
  @override
  final String category;
  @override
  @JsonKey(name: 'good_count')
  final int goodCount;
  @override
  @JsonKey(name: 'bad_count')
  final int badCount;
  @override
  @JsonKey(name: 'easy_count')
  final int easyCount;
  @override
  @JsonKey(name: 'normal_count')
  final int normalCount;
  @override
  @JsonKey(name: 'hard_count')
  final int hardCount;
  @override
  @JsonKey(name: 'difficulty_rating')
  final int difficultyRating;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'KatakanaWord(id: $id, word: $word, category: $category, goodCount: $goodCount, badCount: $badCount, easyCount: $easyCount, normalCount: $normalCount, hardCount: $hardCount, difficultyRating: $difficultyRating, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KatakanaWordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.goodCount, goodCount) ||
                other.goodCount == goodCount) &&
            (identical(other.badCount, badCount) ||
                other.badCount == badCount) &&
            (identical(other.easyCount, easyCount) ||
                other.easyCount == easyCount) &&
            (identical(other.normalCount, normalCount) ||
                other.normalCount == normalCount) &&
            (identical(other.hardCount, hardCount) ||
                other.hardCount == hardCount) &&
            (identical(other.difficultyRating, difficultyRating) ||
                other.difficultyRating == difficultyRating) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    word,
    category,
    goodCount,
    badCount,
    easyCount,
    normalCount,
    hardCount,
    difficultyRating,
    createdAt,
    updatedAt,
  );

  /// Create a copy of KatakanaWord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KatakanaWordImplCopyWith<_$KatakanaWordImpl> get copyWith =>
      __$$KatakanaWordImplCopyWithImpl<_$KatakanaWordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KatakanaWordImplToJson(this);
  }
}

abstract class _KatakanaWord implements KatakanaWord {
  const factory _KatakanaWord({
    final String? id,
    required final String word,
    required final String category,
    @JsonKey(name: 'good_count') final int goodCount,
    @JsonKey(name: 'bad_count') final int badCount,
    @JsonKey(name: 'easy_count') final int easyCount,
    @JsonKey(name: 'normal_count') final int normalCount,
    @JsonKey(name: 'hard_count') final int hardCount,
    @JsonKey(name: 'difficulty_rating') final int difficultyRating,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$KatakanaWordImpl;

  factory _KatakanaWord.fromJson(Map<String, dynamic> json) =
      _$KatakanaWordImpl.fromJson;

  @override
  String? get id;
  @override
  String get word;
  @override
  String get category;
  @override
  @JsonKey(name: 'good_count')
  int get goodCount;
  @override
  @JsonKey(name: 'bad_count')
  int get badCount;
  @override
  @JsonKey(name: 'easy_count')
  int get easyCount;
  @override
  @JsonKey(name: 'normal_count')
  int get normalCount;
  @override
  @JsonKey(name: 'hard_count')
  int get hardCount;
  @override
  @JsonKey(name: 'difficulty_rating')
  int get difficultyRating;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of KatakanaWord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KatakanaWordImplCopyWith<_$KatakanaWordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
