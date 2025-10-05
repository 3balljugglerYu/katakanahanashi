import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:katakanahanashi/data/katakana_words.dart';
import 'package:katakanahanashi/data/repositories/word_rating_repository.dart';
import 'package:katakanahanashi/data/models/simple_rating.dart';
import 'package:katakanahanashi/data/services/word_duplication_service.dart';
import 'package:katakanahanashi/data/services/rating_batch_service.dart';
import 'package:katakanahanashi/domain/repository/katakana_word.dart';

import 'game_state.dart';

// 評価送信結果クラス
class SubmissionResult {
  final bool isSuccess;
  final String message;

  const SubmissionResult._({required this.isSuccess, required this.message});

  const SubmissionResult.success(String message)
    : this._(isSuccess: true, message: message);
}

class GameViewModel extends StateNotifier<GameState> {
  final WordRatingRepository _repository;

  GameViewModel(this._repository) : super(const GameState()) {
    _initializeGame();
    _retryPendingRatingsOnStart();
  }

  // ゲーム開始時に未送信の評価をリトライ
  void _retryPendingRatingsOnStart() async {
    try {
      await _repository.retryPendingRatings();
    } catch (e) {
      // リトライエラーは静かに処理
      print('GameViewModel - Error retrying pending ratings on start: $e');
    }
  }

  void _initializeGame() async {
    // ゲーム開始時に必ずcurrentQuestionIndexを0にリセット
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      currentQuestionIndex: 0,
      pendingRatings: [], // バッチ評価をクリア
    );

