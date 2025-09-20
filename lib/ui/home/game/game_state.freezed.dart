// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameState {
  List<KatakanaWord> get shuffledWords => throw _privateConstructorUsedError;
  int get currentQuestionIndex => throw _privateConstructorUsedError;
  int get totalQuestions => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  List<UsedWord> get recentlyUsedWords => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call({
    List<KatakanaWord> shuffledWords,
    int currentQuestionIndex,
    int totalQuestions,
    bool isLoading,
    bool isSubmitting,
    String? errorMessage,
    List<UsedWord> recentlyUsedWords,
  });
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shuffledWords = null,
    Object? currentQuestionIndex = null,
    Object? totalQuestions = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
    Object? recentlyUsedWords = null,
  }) {
    return _then(
      _value.copyWith(
            shuffledWords: null == shuffledWords
                ? _value.shuffledWords
                : shuffledWords // ignore: cast_nullable_to_non_nullable
                      as List<KatakanaWord>,
            currentQuestionIndex: null == currentQuestionIndex
                ? _value.currentQuestionIndex
                : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            totalQuestions: null == totalQuestions
                ? _value.totalQuestions
                : totalQuestions // ignore: cast_nullable_to_non_nullable
                      as int,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSubmitting: null == isSubmitting
                ? _value.isSubmitting
                : isSubmitting // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            recentlyUsedWords: null == recentlyUsedWords
                ? _value.recentlyUsedWords
                : recentlyUsedWords // ignore: cast_nullable_to_non_nullable
                      as List<UsedWord>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
    _$GameStateImpl value,
    $Res Function(_$GameStateImpl) then,
  ) = __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<KatakanaWord> shuffledWords,
    int currentQuestionIndex,
    int totalQuestions,
    bool isLoading,
    bool isSubmitting,
    String? errorMessage,
    List<UsedWord> recentlyUsedWords,
  });
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
    _$GameStateImpl _value,
    $Res Function(_$GameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shuffledWords = null,
    Object? currentQuestionIndex = null,
    Object? totalQuestions = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
    Object? recentlyUsedWords = null,
  }) {
    return _then(
      _$GameStateImpl(
        shuffledWords: null == shuffledWords
            ? _value._shuffledWords
            : shuffledWords // ignore: cast_nullable_to_non_nullable
                  as List<KatakanaWord>,
        currentQuestionIndex: null == currentQuestionIndex
            ? _value.currentQuestionIndex
            : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        totalQuestions: null == totalQuestions
            ? _value.totalQuestions
            : totalQuestions // ignore: cast_nullable_to_non_nullable
                  as int,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSubmitting: null == isSubmitting
            ? _value.isSubmitting
            : isSubmitting // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        recentlyUsedWords: null == recentlyUsedWords
            ? _value._recentlyUsedWords
            : recentlyUsedWords // ignore: cast_nullable_to_non_nullable
                  as List<UsedWord>,
      ),
    );
  }
}

/// @nodoc

class _$GameStateImpl implements _GameState {
  const _$GameStateImpl({
    final List<KatakanaWord> shuffledWords = const [],
    this.currentQuestionIndex = 0,
    this.totalQuestions = 10,
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    final List<UsedWord> recentlyUsedWords = const [],
  }) : _shuffledWords = shuffledWords,
       _recentlyUsedWords = recentlyUsedWords;

  final List<KatakanaWord> _shuffledWords;
  @override
  @JsonKey()
  List<KatakanaWord> get shuffledWords {
    if (_shuffledWords is EqualUnmodifiableListView) return _shuffledWords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shuffledWords);
  }

  @override
  @JsonKey()
  final int currentQuestionIndex;
  @override
  @JsonKey()
  final int totalQuestions;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final String? errorMessage;
  final List<UsedWord> _recentlyUsedWords;
  @override
  @JsonKey()
  List<UsedWord> get recentlyUsedWords {
    if (_recentlyUsedWords is EqualUnmodifiableListView)
      return _recentlyUsedWords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentlyUsedWords);
  }

  @override
  String toString() {
    return 'GameState(shuffledWords: $shuffledWords, currentQuestionIndex: $currentQuestionIndex, totalQuestions: $totalQuestions, isLoading: $isLoading, isSubmitting: $isSubmitting, errorMessage: $errorMessage, recentlyUsedWords: $recentlyUsedWords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            const DeepCollectionEquality().equals(
              other._shuffledWords,
              _shuffledWords,
            ) &&
            (identical(other.currentQuestionIndex, currentQuestionIndex) ||
                other.currentQuestionIndex == currentQuestionIndex) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality().equals(
              other._recentlyUsedWords,
              _recentlyUsedWords,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_shuffledWords),
    currentQuestionIndex,
    totalQuestions,
    isLoading,
    isSubmitting,
    errorMessage,
    const DeepCollectionEquality().hash(_recentlyUsedWords),
  );

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);
}

