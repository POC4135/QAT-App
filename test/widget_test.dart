import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qat/main.dart';

void main() {
  Future<void> signIn(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField).at(0), 'Anca');
    await tester.enterText(find.byType(TextField).at(1), 'password');
    await tester.ensureVisible(find.text('Sign In'));
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
  }

  testWidgets('landing screen signs in to the tab shell', (tester) async {
    await tester.pumpWidget(const QuickAidRoot());
    await tester.pumpAndSettle();

    expect(find.text('QuickAid resident access'), findsOneWidget);

    await signIn(tester);

    expect(find.text('Home'), findsWidgets);
    expect(find.text('History'), findsWidgets);
    expect(find.text('Devices'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
    expect(find.textContaining('System'), findsWidgets);
  });

  testWidgets('home reaches emergency flow in one tap', (tester) async {
    await tester.pumpWidget(const QuickAidRoot());
    await tester.pumpAndSettle();

    await signIn(tester);

    await tester.tap(find.text('Start emergency alert'));
    await tester.pumpAndSettle();

    expect(find.text('Choose emergency type'), findsOneWidget);

    await tester.tap(find.text('Soft emergency'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Continue to emergency status'));
    await tester.tap(find.text('Continue to emergency status'));
    await tester.pumpAndSettle();

    expect(find.text('Emergency status'), findsWidgets);
    expect(find.text('Acknowledge'), findsOneWidget);
  });

  testWidgets('active emergency can be acknowledged and then resolved', (
    tester,
  ) async {
    await tester.pumpWidget(const QuickAidRoot());
    await tester.pumpAndSettle();

    await signIn(tester);

    await tester.tap(find.text('Start emergency alert'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Soft emergency'));
    await tester.pumpAndSettle();
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

  testWidgets('active emergency can be cancelled as a false alarm', (
    tester,
  ) async {
    await tester.pumpWidget(const QuickAidRoot());
    await tester.pumpAndSettle();

    await signIn(tester);

    await tester.tap(find.text('Start emergency alert'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Soft emergency'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Continue to emergency status'));
    await tester.tap(find.text('Continue to emergency status'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel alert'));
    await tester.pumpAndSettle();
    expect(find.text('Back to Home'), findsOneWidget);
    expect(find.text('Emergency closed'), findsOneWidget);
  });

  testWidgets('history and profile drill-ins are reachable', (tester) async {
    await tester.pumpWidget(const QuickAidRoot());
    await tester.pumpAndSettle();

    await signIn(tester);

    await tester.tap(find.text('History').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Smoke alert in kitchen'));
    await tester.pumpAndSettle();
    expect(find.text('Incident details'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();

    expect(find.text('Emergency contacts'), findsOneWidget);
  });

  testWidgets('offline mode shows degraded-state fallback on home', (
    tester,
  ) async {
    await tester.pumpWidget(const QuickAidRoot());
    await tester.pumpAndSettle();

    await signIn(tester);

    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Settings'));
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(Switch).first);
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();

    expect(find.text('Offline — showing last known status'), findsOneWidget);
    expect(find.text('Call primary contact'), findsOneWidget);
  });
}
