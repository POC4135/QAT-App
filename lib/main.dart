import 'dart:async';

import 'package:flutter/material.dart';

import 'core/emergency_flow_config.dart';
import 'core/app_preferences.dart';
import 'core/app_routes.dart';
import 'core/app_state.dart';
import 'core/app_theme.dart';
import 'core/launch_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await AppPreferencesStore.load();
  runApp(QuickAidRoot(preferences: preferences));
}

class QuickAidRoot extends StatefulWidget {
  const QuickAidRoot({
    super.key,
    this.preferences,
    this.appState,
    this.emergencyFlowConfigController,
    this.launchService,
  });

  final AppPreferencesStore? preferences;
  final AppStateController? appState;
  final EmergencyFlowConfigController? emergencyFlowConfigController;
  final LaunchService? launchService;

  @override
  State<QuickAidRoot> createState() => _QuickAidRootState();
}

class _QuickAidRootState extends State<QuickAidRoot>
    with WidgetsBindingObserver {
  late final AppStateController _appState;
  late final bool _ownsAppState;
  late final EmergencyFlowConfigController _emergencyFlowConfigController;
  late final bool _ownsEmergencyFlowConfigController;
  late bool _systemReduceMotion;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _systemReduceMotion =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures
            .disableAnimations;
    _ownsAppState = widget.appState == null;
    _appState = widget.appState ??
        AppStateController(
          preferences: widget.preferences,
          initialAccessibilityMode:
              widget.preferences?.accessibilityMode ?? false,
        );
    _ownsEmergencyFlowConfigController =
        widget.emergencyFlowConfigController == null;
    _emergencyFlowConfigController = widget.emergencyFlowConfigController ??
        EmergencyFlowConfigController(
          preferences: widget.preferences,
          repository: buildEmergencyFlowConfigRepositoryFromEnvironment(),
        );
    _appState.addListener(_handleAppStateChanged);
    unawaited(_emergencyFlowConfigController.refresh());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _appState.removeListener(_handleAppStateChanged);
    if (_ownsAppState) {
      _appState.dispose();
    }
    if (_ownsEmergencyFlowConfigController) {
      _emergencyFlowConfigController.dispose();
    }
    super.dispose();
  }

  void _handleAppStateChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void didChangeAccessibilityFeatures() {
    final reduceMotion =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures
            .disableAnimations;
    if (reduceMotion != _systemReduceMotion) {
      setState(() {
        _systemReduceMotion = reduceMotion;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_emergencyFlowConfigController.refresh());
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = _systemReduceMotion || _appState.account.accessibilityMode;

    return AppStateScope(
      notifier: _appState,
      child: EmergencyFlowConfigScope(
        notifier: _emergencyFlowConfigController,
        child: LaunchServiceScope(
          service: widget.launchService ?? const UrlLauncherService(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'QuickAid Tech',
            theme: buildQatTheme(
              accessibilityMode: _appState.account.accessibilityMode,
              reducedMotion: reduceMotion,
            ),
            onGenerateRoute: (settings) => AppRouter.onGenerateRoute(
              settings,
              _appState,
            ),
            initialRoute: AppRoutes.landing,
          ),
        ),
      ),
    );
  }
}