abstract class _GameState implements GameState {
  const factory _GameState({
    final List<KatakanaWord> shuffledWords,
    final int currentQuestionIndex,
    final int totalQuestions,
    final bool isLoading,
    final bool isSubmitting,
    final String? errorMessage,
    final List<UsedWord> recentlyUsedWords,
  }) = _$GameStateImpl;

  @override
  List<KatakanaWord> get shuffledWords;
  @override
  int get currentQuestionIndex;
  @override
  int get totalQuestions;
  @override
  bool get isLoading;
  @override
  bool get isSubmitting;
  @override
  String? get errorMessage;
  @override
  List<UsedWord> get recentlyUsedWords;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UsedWord {
  String get wordId => throw _privateConstructorUsedError;
  String get word => throw _privateConstructorUsedError;
  DateTime get usedAt => throw _privateConstructorUsedError;

  /// Create a copy of UsedWord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UsedWordCopyWith<UsedWord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsedWordCopyWith<$Res> {
  factory $UsedWordCopyWith(UsedWord value, $Res Function(UsedWord) then) =
      _$UsedWordCopyWithImpl<$Res, UsedWord>;
  @useResult
  $Res call({String wordId, String word, DateTime usedAt});
}

/// @nodoc
class _$UsedWordCopyWithImpl<$Res, $Val extends UsedWord>
    implements $UsedWordCopyWith<$Res> {
  _$UsedWordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsedWord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wordId = null,
    Object? word = null,
    Object? usedAt = null,
  }) {
    return _then(
      _value.copyWith(
            wordId: null == wordId
                ? _value.wordId
                : wordId // ignore: cast_nullable_to_non_nullable
                      as String,
            word: null == word
                ? _value.word
                : word // ignore: cast_nullable_to_non_nullable
                      as String,
            usedAt: null == usedAt
                ? _value.usedAt
                : usedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UsedWordImplCopyWith<$Res>
    implements $UsedWordCopyWith<$Res> {
  factory _$$UsedWordImplCopyWith(
    _$UsedWordImpl value,
    $Res Function(_$UsedWordImpl) then,
  ) = __$$UsedWordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String wordId, String word, DateTime usedAt});
}

/// @nodoc
class __$$UsedWordImplCopyWithImpl<$Res>
    extends _$UsedWordCopyWithImpl<$Res, _$UsedWordImpl>
    implements _$$UsedWordImplCopyWith<$Res> {
  __$$UsedWordImplCopyWithImpl(
    _$UsedWordImpl _value,
    $Res Function(_$UsedWordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsedWord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wordId = null,
    Object? word = null,
    Object? usedAt = null,
  }) {
    return _then(
      _$UsedWordImpl(
        wordId: null == wordId
            ? _value.wordId
            : wordId // ignore: cast_nullable_to_non_nullable
                  as String,
        word: null == word
            ? _value.word
            : word // ignore: cast_nullable_to_non_nullable
                  as String,
        usedAt: null == usedAt
            ? _value.usedAt
            : usedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$UsedWordImpl implements _UsedWord {
  const _$UsedWordImpl({
    required this.wordId,
    required this.word,
    required this.usedAt,
  });

  @override
  final String wordId;
  @override
  final String word;
  @override
  final DateTime usedAt;

  @override
  String toString() {
    return 'UsedWord(wordId: $wordId, word: $word, usedAt: $usedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsedWordImpl &&
            (identical(other.wordId, wordId) || other.wordId == wordId) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.usedAt, usedAt) || other.usedAt == usedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, wordId, word, usedAt);

  /// Create a copy of UsedWord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsedWordImplCopyWith<_$UsedWordImpl> get copyWith =>
      __$$UsedWordImplCopyWithImpl<_$UsedWordImpl>(this, _$identity);
}

abstract class _UsedWord implements UsedWord {
  const factory _UsedWord({
    required final String wordId,
    required final String word,
    required final DateTime usedAt,
  }) = _$UsedWordImpl;

  @override
  String get wordId;
  @override
  String get word;
  @override
  DateTime get usedAt;

  /// Create a copy of UsedWord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsedWordImplCopyWith<_$UsedWordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
