import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesStore {
  AppPreferencesStore(this._preferences);

  static const _accessibilityModeKey = 'accessibility_mode';
  static const _exclamationModeKey = 'exclamation_mode';
  static const _offlineModeKey = 'offline_mode';
  static const _onboardingCompleteKey = 'onboarding_complete';
  static const _cachedEmergencyAutoTriggerSecondsKey =
      'cached_emergency_auto_trigger_seconds';
  static const _cachedEmergencyConfigFetchedAtKey =
      'cached_emergency_config_fetched_at_ms';

  final SharedPreferences _preferences;

  static Future<AppPreferencesStore> load() async {
    final preferences = await SharedPreferences.getInstance();
    return AppPreferencesStore(preferences);
  }

  bool get accessibilityMode =>
      _preferences.getBool(_accessibilityModeKey) ?? false;
  bool get exclamationMode =>
      _preferences.getBool(_exclamationModeKey) ?? true;
  bool get offlineMode => _preferences.getBool(_offlineModeKey) ?? false;
  bool get onboardingComplete =>
      _preferences.getBool(_onboardingCompleteKey) ?? false;
  int? get cachedEmergencyAutoTriggerSeconds =>
      _preferences.getInt(_cachedEmergencyAutoTriggerSecondsKey);
  int? get cachedEmergencyConfigFetchedAtMs =>
      _preferences.getInt(_cachedEmergencyConfigFetchedAtKey);

  Future<void> setAccessibilityMode(bool value) {
    return _preferences.setBool(_accessibilityModeKey, value);
  }

  Future<void> setExclamationMode(bool value) {
    return _preferences.setBool(_exclamationModeKey, value);
  }

  Future<void> setOfflineMode(bool value) {
    return _preferences.setBool(_offlineModeKey, value);
  }

  Future<void> setOnboardingComplete(bool value) {
    return _preferences.setBool(_onboardingCompleteKey, value);
  }

  Future<void> setCachedEmergencyAutoTriggerSeconds(int value) {
    return _preferences.setInt(_cachedEmergencyAutoTriggerSecondsKey, value);
  }

  Future<void> setCachedEmergencyConfigFetchedAtMs(int value) {
    return _preferences.setInt(_cachedEmergencyConfigFetchedAtKey, value);
  }
}
