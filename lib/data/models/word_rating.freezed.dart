// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word_rating.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WordRating _$WordRatingFromJson(Map<String, dynamic> json) {
  return _WordRating.fromJson(json);
}

/// @nodoc
mixin _$WordRating {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'word_id')
  String get wordId => throw _privateConstructorUsedError;
  Difficulty get difficulty => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_good')
  bool? get isGood => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_bad')
  bool? get isBad => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this WordRating to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WordRating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WordRatingCopyWith<WordRating> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordRatingCopyWith<$Res> {
  factory $WordRatingCopyWith(
    WordRating value,
    $Res Function(WordRating) then,
  ) = _$WordRatingCopyWithImpl<$Res, WordRating>;
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'word_id') String wordId,
    Difficulty difficulty,
    @JsonKey(name: 'is_good') bool? isGood,
    @JsonKey(name: 'is_bad') bool? isBad,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$WordRatingCopyWithImpl<$Res, $Val extends WordRating>
    implements $WordRatingCopyWith<$Res> {
  _$WordRatingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WordRating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? wordId = null,
    Object? difficulty = null,
    Object? isGood = freezed,
    Object? isBad = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            wordId: null == wordId
                ? _value.wordId
                : wordId // ignore: cast_nullable_to_non_nullable
                      as String,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as Difficulty,
            isGood: freezed == isGood
                ? _value.isGood
                : isGood // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isBad: freezed == isBad
                ? _value.isBad
                : isBad // ignore: cast_nullable_to_non_nullable
                      as bool?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WordRatingImplCopyWith<$Res>
    implements $WordRatingCopyWith<$Res> {
  factory _$$WordRatingImplCopyWith(
    _$WordRatingImpl value,
    $Res Function(_$WordRatingImpl) then,
  ) = __$$WordRatingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: 'word_id') String wordId,
    Difficulty difficulty,
    @JsonKey(name: 'is_good') bool? isGood,
    @JsonKey(name: 'is_bad') bool? isBad,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$WordRatingImplCopyWithImpl<$Res>
    extends _$WordRatingCopyWithImpl<$Res, _$WordRatingImpl>
    implements _$$WordRatingImplCopyWith<$Res> {
  __$$WordRatingImplCopyWithImpl(
    _$WordRatingImpl _value,
    $Res Function(_$WordRatingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WordRating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? wordId = null,
    Object? difficulty = null,
    Object? isGood = freezed,
    Object? isBad = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$WordRatingImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        wordId: null == wordId
            ? _value.wordId
            : wordId // ignore: cast_nullable_to_non_nullable
                  as String,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as Difficulty,
        isGood: freezed == isGood
            ? _value.isGood
            : isGood // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isBad: freezed == isBad
            ? _value.isBad
            : isBad // ignore: cast_nullable_to_non_nullable
                  as bool?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WordRatingImpl implements _WordRating {
  const _$WordRatingImpl({
    this.id,
    @JsonKey(name: 'word_id') required this.wordId,
    required this.difficulty,
    @JsonKey(name: 'is_good') this.isGood,
    @JsonKey(name: 'is_bad') this.isBad,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$WordRatingImpl.fromJson(Map<String, dynamic> json) =>
      _$$WordRatingImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'word_id')
  final String wordId;
  @override
  final Difficulty difficulty;
  @override
  @JsonKey(name: 'is_good')
  final bool? isGood;
  @override
  @JsonKey(name: 'is_bad')
  final bool? isBad;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'WordRating(id: $id, wordId: $wordId, difficulty: $difficulty, isGood: $isGood, isBad: $isBad, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordRatingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.wordId, wordId) || other.wordId == wordId) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.isGood, isGood) || other.isGood == isGood) &&
            (identical(other.isBad, isBad) || other.isBad == isBad) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    wordId,
    difficulty,
    isGood,
    isBad,
    createdAt,
  );

  /// Create a copy of WordRating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WordRatingImplCopyWith<_$WordRatingImpl> get copyWith =>
      __$$WordRatingImplCopyWithImpl<_$WordRatingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WordRatingImplToJson(this);
  }
}

abstract class _WordRating implements WordRating {
  const factory _WordRating({
    final String? id,
    @JsonKey(name: 'word_id') required final String wordId,
    required final Difficulty difficulty,
    @JsonKey(name: 'is_good') final bool? isGood,
    @JsonKey(name: 'is_bad') final bool? isBad,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$WordRatingImpl;

  factory _WordRating.fromJson(Map<String, dynamic> json) =
      _$WordRatingImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'word_id')
  String get wordId;
  @override
  Difficulty get difficulty;
  @override
  @JsonKey(name: 'is_good')
  bool? get isGood;
  @override
  @JsonKey(name: 'is_bad')
  bool? get isBad;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of WordRating
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WordRatingImplCopyWith<_$WordRatingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
