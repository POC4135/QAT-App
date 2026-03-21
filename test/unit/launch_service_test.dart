import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qat/core/launch_service.dart';

class _RecordingLaunchService implements LaunchService {
  _RecordingLaunchService(this.result);

  final LaunchResult result;
  Uri? lastUri;
  String? lastFailureMessage;

  @override
  Future<LaunchResult> launch(
    Uri uri, {
    required String failureMessage,
  }) async {
    lastUri = uri;
    lastFailureMessage = failureMessage;
    return result;
  }
}

void main() {
  testWidgets('launch helper shows a dialog when an action fails', (
    tester,
  ) async {
    final service = _RecordingLaunchService(
      const LaunchResult.failure(
        'We could not place that call from this device.',
      ),
    );

    await tester.pumpWidget(
      LaunchServiceScope(
        service: service,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: FilledButton(
                    onPressed: () => launchPhoneCall(
                      context,
                      '+1 404 555 0101',
                      failureMessage:
                          'We could not place that call from this device.',
                    ),
                    child: const Text('Call'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Call'));
    await tester.pumpAndSettle();

    expect(service.lastUri.toString(), 'tel:+1%20404%20555%200101');
    expect(find.text('Action unavailable'), findsOneWidget);
    expect(
      find.text('We could not place that call from this device.'),
      findsOneWidget,
    );
  });

  testWidgets('launch helper stays quiet when an action succeeds', (
    tester,
  ) async {
    final service = _RecordingLaunchService(const LaunchResult.success());

    await tester.pumpWidget(
      LaunchServiceScope(
        service: service,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: FilledButton(
                    onPressed: () => launchWebsiteLink(
                      context,
                      'https://quickaidtech.com/',
                    ),
                    child: const Text('Open site'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open site'));
    await tester.pumpAndSettle();

    expect(service.lastUri.toString(), 'https://quickaidtech.com/');
    expect(find.text('Action unavailable'), findsNothing);
  });
}
