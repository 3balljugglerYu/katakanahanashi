enum Environment { development, staging, production }

class AppConfig {
  static Environment _environment = Environment.development;

  static Environment get environment => _environment;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  // 広告ID設定
  static String get androidInterstitialAdUnitId {
    switch (_environment) {
      case Environment.development:
      case Environment.staging:
        // テスト用広告ID
        return 'ca-app-pub-3940256099942544/1033173712';
      case Environment.production:
        // 本番用広告ID
        return 'ca-app-pub-2716829166250639/3387528627';
    }
  }

  static String get iosInterstitialAdUnitId {
    switch (_environment) {
      case Environment.development:
      case Environment.staging:
        // テスト用広告ID
        return 'ca-app-pub-3940256099942544/4411468910';
      case Environment.production:
        // 本番用広告ID
        return 'ca-app-pub-2716829166250639/9936269880';
    }
  }

  // アプリ名
  static String get appName {
    switch (_environment) {
      case Environment.development:
        return 'ことばかくれんぼ (Dev)';
      case Environment.staging:
        return 'ことばかくれんぼ (Stg)';
      case Environment.production:
        return 'ことばかくれんぼ';
    }
  }

  // デバッグ設定
  static bool get isDebugMode {
    switch (_environment) {
      case Environment.development:
      case Environment.staging:
        return true;
      case Environment.production:
        return false;
    }
  }
}
