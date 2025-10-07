import 'dart:async';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/simple_rating.dart';
import '../models/word_rating.dart';
import '../services/supabase_service.dart';
import '../services/rating_batch_service.dart';
import '../services/word_duplication_service.dart';
import '../../domain/repository/katakana_word.dart';

// カスタム例外クラス
class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);

  @override
  String toString() => message;
}

class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);

  @override
  String toString() => message;
}

class UnknownException implements Exception {
  final String message;
  const UnknownException(this.message);

  @override
  String toString() => message;
}

class WordRatingRepository {
  final _supabase = SupabaseService.instance.client;
  static const int _queryTimeoutSeconds = 3;
  static const int _gameWordsTarget = 20;
  static const int _gameWordsSelection = 10;

  // 評価を送信（直接wordsテーブルを更新）
  Future<void> submitRating(SimpleRating rating) async {
    try {
      // RPC関数を使用して更新（SQLインジェクション対策）
      await _supabase
          .rpc(
            'update_word_rating',
            params: {
              'p_word_id': rating.wordId,
              'p_difficulty': rating.difficulty.name,
              'p_is_good': rating.isGood,
              'p_is_bad': rating.isBad,
            },
          )
          .timeout(
            const Duration(seconds: 1),
            onTimeout: () => throw TimeoutException(
              '評価の送信がタイムアウトしました',
              const Duration(seconds: 1),
            ),
          );
    } on TimeoutException {
      throw const NetworkException('通信がタイムアウトしました。ネットワーク接続を確認してください。');
    } on PostgrestException catch (e) {
      print('Repository - Database error: ${e.message}');
      throw DatabaseException('データベースエラーが発生しました: ${e.message}');
    } on SocketException {
      throw const NetworkException('インターネット接続がありません。接続を確認してください。');
    } catch (e) {
      print('Repository - Unexpected error: $e');
      throw UnknownException('予期しないエラーが発生しました: ${e.toString()}');
    }
  }