    try {
      // Supabaseからワードを取得
      final wordsFromDb = await _repository.getWords();

      if (wordsFromDb.isNotEmpty) {
        // データベースにワードがある場合は重複防止を適用
        await _useDatabaseWords(wordsFromDb);
      } else {
        // データベースが空の場合はローカルデータを使用（重複防止なし）
        _useLocalWords();
      }
    } catch (e) {
      // エラーの場合もローカルデータを使用（重複防止なし）
      _useLocalWords();
      state = state.copyWith(errorMessage: 'ネットワークエラーのためローカルデータを使用します');
    }
  }

  Future<void> _useDatabaseWords(List<KatakanaWord> wordsFromDb) async {
    // データベースの総ワード数を保存
    await WordDuplicationService.setTotalDbWordsCount(wordsFromDb.length);

    // 重複防止フィルタリングを適用
    final availableWords = await WordDuplicationService.filterAvailableWords(
      wordsFromDb,
      (word) => word.id ?? '',
    );

    // シャッフルして選択
    final shuffled = [...availableWords];
    shuffled.shuffle(Random());

    state = state.copyWith(
      shuffledWords: shuffled.take(state.totalQuestions).toList(),
      isLoading: false,
      currentQuestionIndex: 0, // 確実に0から開始
    );

    print(
      'GameViewModel - New game started with ${shuffled.take(state.totalQuestions).length} words, currentQuestionIndex: 0',
    );
  }

  void _useLocalWords() {
    final shuffled = [...katakanaWords];
    shuffled.shuffle(Random());

    state = state.copyWith(
      shuffledWords: shuffled.take(state.totalQuestions).toList(),
      isLoading: false,
      currentQuestionIndex: 0, // 確実に0から開始
    );

    print(
      'GameViewModel - New game started with local words, currentQuestionIndex: 0',
    );
  }

  void nextQuestion() {
    // 現在のワードを使用済みにマーク（データベースワードのみ）
    final currentWord = state.shuffledWords[state.currentQuestionIndex];
    if (currentWord.id != null &&
        WordDuplicationService.isDatabaseWord(currentWord.id)) {
      WordDuplicationService.markWordAsUsed(currentWord.id!);
    }

    // 最後の問題を超えないようにチェック
    final nextIndex = state.currentQuestionIndex + 1;

    if (nextIndex < state.shuffledWords.length) {
      state = state.copyWith(currentQuestionIndex: nextIndex);
      print(
        'GameViewModel - Moved to question ${nextIndex + 1}/${state.totalQuestions}',
      );
    } else {
      // ゲームが終了した場合の処理
      print(
        'Game completed. Question index would be $nextIndex but only have ${state.shuffledWords.length} words.',
      );

      // 残りの一意のワード数をログ出力
      _logRemainingWords();

      // インデックスは最後の位置のままにする（範囲外にしない）
      state = state.copyWith(
        currentQuestionIndex: state.shuffledWords.length - 1,
      );
    }
  }

  /// 残りの一意のワード数をログ出力
  Future<void> _logRemainingWords() async {
    try {
      final totalDbWords = await WordDuplicationService.getTotalDbWordsCount();
      final usedWords = await WordDuplicationService.getUsedWordIds();
      final remainingWords = totalDbWords - usedWords.length;

      print('=== ゲーム終了時のワード状況 ===');
      print('データベース総ワード数: $totalDbWords');
      print('使用済みワード数: ${usedWords.length}');
      print('残りの一意のワード数: $remainingWords');
      print('===============================');
    } catch (e) {
      print('残りワード数の取得に失敗: $e');
    }
  }

  /// ゲーム終了後のリセット判定と実行
  Future<bool> checkAndResetIfNeeded() async {
    try {
      final shouldReset = await WordDuplicationService.shouldResetAfterGame();

      if (shouldReset) {
        print('WordDuplicationService - Executing reset after game completion');
        await WordDuplicationService.resetUsedWords();

        // リセット後の状況をログ出力
        final totalDbWords =
            await WordDuplicationService.getTotalDbWordsCount();
        final usedWords = await WordDuplicationService.getUsedWordIds();
        final remainingWords = totalDbWords - usedWords.length;

        print('=== リセット後のワード状況 ===');
        print('データベース総ワード数: $totalDbWords');
        print('使用済みワード数: ${usedWords.length}');
        print('残りの一意のワード数: $remainingWords');
        print('===============================');

        return true; // リセットが実行された
      }

      return false; // リセットは不要
    } catch (e) {
      print('リセット判定に失敗: $e');
      return false;
    }
  }

  bool get isLastQuestion =>
      state.currentQuestionIndex >= state.totalQuestions - 1;

  void resetGame() {
    state = const GameState();
    _initializeGame();
  }

  // ローディング状態をクリア
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  // ローディング状態を取得
  bool get isLoading => state.isLoading;
  bool get hasError => state.errorMessage != null;
  String? get errorMessage => state.errorMessage;

  // 評価を送信（バッチ処理対応）
  Future<SubmissionResult> submitRating(SimpleRating rating) async {
    try {
      // ローカルデータの場合はバッチに追加せずスキップ
      if (rating.wordId.startsWith('local_')) {
        return const SubmissionResult.success('評価を保存しました！');
      }

      // バッチ処理用にローカル保存
      await RatingBatchService.savePendingRating(rating);
      
      // ゲーム状態に追加
      final updatedPendingRatings = [...state.pendingRatings, rating];
      state = state.copyWith(pendingRatings: updatedPendingRatings);

      // ゲーム終了時（10問目完了）にバッチ送信
      if (isLastQuestion && updatedPendingRatings.length >= state.totalQuestions) {
        await _processBatchSubmission();
      }

      return const SubmissionResult.success('評価を保存しました！');
    } catch (e) {
      // エラーが発生してもユーザー体験を損なわない
      // Debug: print('GameViewModel - Error in submitRating: $e');
      return const SubmissionResult.success('評価を保存しました！');
    }
  }

  // バッチ送信処理
  Future<void> _processBatchSubmission() async {
    try {
      print('GameViewModel - Starting batch submission process');
      
      final pendingRatings = await RatingBatchService.getPendingRatings();
      
      if (pendingRatings.isEmpty) {
        print('GameViewModel - No pending ratings to submit');
        return;
      }

      print('GameViewModel - Submitting batch of ${pendingRatings.length} ratings');
      
      final result = await _repository.submitBatchRatings(pendingRatings);
      
      if (result.isComplete) {
        // 全て成功
        await RatingBatchService.clearPendingRatings();
        state = state.copyWith(pendingRatings: []);
        print('GameViewModel - Batch submission completed successfully');
      } else {
        // 部分的成功
        await RatingBatchService.updatePendingRatings(result.failed);
        state = state.copyWith(pendingRatings: result.failed);
        print('GameViewModel - Batch submission partially completed: ${result.succeeded.length} succeeded, ${result.failed.length} failed');
      }
    } catch (e) {
      print('GameViewModel - Error in batch submission: $e');
      // バッチ送信エラーは静かに処理（次回リトライされる）
    }
  }


  // 未送信評価数を取得
  Future<int> getPendingRatingsCount() async {
    return await _repository.getPendingRatingsCount();
  }

  // 現在のワードを取得
  KatakanaWord get currentWord {
    // 安全性チェック：インデックスが範囲内かどうか確認
    if (state.currentQuestionIndex >= 0 &&
        state.currentQuestionIndex < state.shuffledWords.length) {
      return state.shuffledWords[state.currentQuestionIndex];
    }

    // 範囲外の場合はエラーを防ぐため最初のワードを返すか、例外処理
    print(
      'Error: currentQuestionIndex ${state.currentQuestionIndex} is out of range for ${state.shuffledWords.length} words',
    );

    // 空の場合は緊急用のダミーワードを返す
    if (state.shuffledWords.isEmpty) {
      return const KatakanaWord(word: 'エラー', category: 'システム');
    }

    return state.shuffledWords.first;
  }
}

// WordRatingRepositoryのプロバイダー
final wordRatingRepositoryProvider = Provider<WordRatingRepository>((ref) {
  return WordRatingRepository();
});

final gameViewModelProvider = StateNotifierProvider<GameViewModel, GameState>((
  ref,
) {
  final repository = ref.read(wordRatingRepositoryProvider);
  return GameViewModel(repository);
});
