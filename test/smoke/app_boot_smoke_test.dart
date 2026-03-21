import 'package:flutter_test/flutter_test.dart';

import '../support/app_test_harness.dart';

void main() {
  testWidgets('landing loads and sign in reaches the main shell', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('QuickAid resident access'), findsOneWidget);

    await signIn(tester);

    expect(find.text('Home'), findsWidgets);
    expect(find.text('History'), findsWidgets);
    expect(find.text('Devices'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
    expect(find.textContaining('System'), findsWidgets);
  });
}