  // ワード一覧を取得
  Future<List<KatakanaWord>> getWords() async {
    try {
      final response = await _supabase
          .from('words')
          .select()
          .order('word')
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () => throw TimeoutException(
              'データ取得がタイムアウトしました',
              const Duration(seconds: 3),
            ),
          );

      return (response as List)
          .map((json) => KatakanaWord.fromJson(json))
          .toList();
    } on TimeoutException {
      throw const NetworkException('通信がタイムアウトしました。ネットワーク接続を確認してください。');
    } on PostgrestException catch (e) {
      print('Repository - Database error: ${e.message}');
      throw DatabaseException('データベースエラーが発生しました: ${e.message}');
    } on SocketException {
      throw const NetworkException('インターネット接続がありません。接続を確認してください。');
    } catch (e) {
      print('Repository - Unexpected error: $e');
      throw UnknownException('予期しないエラーが発生しました: ${e.toString()}');
    }
  }

  // 難易度別ワード取得
  Future<List<KatakanaWord>> getWordsByDifficultyLevel(
    Difficulty difficulty, {
    int limit = 20,
  }) async {
    try {
      // 難易度に応じた平均値の範囲でフィルタリング
      double minAvg, maxAvg;
      switch (difficulty) {
        case Difficulty.easy:
          minAvg = 0.0;
          maxAvg = 2.0;
          break;
        case Difficulty.normal:
          minAvg = 2.0;
          maxAvg = 4.0;
          break;
        case Difficulty.hard:
          minAvg = 4.0;
          maxAvg = 6.0; // 最大値
          break;
      }

      final response = await _supabase
          .from('words')
          .select()
          .gt('easy_count', 0) // 最低1回は評価されているもの
          .limit(limit)
          .order('word');

      final words = (response as List)
          .map((json) => KatakanaWord.fromJson(json))
          .where((word) {
            final avgRating = word.averageDifficultyRating;
            return avgRating >= minAvg && avgRating < maxAvg;
          })
          .toList();

      return words;
    } catch (e) {
      throw Exception('難易度別ワードの取得に失敗しました: $e');
    }
  }

  // 人気ワード取得
  Future<List<KatakanaWord>> getPopularWords({int limit = 20}) async {
    try {
      final response = await _supabase
          .from('words')
          .select()
          .gt('good_count', 3) // good_countが3より大きいもの
          .order('good_count', ascending: false)
          .limit(limit);

      final words = (response as List)
          .map((json) => KatakanaWord.fromJson(json))
          .where((word) => word.goodCount + word.badCount > 5) // 合計評価数が5より多い
          .toList();

      return words;
    } catch (e) {
      throw Exception('人気ワードの取得に失敗しました: $e');
    }
  }

  // 特定ワードの統計情報取得
  Future<KatakanaWord?> getWordStats(String wordId) async {
    try {
      final response = await _supabase
          .from('words')
          .select()
          .eq('id', wordId)
          .maybeSingle();

      if (response == null) return null;
      return KatakanaWord.fromJson(response);
    } catch (e) {
      throw Exception('ワード統計の取得に失敗しました: $e');
    }
  }

  // バッチ評価送信
  Future<BatchSubmissionResult> submitBatchRatings(List<SimpleRating> ratings) async {
    return await RatingBatchService.submitBatch(ratings, this);
  }

  // 未送信評価のリトライ
  Future<void> retryPendingRatings() async {
    try {
      await RatingBatchService.retryFailedSubmissions(this);
    } catch (e) {
      print('Repository - Error retrying pending ratings: $e');
      // リトライ失敗は静かに処理（ゲーム体験に影響させない）
    }
  }

  // 未送信評価数の取得
  Future<int> getPendingRatingsCount() async {
    return await RatingBatchService.getPendingRatingsCount();
  }

  // 未送信評価があるかチェック
  Future<bool> hasPendingRatings() async {
    return await RatingBatchService.hasPendingRatings();
  }

  // 完全未評価ワード取得（total_rating_count = 0）
  Future<List<KatakanaWord>> getUnratedWords({int limit = 20}) async {
    return _executeQuery(
      () => _supabase
          .from('words')
          .select()
          .eq('total_rating_count', 0)
          .order('RANDOM()')
          .limit(limit),
      shuffle: false, // サーバー側でランダムなのでクライアント側シャッフル不要
    );
  }

  // 評価カウント合計が少ない順でワード取得
  Future<List<KatakanaWord>> getWordsByTotalRatingCountAsc({
    required int limit,
    List<String> excludeIds = const [],
  }) async {
    // 除外IDがある場合は少し多めに取得してクライアントサイドでフィルタリング
    final fetchLimit = excludeIds.isNotEmpty ? limit + excludeIds.length : limit;
    
    final words = await _executeQuery(
      () => _supabase
          .from('words')
          .select()
          .gt('total_rating_count', 0)
          .order('total_rating_count', ascending: true)
          .order('RANDOM()') // 同じtotal_rating_count内でランダム
          .limit(fetchLimit),
      shuffle: false,
    );

    return _filterAndLimitWords(words, excludeIds, limit);
  }

  // 新しいゲーム用ワード取得
  Future<List<KatakanaWord>> getWordsForGame() async {
    try {
      // 1. total_rating_count = 0 のワードをランダムで20件取得
      final unratedWords = await getUnratedWords(limit: 20);
      
      // 2. 不足分をtotal_rating_countが少ない順で補完
      final allWords = await _fillWordsToTarget(
        unratedWords, 
        targetCount: 20,
      );
      
      // 3. 端末キャッシュとの照合と選択
      return await _selectGameWordsFromPool(allWords);
    } catch (e) {
      rethrow; // GameViewModelでキャッチしてローカルフォールバック
    }
  }

  // 共通のクエリ実行処理
  Future<List<KatakanaWord>> _executeQuery(
    Future<dynamic> Function() queryBuilder, {
    bool shuffle = false,
  }) async {
    try {
      final response = await queryBuilder().timeout(
        const Duration(seconds: _queryTimeoutSeconds),
        onTimeout: () => throw TimeoutException(
          'データ取得がタイムアウトしました',
          const Duration(seconds: _queryTimeoutSeconds),
        ),
      );

      final words = (response as List)
          .map((json) => KatakanaWord.fromJson(json))
          .toList();

      return shuffle ? (words..shuffle()) : words;
    } on TimeoutException {
      throw const NetworkException('通信がタイムアウトしました。ネットワーク接続を確認してください。');
    } on PostgrestException catch (e) {
      throw DatabaseException('データベースエラーが発生しました: ${e.message}');
    } on SocketException {
      throw const NetworkException('インターネット接続がありません。接続を確認してください。');
    } catch (e) {
      throw UnknownException('予期しないエラーが発生しました: ${e.toString()}');
    }
  }

  // ワードのフィルタリングと制限
  List<KatakanaWord> _filterAndLimitWords(
    List<KatakanaWord> words,
    List<String> excludeIds,
    int limit,
  ) {
    var filtered = words;
    
    // クライアントサイドで除外IDをフィルタリング
    if (excludeIds.isNotEmpty) {
      filtered = filtered.where((word) => !excludeIds.contains(word.id ?? '')).toList();
    }

    // 必要な件数まで絞り込み
    if (filtered.length > limit) {
      filtered = filtered.take(limit).toList();
    }

    return filtered..shuffle();
  }

  // 目標件数まで補完
  Future<List<KatakanaWord>> _fillWordsToTarget(
    List<KatakanaWord> initialWords,
    {required int targetCount}
  ) async {
    final allWords = [...initialWords];
    
    if (allWords.length < targetCount) {
      final lowRatedWords = await getWordsByTotalRatingCountAsc(
        limit: targetCount - allWords.length,
        excludeIds: allWords.map((w) => w.id ?? '').toList(),
      );
      allWords.addAll(lowRatedWords);
    }
    
    return allWords;
  }

  // プールからゲーム用ワードを選択
  Future<List<KatakanaWord>> _selectGameWordsFromPool(
    List<KatakanaWord> wordPool,
  ) async {
    final usedWordIds = await WordDuplicationService.getUsedWordIds();
    
    // 未使用ワードでフィルタリング
    final unusedWords = wordPool.where((word) => 
      !usedWordIds.contains(word.id ?? '')).toList();
    
    if (unusedWords.length >= _gameWordsSelection) {
      // 未使用ワードで10件確保（サーバー側でランダムなのでシャッフル不要）
      return unusedWords.take(_gameWordsSelection).toList();
    } else {
      // 重複許可モード: 未使用全部 + 足りない分を使用済みから追加
      final gameWords = [...unusedWords];
      
      final usedWords = wordPool.where((word) => 
        usedWordIds.contains(word.id ?? '')).toList();
      final needMore = _gameWordsSelection - unusedWords.length;
      
      gameWords.addAll(usedWords.take(needMore));
      // 混合時のみシャッフル（未使用と使用済みが混在するため）
      return gameWords..shuffle();
    }
  }
}
