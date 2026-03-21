import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qat/core/app_preferences.dart';
import 'package:qat/core/emergency_flow_config.dart';

class _FakeRepository implements EmergencyFlowConfigRepository {
  _FakeRepository(this.config);

  final EmergencyFlowConfig config;

  @override
  Future<EmergencyFlowConfig> fetch() async => config;
}

class _ThrowingRepository implements EmergencyFlowConfigRepository {
  @override
  Future<EmergencyFlowConfig> fetch() async {
    throw StateError('network down');
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('config parsing clamps and normalizes seconds', () {
    final parsed = EmergencyFlowConfig.fromJson({
      'emergencyAutoTriggerSeconds': 99,
    });

    expect(
      parsed.emergencyAutoTriggerSeconds,
      EmergencyFlowConfig.maximumSeconds,
    );
  });

  test('controller starts from cached countdown config', () async {
    final preferences = await AppPreferencesStore.load();
    await preferences.setCachedEmergencyAutoTriggerSeconds(7);

    final controller = EmergencyFlowConfigController(
      preferences: preferences,
    );

    expect(controller.countdownSeconds, 7);
  });

  test('controller refresh stores the latest server config', () async {
    final preferences = await AppPreferencesStore.load();
    final controller = EmergencyFlowConfigController(
      preferences: preferences,
      repository: _FakeRepository(
        const EmergencyFlowConfig(emergencyAutoTriggerSeconds: 5),
      ),
    );

    await controller.refresh();

    expect(controller.countdownSeconds, 5);
    expect(controller.status, EmergencyFlowConfigLoadStatus.ready);

    final reloaded = await AppPreferencesStore.load();
    expect(reloaded.cachedEmergencyAutoTriggerSeconds, 5);
    expect(reloaded.cachedEmergencyConfigFetchedAtMs, isNotNull);
  });

  test('controller falls back to cached config when refresh fails', () async {
    final preferences = await AppPreferencesStore.load();
    await preferences.setCachedEmergencyAutoTriggerSeconds(9);

    final controller = EmergencyFlowConfigController(
      preferences: preferences,
      repository: _ThrowingRepository(),
    );

    await controller.refresh();

    expect(controller.countdownSeconds, 9);
    expect(controller.status, EmergencyFlowConfigLoadStatus.fallback);
  });

  test('repository builder uses same-origin web config when remote URL is absent', () {
    final repository = buildEmergencyFlowConfigRepository(
      rawUrl: '',
      webBaseUri: Uri.parse('https://quickaid.example/app/'),
    );

    expect(repository, isA<HttpEmergencyFlowConfigRepository>());
    expect(
      (repository as HttpEmergencyFlowConfigRepository).uri.toString(),
      'https://quickaid.example/app/config/emergency_flow.json',
    );
  });

  test('repository builder prefers explicit https remote URL when provided', () {
    final repository = buildEmergencyFlowConfigRepository(
      rawUrl: 'https://config.example/emergency_flow.json',
      webBaseUri: Uri.parse('https://quickaid.example/app/'),
    );

    expect(repository, isA<HttpEmergencyFlowConfigRepository>());
    expect(
      (repository as HttpEmergencyFlowConfigRepository).uri.toString(),
      'https://config.example/emergency_flow.json',
    );
  });
}
