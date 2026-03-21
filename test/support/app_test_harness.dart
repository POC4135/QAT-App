import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qat/core/app_preferences.dart';
import 'package:qat/core/emergency_flow_config.dart';
import 'package:qat/main.dart';

Future<AppPreferencesStore> loadPrefs([
  Map<String, Object> values = const {},
]) async {
  SharedPreferences.setMockInitialValues(values);
  return AppPreferencesStore.load();
}

Future<void> pumpApp(
  WidgetTester tester, {
  Map<String, Object> initialPrefs = const {},
  EmergencyFlowConfigController? emergencyFlowConfigController,
}) async {
  final prefs = await loadPrefs(initialPrefs);
  await tester.pumpWidget(
    QuickAidRoot(
      preferences: prefs,
      emergencyFlowConfigController: emergencyFlowConfigController,
    ),
  );
  await tester.pumpAndSettle();
}

EmergencyFlowConfigController fixedEmergencyConfigController([
  int seconds = 6,
]) {
  return EmergencyFlowConfigController(
    initialConfig: EmergencyFlowConfig(
      emergencyAutoTriggerSeconds: seconds,
    ),
  );
}

Future<void> signIn(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).at(0), 'Anca');
  await tester.enterText(find.byType(TextField).at(1), 'password');
  await tester.ensureVisible(find.text('Sign In'));
  await tester.tap(find.text('Sign In'));
  await tester.pumpAndSettle();
}

Future<void> openEmergencyChoice(WidgetTester tester) async {
  await tester.ensureVisible(find.byIcon(Icons.emergency_rounded).last);
  await tester.tap(find.byIcon(Icons.emergency_rounded).last);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> openAccessibilityMode(WidgetTester tester) async {
  await tester.tap(find.text('Profile').last);
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('Accessibility Mode'));
  await tester.tap(find.text('Accessibility Mode'));
  await tester.pumpAndSettle();
}

Future<void> openAccessibilityTab(
  WidgetTester tester,
  String keyValue,
) async {
  final finder = find.byKey(ValueKey(keyValue));
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
