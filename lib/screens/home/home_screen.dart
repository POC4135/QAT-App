import 'package:flutter/material.dart';

import '../../core/launch_service.dart';
import '../../core/app_routes.dart';
import '../../core/presentation.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../models/device_health.dart';
import '../../models/emergency_incident.dart';
import '../../widgets/contact_shortcut_row.dart';
import '../../widgets/device_status_card.dart';
import '../../widgets/emergency_action_card.dart';
import '../../widgets/status_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onOpenDevicesTab,
  });

  final VoidCallback onOpenDevicesTab;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final ui = context.qatUi;
    final activeIncident = appState.activeIncident;
    final primaryContact =
        appState.primaryContacts.isEmpty ? null : appState.primaryContacts.first;
    final highlightedDevices = appState.devices.take(2).toList();
    final warningCount = appState.devices
        .where((device) => device.status != DeviceStatus.online)
        .length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          ui.screenHorizontalPadding,
          ui.screenVerticalPadding,
          ui.screenHorizontalPadding,
          32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${appState.account.name.split(' ').first}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              ui.accessibilityMode
                  ? 'Your home emergency dashboard'
                  : appState.account.homeLabel,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            if (appState.account.offlineMode) ...[
              StatusBanner(
                tone: StatusTone.info,
                title: 'Offline — showing last known status',
                message:
                    '${appState.account.lastSyncLabel}. New alert actions cannot be confirmed from this device right now, so call your primary contact directly.',
              ),
              const SizedBox(height: 14),
            ],
            EmergencyActionCard(
              title: activeIncident != null
                  ? 'Stay with the emergency flow'
                  : appState.account.offlineMode
                      ? 'Need help while offline?'
                  : 'Need help now?',
              message: activeIncident != null
                  ? 'Keep the emergency screen open so you can see what the system did, who is responding, and what action you should take next.'
                  : appState.account.offlineMode
                      ? 'Because this device is offline, the app cannot confirm a new alert. Use the primary contact call action now, then review details once connectivity returns.'
                  : 'Start the emergency flow in one tap. You will choose between a soft emergency and a hard emergency on the next screen.',
              primaryLabel: activeIncident != null
                  ? 'Open emergency status'
                  : appState.account.offlineMode
                      ? 'Call primary contact'
                  : 'Start emergency alert',
              useRoundPrimary: activeIncident == null,
              onPrimaryTap: () {
                if (activeIncident != null) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.emergencyActive,
                    arguments: activeIncident.id,
                  );
                } else if (appState.account.offlineMode &&
                    primaryContact != null) {
                  launchPhoneCall(context, primaryContact.phone);
                } else {
                  Navigator.pushNamed(context, AppRoutes.emergencyChoice);
                }
              },
            ),
            const SizedBox(height: 16),
            StatusBanner(
              tone: activeIncident != null ? StatusTone.emergency : StatusTone.ok,
              title: activeIncident != null
                  ? incidentHeadline(
                      activeIncident,
                      accessibilityMode: ui.accessibilityMode,
                    )
                  : 'System OK',
              message: activeIncident != null
                  ? 'Contacts were alerted and the incident is active. Open emergency status for the latest response updates.'
                  : warningCount == 0
                      ? 'All core devices are online and ready. You can trigger an alert or review details if needed.'
                      : ui.accessibilityMode
                          ? '$warningCount device${warningCount == 1 ? '' : 's'} need attention. Open devices to review what needs attention.'
                          : '$warningCount device${warningCount == 1 ? '' : 's'} need attention. Review details when you have a moment.',
              actionLabel: activeIncident != null
                  ? 'Open emergency status'
                  : ui.accessibilityMode
                      ? (warningCount > 0 ? 'Open devices' : null)
                      : 'View details',
              onAction: () {
                if (activeIncident != null) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.emergencyActive,
                    arguments: activeIncident.id,
                  );
                } else if (ui.accessibilityMode) {
                  Navigator.pushNamed(context, AppRoutes.devices);
                } else {
                  onOpenDevicesTab();
                }
              },
            ),
            const SizedBox(height: 22),
            if (ui.accessibilityMode) ...[
              if (activeIncident != null)
                _ActiveIncidentPreview(incident: activeIncident),
            ] else ...[
              _SectionLabel(
                title: 'Primary contacts',
                subtitle:
                    'Keep direct contact actions one tap away during stress.',
              ),
              const SizedBox(height: 12),
              ContactShortcutRow(contacts: appState.primaryContacts),
              const SizedBox(height: 22),
              _SectionLabel(
                title: 'Device highlights',
                subtitle: warningCount == 0
                    ? 'All devices online.'
                    : '$warningCount device${warningCount == 1 ? '' : 's'} need attention.',
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  const spacing = 12.0;
                  final itemWidth = (constraints.maxWidth - spacing) / 2;

                  return Wrap(
                    key: const ValueKey('home-device-highlights-grid'),
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      for (final device in highlightedDevices)
                        SizedBox(
                          width: itemWidth,
                          child: DeviceStatusCard(
                            device: device,
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.deviceDetail,
                              arguments: device.id,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              if (activeIncident != null) ...[
                const SizedBox(height: 22),
                _ActiveIncidentPreview(incident: activeIncident),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _ActiveIncidentPreview extends StatelessWidget {
  const _ActiveIncidentPreview({required this.incident});

  final EmergencyIncident incident;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.qatUi.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latest emergency update',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              incident.latestUpdateLabel,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
