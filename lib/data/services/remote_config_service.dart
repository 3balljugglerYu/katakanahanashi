import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:katakanahanashi/config/app_config.dart';

class RemoteConfigService {
  RemoteConfigService._({
    FirebaseRemoteConfig? remoteConfig,
    Map<String, Object>? fallbackValues,
  }) : _remoteConfig = remoteConfig,
       _fallbackStore = fallbackValues ?? _defaultValues;

  factory RemoteConfigService.firebase(FirebaseRemoteConfig remoteConfig) {
    return RemoteConfigService._(remoteConfig: remoteConfig);
  }

  factory RemoteConfigService.fallback({Map<String, Object>? defaults}) {
    return RemoteConfigService._(
      fallbackValues: {..._defaultValues, if (defaults != null) ...defaults},
    );
  }

  static const String showSubscriptionButtonKey = 'show_subscription_button';

  static const Map<String, Object> _defaultValues = {
    showSubscriptionButtonKey: true,
  };

  final FirebaseRemoteConfig? _remoteConfig;
  final Map<String, Object> _fallbackStore;

  Future<void> initialize() async {
    if (_remoteConfig == null) {
      return;
    }

    final minimumFetchInterval = _minimumFetchInterval();
    await _remoteConfig!.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: minimumFetchInterval,
      ),
    );

    await _remoteConfig!.setDefaults(_defaultValues);

    try {
      await _remoteConfig!.fetchAndActivate();
    } catch (error, stackTrace) {
      debugPrint('RemoteConfig fetch failed: $error');
      debugPrint('$stackTrace');
      // Defaults remain active when fetch fails.
    }
  }

  bool get showSubscriptionButton {
    if (_remoteConfig == null) {
      return _fallbackStore[showSubscriptionButtonKey] as bool? ?? true;
    }
    return _remoteConfig!.getBool(showSubscriptionButtonKey);
  }

  Future<void> forceRefresh() async {
    if (_remoteConfig == null) {
      return;
    }

    try {
      await _remoteConfig!.fetchAndActivate();
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
