import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseService._();

  SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await dotenv.load();

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception('Supabase URL or ANON KEY not found in .env file');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true, // 開発時のみ
    );
  }

  /// Supabaseへの接続状態を確認
  static Future<bool> checkConnection() async {
    try {
      final response = await Supabase.instance.client
          .from('words')
          .select('count')
          .count(CountOption.exact);

      print(
        'SupabaseService - Connection test successful. Total words: ${response.count}',
      );
      return true;
    } catch (e) {
      print('SupabaseService - Connection test failed: $e');
      return false;
    }
  }

  /// 接続情報を取得
  static Map<String, String> getConnectionInfo() {
    return {
      'url': dotenv.env['SUPABASE_URL'] ?? 'Not configured',
      'hasAnonKey': dotenv.env['SUPABASE_ANON_KEY']?.isNotEmpty == true
          ? 'Yes'
          : 'No',
    };
  }
}
