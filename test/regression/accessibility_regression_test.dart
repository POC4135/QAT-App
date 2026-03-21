import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/app_test_harness.dart';

void main() {
  testWidgets('accessibility mode persists across restart', (tester) async {
    await pumpApp(tester, initialPrefs: {'accessibility_mode': true});

    expect(find.text('Sign in to get help fast'), findsOneWidget);
  });

  testWidgets('accessibility emergency flow keeps one extra action visible', (
    tester,
  ) async {
    await pumpApp(
      tester,
      initialPrefs: {'accessibility_mode': true},
      emergencyFlowConfigController: fixedEmergencyConfigController(),
    );
    await signIn(tester);

    await openEmergencyChoice(tester);
    await tester.ensureVisible(find.byKey(const ValueKey('emergency-choice-soft')));
    await tester.tap(find.byKey(const ValueKey('emergency-choice-soft')));
    await tester.pump();
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Acknowledge'), findsOneWidget);
    expect(find.text('Cancel false alarm'), findsOneWidget);
    expect(find.text('Call Primary Contact'), findsNothing);

    await tester.ensureVisible(find.text('Acknowledge'));
    await tester.tap(find.text('Acknowledge'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsNothing);
    expect(find.text('Mark resolved'), findsOneWidget);
  });

  testWidgets('accessibility home removes secondary sections', (tester) async {
    await pumpApp(tester, initialPrefs: {'accessibility_mode': true});
    await signIn(tester);

    await openAccessibilityTab(tester, 'a11y-tab-home');

    expect(find.text('Need help now?'), findsOneWidget);
    expect(find.text('System OK'), findsOneWidget);
    expect(find.text('Open devices'), findsOneWidget);
    expect(find.text('More details'), findsNothing);
    expect(find.text('Primary contacts'), findsNothing);
    expect(find.text('Device highlights'), findsNothing);
  });

  testWidgets('other hub shows all secondary destinations and opens them', (
    tester,
  ) async {
    await pumpApp(tester, initialPrefs: {'accessibility_mode': true});
    await signIn(tester);

    await openAccessibilityTab(tester, 'a11y-tab-other');

    expect(find.text('Emergency contacts'), findsOneWidget);
    expect(find.text('History'), findsWidgets);
    expect(find.text('Devices'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Help & support'), findsWidgets);
    expect(find.text('Sign out'), findsWidgets);

    await tester.ensureVisible(find.byKey(const ValueKey('other-entry-devices')));
    await tester.tap(find.byKey(const ValueKey('other-entry-devices')));
    await tester.pumpAndSettle();
    expect(find.text('Devices'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('other-entry-history')));
    await tester.tap(find.byKey(const ValueKey('other-entry-history')));
    await tester.pumpAndSettle();
    expect(find.text('History'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('other-entry-profile')));
    await tester.tap(find.byKey(const ValueKey('other-entry-profile')));
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsWidgets);
  });

  testWidgets('accessibility shell stays readable on a narrow screen with large text', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await pumpApp(tester, initialPrefs: {'accessibility_mode': true});
      await signIn(tester);

      expect(find.byKey(const ValueKey('a11y-tab-home')), findsOneWidget);
      expect(find.byKey(const ValueKey('a11y-tab-other')), findsOneWidget);
      expect(find.bySemanticsLabel('Open Home tab'), findsOneWidget);
      expect(find.bySemanticsLabel('Open Other tab'), findsOneWidget);
      expect(find.bySemanticsLabel('Open History tab'), findsNothing);
      expect(find.bySemanticsLabel('Open Devices tab'), findsNothing);
      expect(find.bySemanticsLabel('Open Profile tab'), findsNothing);
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });
}
