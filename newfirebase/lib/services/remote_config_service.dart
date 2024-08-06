import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class FirebaseRemoteConfigService {
  FirebaseRemoteConfigService._()
      : _remoteConfig = FirebaseRemoteConfig.instance;

  static FirebaseRemoteConfigService? _instance;
  factory FirebaseRemoteConfigService() =>
      _instance ??= FirebaseRemoteConfigService._();

  final FirebaseRemoteConfig _remoteConfig;
  String getString(String key) => _remoteConfig.getString(key); // string
  bool getBool(String key) => _remoteConfig.getBool(key); // bool
  int getInt(String key) => _remoteConfig.getInt(key); // ınt
  double getDouble(String key) => _remoteConfig.getDouble(key); // double
  //config
  Future<void> _setConfigSettings() async => _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );

  Future<void> fetchAndActivate() async {
    bool updated = await _remoteConfig.fetchAndActivate();

    if (updated) {
      debugPrint('The config has been updated.'); // ayarlar güncellendi
    } else {
      debugPrint('The config is not updated..'); // ayarlar güncellenmedi
    }
  }

//mainde uygulama içi kullanım
  Future<void> initialize() async {
    await _setConfigSettings();
    //await _setDefaults();
    await fetchAndActivate();
  }
}

//değişkenler
class FirebaseRemoteConfigKeys {
  static const String welcomeMessage = 'welcome_message';
  static const String imageVisibility = 'images_visibilty';
}
