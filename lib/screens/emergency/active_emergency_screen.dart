import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../models/emergency_incident.dart';
import '../../widgets/calm_confirmation_banner.dart';
import '../../widgets/status_banner.dart';

class ActiveEmergencyScreen extends StatelessWidget {
  const ActiveEmergencyScreen({super.key, required this.incidentId});

  final String? incidentId;

  Future<void> _callPrimary(String phone) async {
    await launchUrl(Uri(scheme: 'tel', path: phone));
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final incident = incidentId != null
        ? appState.incidentById(incidentId!)
        : appState.activeIncident;

    if (incident == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Emergency status')),
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
    final primaryContact = appState.primaryContacts.first;
    final tone = !isActive
        ? StatusTone.ok
        : incident.status == IncidentStatus.acknowledged
            ? StatusTone.info
            : StatusTone.emergency;
    final title = isActive
        ? '${incident.severityLabel} active'
        : '${incident.severityLabel} ${incident.statusLabel.toLowerCase()}';
    final canSubmitStateChange = appState.canSubmitStateChanges;
    final needsResolution = incident.status == IncidentStatus.acknowledged;

    return Scaffold(
      appBar: AppBar(title: const Text('Emergency status')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
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
                  title: 'Safety guidance',
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
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What the system already did',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      for (final responder in incident.responders) ...[
                        _ResponderRow(responder: responder),
                        if (responder != incident.responders.last)
                          const Divider(height: 22),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isActive ? 'Next best action' : 'What happens next',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isActive
                            ? 'Use one clear action at a time. The main button below is the safest next step from this screen.'
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
                                  ? QatColors.emergency
                                  : QatColors.info,
                            ),
                            onPressed: () {
                              if (!canSubmitStateChange) {
                                _callPrimary(primaryContact.phone);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Unable to confirm a state change while offline. Call placed to your primary contact.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              if (needsResolution) {
                                appState.resolveIncident(incident.id);
                              } else {
                                appState.acknowledgeIncident(incident.id);
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    needsResolution
                                        ? 'Incident resolved. Responders were updated.'
                                        : 'Safety acknowledged. Contacts were updated.',
                                  ),
                                ),
                              );
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
                                  ? 'Call ${primaryContact.name}'
                                  : needsResolution
                                      ? 'Mark resolved'
                                      : incident.isHazard
                                          ? 'I\'m safe'
                                          : 'Acknowledge',
                            ),
                          ),
                        ),
                        if (canSubmitStateChange && !needsResolution) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                appState.cancelIncident(incident.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Alert stopped. Responders received a closure update.',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.stop_circle_outlined),
                              label: Text(
                                incident.isHazard ? 'Stop alarm' : 'Cancel alert',
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton.icon(
                            onPressed: () => _callPrimary(primaryContact.phone),
                            icon: const Icon(Icons.call_outlined),
                            label: Text('Call ${primaryContact.name}'),
                          ),
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
              Card(
                child: ExpansionTile(
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  childrenPadding:
                      const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  title: const Text('Details timeline'),
                  subtitle: Text(
                    'Open only if you need the step-by-step record.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  children: [
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: QatColors.ok,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(responder.name, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 2),
              Text(
                '${responder.role} · ${responder.status}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Text(responder.timeLabel, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.update});

  final IncidentUpdate update;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(update.timeLabel, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(update.title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(update.detail, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
