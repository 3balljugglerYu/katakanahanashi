import 'dart:async';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/simple_rating.dart';
import '../models/word_rating.dart';
import '../services/supabase_service.dart';
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

  // 評価を送信（直接wordsテーブルを更新）
  Future<void> submitRating(SimpleRating rating) async {
    try {
      print('Repository - Submitting rating for wordId: ${rating.wordId}');
      
      // RPC関数を使用して更新（SQLインジェクション対策）
      await _supabase.rpc('update_word_rating', params: {
        'p_word_id': rating.wordId,
        'p_difficulty': rating.difficulty.name,
        'p_is_good': rating.isGood,
        'p_is_bad': rating.isBad,
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('評価の送信がタイムアウトしました', const Duration(seconds: 10)),
      );
      
      print('Repository - Successfully updated word stats');
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
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException('データ取得がタイムアウトしました', const Duration(seconds: 15)),
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
}