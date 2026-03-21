import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/emergency_flow_config.dart';
import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../models/emergency_incident.dart';
import '../../widgets/countdown_action_button.dart';
import '../../widgets/status_banner.dart';

class EmergencyChoiceScreen extends StatefulWidget {
  const EmergencyChoiceScreen({super.key});

  @override
  State<EmergencyChoiceScreen> createState() => _EmergencyChoiceScreenState();
}

class _EmergencyChoiceScreenState extends State<EmergencyChoiceScreen>
    with SingleTickerProviderStateMixin {
  static const _fallbackCountdownSeconds = EmergencyFlowConfig.defaultSeconds;

  late final AnimationController _countdownController;
  IncidentKind _selectedKind = IncidentKind.hard;
  bool _initialized = false;
  bool _didFinishFlow = false;
  int _countdownSeconds = _fallbackCountdownSeconds;

  @override
  void initState() {
    super.initState();
    _countdownController = AnimationController(vsync: this)
      ..addStatusListener(_handleCountdownStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }
    _initialized = true;

    final appState = AppStateScope.of(context);
    final configController = EmergencyFlowConfigScope.read(context);
    final activeIncident = appState.activeIncident;

    _countdownSeconds = configController.countdownSeconds;
    _countdownController.duration = Duration(seconds: _countdownSeconds);

    if (activeIncident != null) {
      _didFinishFlow = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        unawaited(configController.refresh());
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.emergencyActive,
          arguments: activeIncident.id,
        );
      });
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _didFinishFlow) {
        return;
      }
      _countdownController.forward(from: 0);
      unawaited(configController.refresh());
    });
  }

  @override
  void dispose() {
    _countdownController
      ..removeStatusListener(_handleCountdownStatus)
      ..dispose();
    super.dispose();
  }

  void _handleCountdownStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _triggerSelectedEmergency();
    }
  }

  int get _remainingSeconds {
    final remainingFraction = 1 - _countdownController.value;
    final remaining = (_countdownSeconds * remainingFraction).ceil();
    return remaining.clamp(0, _countdownSeconds);
  }

  void _selectKind(IncidentKind kind) {
    if (_didFinishFlow) {
      return;
    }
    setState(() {
      _selectedKind = kind;
    });
  }

  void _triggerSelectedEmergency() {
    if (_didFinishFlow) {
      return;
    }
    _didFinishFlow = true;
    _countdownController.stop();

    final incident = AppStateScope.of(context).startEmergency(_selectedKind);
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.emergencyActive,
      arguments: incident.id,
    );
  }

  void _cancelAndReturnHome() {
    if (_didFinishFlow) {
      return;
    }
    _didFinishFlow = true;
    _countdownController.stop(canceled: true);

    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }

    navigator.pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final ui = context.qatUi;
    final palette = context.qatPalette;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _cancelAndReturnHome();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: _cancelAndReturnHome,
          ),
          title: Text(
            ui.accessibilityMode ? 'Choose help type' : 'Choose emergency type',
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              ui.screenHorizontalPadding,
              12,
              ui.screenHorizontalPadding,
              32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ui.accessibilityMode
                      ? 'What kind of help do you need?'
                      : 'Choose the clearest response path',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  ui.accessibilityMode
                      ? 'Urgent help is selected for you. The countdown starts right away and will trigger help automatically unless you cancel or choose quiet help.'
                      : 'Hard emergency is selected by default so help still starts if the phone is left alone. You can switch to the quieter response path before the countdown ends.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 18),
                StatusBanner(
                  tone: StatusTone.warning,
                  title: ui.accessibilityMode
                      ? 'Smoke or gas? Leave first'
                      : 'Smoke or gas detected?',
                  message: ui.accessibilityMode
                      ? 'Move to safety first. Then leave urgent help selected if there is immediate danger.'
                      : 'Move to safety first. Leave hard emergency selected if there is immediate danger and you need the louder response path.',
                ),
                const SizedBox(height: 18),
                _EmergencyChoiceCard(
                  key: const ValueKey('emergency-choice-hard'),
                  title: ui.accessibilityMode ? 'Urgent help' : 'Hard emergency',
                  subtitle: ui.accessibilityMode
                      ? 'Use this for immediate danger or when help must reach you fast.'
                      : 'Start the stronger response path. Use this for immediate danger, no response, or a situation that should escalate quickly.',
                  selected: _selectedKind == IncidentKind.hard,
                  onTap: () => _selectKind(IncidentKind.hard),
                ),
                const SizedBox(height: 12),
                _EmergencyChoiceCard(
                  key: const ValueKey('emergency-choice-soft'),
                  title: ui.accessibilityMode ? 'Quiet help' : 'Soft emergency',
                  subtitle: ui.accessibilityMode
                      ? 'Alert security and key contacts first without a loud alarm.'
                      : 'Quietly alert security and priority contacts first. Best when you need help quickly without triggering a loud alarm.',
                  selected: _selectedKind == IncidentKind.soft,
                  onTap: () => _selectKind(IncidentKind.soft),
                ),
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _countdownController,
                  builder: (context, child) {
                    final remainingSeconds = _remainingSeconds == 0
                        ? 1
                        : _remainingSeconds;
                    return CountdownActionButton(
                      key: const ValueKey('emergency-countdown-button'),
                      label: ui.accessibilityMode
                          ? 'Continue'
                          : 'Continue to emergency status',
                      remainingSeconds: remainingSeconds,
                      progress: _countdownController.value,
                      onPressed: _triggerSelectedEmergency,
                    );
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const ValueKey('emergency-choice-cancel'),
                    style: FilledButton.styleFrom(
                      backgroundColor: palette.emergency,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _cancelAndReturnHome,
                    child: Text(
                      ui.accessibilityMode ? 'Cancel and go back' : 'Cancel',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmergencyChoiceCard extends StatelessWidget {
  const _EmergencyChoiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ui = context.qatUi;
    final palette = context.qatPalette;

    return Semantics(
      button: true,
      selected: selected,
      label: title,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(ui.cardRadius),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(ui.cardPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : palette.cardBorderStrong,
                      width: ui.accessibilityMode ? 2.2 : 1.2,
                    ),
                  ),
                  child: Icon(
                    selected ? Icons.check_rounded : Icons.circle_outlined,
                    size: ui.iconSize - 4,
                    color: selected ? Colors.white : palette.cardBorderStrong,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
