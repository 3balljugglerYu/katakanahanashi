import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/simple_rating.dart';
import '../repositories/word_rating_repository.dart';

class BatchSubmissionResult {
  final List<SimpleRating> succeeded;
  final List<SimpleRating> failed;
  final String? errorMessage;

  const BatchSubmissionResult({
    required this.succeeded,
    required this.failed,
    this.errorMessage,
  });

  bool get isPartialSuccess => succeeded.isNotEmpty && failed.isNotEmpty;
  bool get isComplete => failed.isEmpty;
  bool get hasError => errorMessage != null;

  @override
  String toString() {
    return 'BatchSubmissionResult(succeeded: ${succeeded.length}, failed: ${failed.length}, error: $errorMessage)';
  }
}

class RatingBatchService {
  static const String _storageKey = 'pending_ratings_v1';
  static const int _maxPendingRatings = 100; // 最大保存数

  static Future<void> savePendingRating(SimpleRating rating) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existing = await getPendingRatings();
      
      // 重複チェック（同じwordIdとタイムスタンプ）
      final isDuplicate = existing.any((r) => 
        r.wordId == rating.wordId && 
        r.createdAt.difference(rating.createdAt).abs().inSeconds < 1
      );
      
      if (isDuplicate) {
        return;
      }
      
      existing.add(rating);
      
      // 容量制限チェック
      if (existing.length > _maxPendingRatings) {
        existing.removeRange(0, existing.length - _maxPendingRatings);
      }
      
      final jsonList = existing.map((r) => r.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<SimpleRating>> getPendingRatings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => SimpleRating.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<BatchSubmissionResult> submitBatch(
    List<SimpleRating> ratings,
    WordRatingRepository repository,
  ) async {
    if (ratings.isEmpty) {
      return const BatchSubmissionResult(succeeded: [], failed: []);
    }

    final List<SimpleRating> succeeded = [];
    final List<SimpleRating> failed = [];
    String? lastError;

    for (final rating in ratings) {
      try {
        // ローカルワード（local_で始まる）はスキップ
        if (rating.wordId.startsWith('local_')) {
          succeeded.add(rating);
          continue;
        }

        await repository.submitRating(rating);
        succeeded.add(rating);
        
        // 各送信間で少し待機（サーバー負荷軽減）
        await Future.delayed(const Duration(milliseconds: 50));
        
      } on NetworkException catch (e) {
        failed.add(rating);
        lastError = e.message;
        // ネットワークエラーの場合、残りも失敗する可能性が高いので中断
        failed.addAll(ratings.skip(ratings.indexOf(rating) + 1));
        break;
      } on DatabaseException catch (e) {
        failed.add(rating);
        lastError = e.message;
        // データベースエラーは個別の問題の可能性があるので継続
      } on SocketException {
        failed.add(rating);
        lastError = 'ネットワーク接続エラー';
        // 接続エラーの場合、残りも失敗する可能性が高いので中断
        failed.addAll(ratings.skip(ratings.indexOf(rating) + 1));
        break;
      } catch (e) {
        failed.add(rating);
        lastError = '予期しないエラー: ${e.toString()}';
      }
    }

    final result = BatchSubmissionResult(
      succeeded: succeeded,
      failed: failed,
      errorMessage: lastError,
    );

    return result;
  }

  static Future<void> updatePendingRatings(List<SimpleRating> newPendingList) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (newPendingList.isEmpty) {
        await prefs.remove(_storageKey);
      } else {
        final jsonList = newPendingList.map((r) => r.toJson()).toList();
        await prefs.setString(_storageKey, jsonEncode(jsonList));
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> clearPendingRatings() async {
    await updatePendingRatings([]);
  }

  static Future<int> getPendingRatingsCount() async {
    final ratings = await getPendingRatings();
    return ratings.length;
  }

  static Future<bool> hasPendingRatings() async {
    final count = await getPendingRatingsCount();
    return count > 0;
  }

  static Future<void> retryFailedSubmissions(WordRatingRepository repository) async {
    final pending = await getPendingRatings();
    if (pending.isEmpty) return;

    
    final result = await submitBatch(pending, repository);
    
    // 成功した分を削除、失敗した分は保持
    await updatePendingRatings(result.failed);
    
    if (result.isComplete) {
    } else {
    }
  }
}