import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/app_test_harness.dart';

void main() {
  testWidgets('home opens emergency flow in one tap and reaches active status', (
    tester,
  ) async {
    await pumpApp(
      tester,
      emergencyFlowConfigController: fixedEmergencyConfigController(),
    );
    await signIn(tester);

    await openEmergencyChoice(tester);

    expect(find.text('Choose emergency type'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('emergency-choice-soft')));
    await tester.tap(find.byKey(const ValueKey('emergency-choice-soft')));
    await tester.pump();
    await tester.ensureVisible(find.text('Continue to emergency status'));
    await tester.tap(find.text('Continue to emergency status'));
    await tester.pumpAndSettle();

    expect(find.text('Emergency status'), findsWidgets);
    expect(find.text('Acknowledge'), findsOneWidget);
  });

  testWidgets('active emergency can be acknowledged and then resolved', (
    tester,
  ) async {
    await pumpApp(
      tester,
      emergencyFlowConfigController: fixedEmergencyConfigController(),
    );
    await signIn(tester);

    await openEmergencyChoice(tester);
    await tester.ensureVisible(find.byKey(const ValueKey('emergency-choice-soft')));
    await tester.tap(find.byKey(const ValueKey('emergency-choice-soft')));
    await tester.pump();
    await tester.ensureVisible(find.text('Continue to emergency status'));
    await tester.tap(find.text('Continue to emergency status'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Acknowledge'));
    await tester.pumpAndSettle();
    expect(find.text('Mark resolved'), findsOneWidget);

    await tester.tap(find.text('Mark resolved'));
    await tester.pumpAndSettle();
    expect(find.text('Back to Home'), findsOneWidget);
  });
}
