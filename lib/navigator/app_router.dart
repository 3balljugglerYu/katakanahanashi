import 'package:flutter/material.dart';
import '../ui/home/start_page.dart';
import '../ui/home/game_page.dart';

class AppRouter {
  static const String startRoute = '/';
  static const String gameRoute = '/game';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case startRoute:
        return MaterialPageRoute(builder: (_) => const StartPage());
      case gameRoute:
        return MaterialPageRoute(builder: (_) => const GamePage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('ページが見つかりません'),
            ),
          ),
        );
    }
  }
}