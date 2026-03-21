import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qat/core/app_preferences.dart';
import 'package:qat/core/app_state.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('accessibility preference persists across reloads', () async {
    final store = await AppPreferencesStore.load();

    expect(store.accessibilityMode, isFalse);

    await store.setAccessibilityMode(true);

    final reloaded = await AppPreferencesStore.load();
    expect(reloaded.accessibilityMode, isTrue);
  });

  test('app state writes accessibility changes to preferences', () async {
    final store = await AppPreferencesStore.load();
    final state = AppStateController(preferences: store);

    state.setAccessibilityMode(true);
    await Future<void>.delayed(Duration.zero);

    final reloaded = await AppPreferencesStore.load();
    expect(reloaded.accessibilityMode, isTrue);
  });

  test('offline and exclamation preferences persist across reloads', () async {
    final store = await AppPreferencesStore.load();

    await store.setOfflineMode(true);
    await store.setExclamationMode(false);

    final reloaded = await AppPreferencesStore.load();
    expect(reloaded.offlineMode, isTrue);
    expect(reloaded.exclamationMode, isFalse);
  });

  test('cached emergency countdown config persists across reloads', () async {
    final store = await AppPreferencesStore.load();

    await store.setCachedEmergencyAutoTriggerSeconds(14);
    await store.setCachedEmergencyConfigFetchedAtMs(123456789);

    final reloaded = await AppPreferencesStore.load();
    expect(reloaded.cachedEmergencyAutoTriggerSeconds, 14);
    expect(reloaded.cachedEmergencyConfigFetchedAtMs, 123456789);
  });
}
