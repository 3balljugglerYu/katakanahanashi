import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:katakanahanashi/config/app_config.dart';

class RemoteConfigService {
  RemoteConfigService(this._remoteConfig);

  static const String showSubscriptionButtonKey = 'show_subscription_button';

  static const Map<String, Object> _defaultValues = {
    showSubscriptionButtonKey: true,
  };

  final FirebaseRemoteConfig _remoteConfig;

  Future<void> initialize() async {
    final minimumFetchInterval = _minimumFetchInterval();
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: minimumFetchInterval,
      ),
    );

    await _remoteConfig.setDefaults(_defaultValues);

    try {
      await _remoteConfig.fetchAndActivate();
    } catch (error, stackTrace) {
      debugPrint('RemoteConfig fetch failed: $error');
      debugPrint('$stackTrace');
      // Defaults remain active when fetch fails.
    }
  }

  bool get showSubscriptionButton =>
      _remoteConfig.getBool(showSubscriptionButtonKey);

  Future<void> forceRefresh() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (error) {
      debugPrint('RemoteConfig forceRefresh failed: $error');
    }
  }

  Duration _minimumFetchInterval() {
    switch (AppConfig.environment) {
      case Environment.development:
      case Environment.staging:
        return Duration.zero;
      case Environment.production:
        return const Duration(hours: 1);
    }
  }
}

final remoteConfigServiceProvider = Provider<RemoteConfigService>((ref) {
  throw UnimplementedError('RemoteConfigService must be overridden at runtime');
});
