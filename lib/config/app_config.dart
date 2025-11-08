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

  static const String _sharedSubscriptionProductId =
      'com.kotoba.kakurenbo.playease.monthly';
  static const String _androidMockSubscriptionProductId =
      'com.example.mock.monthly';
  static const String _androidPackageBase = 'com.kotoba.kakurenbo';

  static String get iosSubscriptionProductId => _sharedSubscriptionProductId;

  static String get androidSubscriptionProductId {
    switch (_environment) {
      case Environment.production:
        return _sharedSubscriptionProductId;
      case Environment.development:
      case Environment.staging:
        return _androidMockSubscriptionProductId;
    }
  }

  static bool get isMockBillingEnabled {
    switch (_environment) {
      case Environment.production:
        return false;
      case Environment.development:
      case Environment.staging:
        return true;
    }
  }

  static String get androidPackageName {
    switch (_environment) {
      case Environment.production:
        return _androidPackageBase;
      case Environment.staging:
        return '${_androidPackageBase}.stg';
      case Environment.development:
        return '${_androidPackageBase}.dev';
    }
  }

  static const String privacyPolicyUrl =
      'https://snow-office-293.notion.site/2752ae7bded2801887f8e244676bccb1';

  static const String termsOfUseUrl =
      'https://snow-office-293.notion.site/29b2ae7bded280ff8508d31bbf337289';
}
