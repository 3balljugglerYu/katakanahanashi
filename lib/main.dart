import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'locator.dart';
import 'ui/app.dart';
import 'data/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Supabase初期化
  await SupabaseService.initialize();
  
  setupLocator();
  runApp(const ProviderScope(child: KatakanaNashiApp()));
}
