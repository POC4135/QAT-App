import 'package:flutter/material.dart';

import '../../core/launch_service.dart';
import '../../core/presentation.dart';
import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../models/emergency_incident.dart';
import '../../widgets/action_confirmation_dialog.dart';
import '../../widgets/calm_confirmation_banner.dart';
import '../../widgets/simple_disclosure_card.dart';
import '../../widgets/status_banner.dart';

class ActiveEmergencyScreen extends StatelessWidget {
  const ActiveEmergencyScreen({super.key, required this.incidentId});

  final String? incidentId;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final ui = context.qatUi;
    final palette = context.qatPalette;
    final incident = incidentId != null
        ? appState.incidentByIdOrNull(incidentId!)
        : appState.activeIncident;

    if (incident == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(ui.accessibilityMode ? 'Help status' : 'Emergency status'),
        ),
        body: const SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('There is no active emergency right now.'),
            ),
          ),
        ),
      );
    }

    final isActive = incident.isActive;
    final primaryContact = appState.primaryContacts.isEmpty
        ? (appState.contacts.isEmpty ? null : appState.contacts.first)
        : appState.primaryContacts.first;
    final tone = incidentTone(incident);
    final title = incidentHeadline(
      incident,
      accessibilityMode: ui.accessibilityMode,
    );
    final canSubmitStateChange = appState.canSubmitStateChanges;
    final needsResolution = incident.status == IncidentStatus.acknowledged;

    return Scaffold(
      appBar: AppBar(
        title: Text(ui.accessibilityMode ? 'Help status' : 'Emergency status'),
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
              if (appState.account.offlineMode) ...[
                const StatusBanner(
                  tone: StatusTone.info,
                  title: 'Offline — showing last known status',
                  message:
                      'If a state change cannot be confirmed, call a contact directly while following the last visible emergency guidance.',
                ),
                const SizedBox(height: 12),
              ],
              StatusBanner(
                tone: tone,
                title: title,
                message:
                    '${incident.responseLabel}. ${incident.latestUpdateLabel}',
              ),
              const SizedBox(height: 14),
              if (incident.guidance != null) ...[
                StatusBanner(
                  tone: StatusTone.warning,
                  title: ui.accessibilityMode
                      ? 'Leave the area first'
                      : 'Safety guidance',
                  message: incident.guidance!,
                ),
                const SizedBox(height: 14),
              ],
              if (!isActive) ...[
                CalmConfirmationBanner(
                  title: 'Emergency closed',
                  message: incident.latestUpdateLabel,
                ),
                const SizedBox(height: 14),
              ],
              Card(
                child: Padding(
                  padding: EdgeInsets.all(ui.cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ui.accessibilityMode
                            ? 'What the app already did'
                            : 'What the system already did',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ui.accessibilityMode
                            ? 'Help messages were sent. You can open details below if you want the full list.'
                            : 'Responders and contacts were updated right away. Open details if you need the full record.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(ui.cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isActive
                            ? (ui.accessibilityMode
                                ? 'What to do now'
                                : 'Next best action')
                            : 'What happens next',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isActive
                            ? (ui.accessibilityMode
                                ? 'Use one clear button at a time. The main button below is the safest next step.'
                                : 'Use one clear action at a time. The main button below is the safest next step from this screen.')
                            : 'The incident is closed. You can return home or review the history entry for reassurance.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 18),
                      if (isActive) ...[
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: canSubmitStateChange
                                  ? palette.emergency
                                  : palette.info,
                            ),
                            onPressed: () {
                              if (!canSubmitStateChange) {
                                if (primaryContact == null) {
                                  return;
                                }
                                launchPhoneCall(
                                  context,
                                  primaryContact.phone,
                                  failureMessage:
                                      'We could not place the fallback call. Please contact ${primaryContact.name} manually at ${primaryContact.phone}.',
                                );
                                return;
                              }
                              if (needsResolution) {
                                appState.resolveIncident(incident.id);
                              } else {
                                appState.acknowledgeIncident(incident.id);
                              }
                            },
                            icon: Icon(
                              !canSubmitStateChange
                                  ? Icons.call_outlined
                                  : needsResolution
                                      ? Icons.task_alt_rounded
                                      : Icons.verified_user_rounded,
                            ),
                            label: Text(
                              !canSubmitStateChange
                                  ? primaryContact == null
                                      ? 'No contact available'
                                      : 'Call ${primaryContact.name}'
                                  : needsResolution
                                      ? 'Mark resolved'
                                      : incident.isHazard
                                          ? 'I am safe'
                                          : 'Acknowledge',
                            ),
                          ),
                        ),
                        if (canSubmitStateChange && !needsResolution) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final confirmed =
                                    await showActionConfirmationDialog(
                                  context,
                                  title: incident.isHazard
                                      ? 'Stop this alarm?'
                                      : 'Cancel this alert?',
                                  message: incident.isHazard
                                      ? 'Use this only if the danger has passed and you want to stop the alarm. Contacts will receive a closure update.'
                                      : 'Use this only if the alert was a mistake. Contacts will receive a closure update.',
                                  confirmLabel: incident.isHazard
                                      ? 'Stop alarm'
                                      : 'Cancel alert',
                                );
                                if (!confirmed || !context.mounted) {
                                  return;
                                }
                                appState.cancelIncident(incident.id);
                              },
                              icon: const Icon(Icons.stop_circle_outlined),
                              label: Text(
                                incident.isHazard
                                    ? 'Stop alarm'
                                    : ui.accessibilityMode
                                        ? 'Cancel false alarm'
                                        : 'Cancel alert',
                              ),
                            ),
                          ),
                          if (!ui.accessibilityMode) ...[
                            const SizedBox(height: 12),
                            TextButton.icon(
                              onPressed: primaryContact == null
                                  ? null
                                  : () => launchPhoneCall(
                                        context,
                                        primaryContact.phone,
                                      ),
                              icon: const Icon(Icons.call_outlined),
                              label: Text(
                                primaryContact == null
                                    ? 'No contact available'
                                    : 'Call ${primaryContact.name}',
                              ),
                            ),
                          ],
                        ],
                      ] else ...[
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.home,
                              (route) => false,
                            ),
                            child: const Text('Back to Home'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SimpleDisclosureCard(
                title: ui.accessibilityMode ? 'Details' : 'Details timeline',
                subtitle: ui.accessibilityMode
                    ? 'Open only if you want the contact list and step-by-step record.'
                    : 'Open only if you need the step-by-step record.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (ui.accessibilityMode &&
                        canSubmitStateChange &&
                        isActive &&
                        !needsResolution) ...[
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: primaryContact == null
                              ? null
                              : () => launchPhoneCall(
                                    context,
                                    primaryContact.phone,
                                  ),
                          icon: const Icon(Icons.call_outlined),
                          label: Text(
                            primaryContact == null
                                ? 'No contact available'
                                : 'Call ${primaryContact.name}',
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                    if (incident.responders.isNotEmpty) ...[
                      Text(
                        'Who was contacted',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 10),
                      for (final responder in incident.responders) ...[
                        _ResponderRow(responder: responder),
                        if (responder != incident.responders.last)
                          const Divider(height: 22),
                      ],
                      const SizedBox(height: 18),
                    ],
                    Text(
                      'Step-by-step record',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 10),
                    for (final update in incident.updates) ...[
                      _TimelineRow(update: update),
                      if (update != incident.updates.last)
                        const Divider(height: 20),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResponderRow extends StatelessWidget {
  const _ResponderRow({required this.responder});

  final ResponderProgress responder;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: ui.accessibilityMode ? 12 : 10,
              height: ui.accessibilityMode ? 12 : 10,
              decoration: BoxDecoration(
                color: palette.ok,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    responder.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${responder.role} · ${responder.status}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 22),
          child: Text(
            responder.timeLabel,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.update});

  final IncidentUpdate update;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(update.timeLabel, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        Text(update.title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        Text(update.detail, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
