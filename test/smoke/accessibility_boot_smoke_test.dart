import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/app_test_harness.dart';

void main() {
  testWidgets('accessibility mode updates the shell immediately', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await pumpApp(tester);
      await signIn(tester);

      await openAccessibilityMode(tester);

      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byKey(const ValueKey('a11y-tab-home')), findsOneWidget);
      expect(find.byKey(const ValueKey('a11y-tab-other')), findsOneWidget);
      expect(find.bySemanticsLabel('Open Home tab'), findsOneWidget);
      expect(find.bySemanticsLabel('Open Other tab'), findsOneWidget);
      expect(find.text('Other'), findsWidgets);
    } finally {
      semantics.dispose();
    }
  });
}
