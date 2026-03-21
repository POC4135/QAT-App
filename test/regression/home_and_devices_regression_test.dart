import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qat/widgets/device_status_card.dart';

import '../support/app_test_harness.dart';

void main() {
  testWidgets('home shows device highlights in a two-up grid in normal mode', (
    tester,
  ) async {
    await pumpApp(tester);
    await signIn(tester);

    expect(find.byKey(const ValueKey('home-device-highlights-grid')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('home-device-highlights-grid')),
        matching: find.byType(DeviceStatusCard),
      ),
      findsNWidgets(2),
    );
  });

  testWidgets('offline mode shows degraded-state fallback on home', (
    tester,
  ) async {
    await pumpApp(tester);
    await signIn(tester);

    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Settings'));
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Offline mode'));
    await tester.tap(find.text('Offline mode'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();

    expect(find.text('Offline — showing last known status'), findsOneWidget);
    expect(find.text('Call primary contact'), findsOneWidget);
  });

  testWidgets('accessibility home device issue button opens devices screen', (
    tester,
  ) async {
    await pumpApp(tester, initialPrefs: {'accessibility_mode': true});
    await signIn(tester);

    await tester.ensureVisible(find.text('Open devices'));
    await tester.tap(find.text('Open devices'));
    await tester.pumpAndSettle();

    expect(find.text('Devices'), findsWidgets);
    expect(find.text('Run system test'), findsOneWidget);
  });
}
