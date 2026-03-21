import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qat/core/app_routes.dart';
import 'package:qat/core/app_state.dart';
import 'package:qat/core/app_theme.dart';
import 'package:qat/core/emergency_flow_config.dart';
import 'package:qat/core/launch_service.dart';
import 'package:qat/models/emergency_incident.dart';

class _FakeLaunchService implements LaunchService {
  const _FakeLaunchService();

  @override
  Future<LaunchResult> launch(
    Uri uri, {
    required String failureMessage,
  }) async {
    return const LaunchResult.success();
  }
}

void main() {
  Future<void> pumpRouterApp(
    WidgetTester tester, {
    required AppStateController state,
    required String initialRoute,
    GlobalKey<NavigatorState>? navigatorKey,
  }) async {
    await tester.pumpWidget(
      EmergencyFlowConfigScope(
        notifier: EmergencyFlowConfigController(
          initialConfig: const EmergencyFlowConfig(
            emergencyAutoTriggerSeconds: 6,
          ),
        ),
        child: AppStateScope(
          notifier: state,
          child: LaunchServiceScope(
            service: const _FakeLaunchService(),
            child: MaterialApp(
              navigatorKey: navigatorKey,
              theme: buildQatTheme(
                accessibilityMode: state.account.accessibilityMode,
                reducedMotion: false,
              ),
              onGenerateRoute: (settings) =>
                  AppRouter.onGenerateRoute(settings, state),
              initialRoute: initialRoute,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('protected routes redirect to landing when signed out', (
    tester,
  ) async {
    final state = AppStateController();

    await pumpRouterApp(
      tester,
      state: state,
      initialRoute: AppRoutes.home,
    );

    expect(find.text('QuickAid resident access'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('missing history detail routes show a safe fallback screen', (
    tester,
  ) async {
    final state = AppStateController()..signIn('Anca');
    final navigatorKey = GlobalKey<NavigatorState>();

    await pumpRouterApp(
      tester,
      state: state,
      initialRoute: AppRoutes.home,
      navigatorKey: navigatorKey,
    );

    navigatorKey.currentState!.pushNamed(
      AppRoutes.historyDetail,
      arguments: 'missing-history-id',
    );
    await tester.pumpAndSettle();

    expect(find.text('History item unavailable'), findsOneWidget);
    expect(find.text('Open history'), findsOneWidget);
  });

  testWidgets('accessibility mode keeps history, devices, and profile routes valid', (
    tester,
  ) async {
    final state = AppStateController()
      ..signIn('Anca')
      ..setAccessibilityMode(true);

    await pumpRouterApp(
      tester,
      state: state,
      initialRoute: AppRoutes.devices,
    );

    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('Devices'), findsWidgets);
  });

  testWidgets('active incident skips the countdown screen and opens help status', (
    tester,
  ) async {
    final state = AppStateController()
      ..signIn('Anca')
      ..startEmergency(IncidentKind.hard);

    await pumpRouterApp(
      tester,
      state: state,
      initialRoute: AppRoutes.emergencyChoice,
    );

    expect(find.text('Emergency status'), findsWidgets);
    expect(find.text('Hard emergency active'), findsOneWidget);
  });
}
