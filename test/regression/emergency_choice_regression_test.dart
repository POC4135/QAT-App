import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/app_test_harness.dart';

void main() {
  testWidgets('emergency choice defaults to hard and auto triggers after countdown', (
    tester,
  ) async {
    await pumpApp(
      tester,
      emergencyFlowConfigController: fixedEmergencyConfigController(3),
    );
    await signIn(tester);

    await openEmergencyChoice(tester);

    expect(
      tester.getTopLeft(find.text('Hard emergency')).dy,
      lessThan(tester.getTopLeft(find.text('Soft emergency')).dy),
    );
    expect(find.text('3s'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Hard emergency active'), findsOneWidget);
    expect(find.text('Acknowledge'), findsOneWidget);
  });

  testWidgets('emergency choice cancel returns home without triggering help', (
    tester,
  ) async {
    await pumpApp(
      tester,
      emergencyFlowConfigController: fixedEmergencyConfigController(4),
    );
    await signIn(tester);

    await openEmergencyChoice(tester);
    await tester.ensureVisible(find.byKey(const ValueKey('emergency-choice-cancel')));
    await tester.tap(find.byKey(const ValueKey('emergency-choice-cancel')));
    await tester.pumpAndSettle();

    expect(find.text('Need help now?'), findsOneWidget);
    expect(find.text('System OK'), findsOneWidget);
    expect(find.text('Emergency status'), findsNothing);
  });

  testWidgets('emergency choice back stops countdown and returns home', (
    tester,
  ) async {
    await pumpApp(
      tester,
      emergencyFlowConfigController: fixedEmergencyConfigController(4),
    );
    await signIn(tester);

    await openEmergencyChoice(tester);
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Need help now?'), findsOneWidget);
    expect(find.text('System OK'), findsOneWidget);
    expect(find.text('Emergency status'), findsNothing);
  });

  testWidgets('switching to soft before timeout auto triggers soft emergency', (
    tester,
  ) async {
    await pumpApp(
      tester,
      emergencyFlowConfigController: fixedEmergencyConfigController(3),
    );
    await signIn(tester);

    await openEmergencyChoice(tester);
    await tester.ensureVisible(find.byKey(const ValueKey('emergency-choice-soft')));
    await tester.tap(find.byKey(const ValueKey('emergency-choice-soft')));
    await tester.pump();

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Soft emergency active'), findsOneWidget);
    expect(find.text('Acknowledge'), findsOneWidget);
  });
}
