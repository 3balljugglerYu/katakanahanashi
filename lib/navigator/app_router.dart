import 'package:flutter/material.dart';

import 'package:katakanahanashi/ui/home/game/game_page.dart';
import 'package:katakanahanashi/ui/home/start/start_page.dart';
import 'package:katakanahanashi/ui/onboarding/onboarding_page.dart';
import 'package:katakanahanashi/ui/splash/splash_page.dart';

class AppRouter {
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String startRoute = '/start';
  static const String gameRoute = '/game';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case onboardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case startRoute:
        return MaterialPageRoute(builder: (_) => const StartPage());
      case gameRoute:
        return MaterialPageRoute(builder: (_) => const GamePage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('ページが見つかりません'))),
        );
    }
  }
}
