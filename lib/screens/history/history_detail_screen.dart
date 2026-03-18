import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../models/emergency_incident.dart';
import '../../widgets/calm_confirmation_banner.dart';
import '../../widgets/status_banner.dart';

class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({super.key, required this.incidentId});

  final String incidentId;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final incident = appState.incidentById(incidentId);

    final tone = switch (incident.status) {
      IncidentStatus.active || IncidentStatus.escalated => StatusTone.emergency,
      IncidentStatus.cancelled => StatusTone.warning,
      IncidentStatus.acknowledged => StatusTone.info,
      IncidentStatus.resolved => StatusTone.ok,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Incident details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusBanner(
                tone: tone,
                title: incident.title,
                message:
                    '${incident.statusLabel} · ${incident.createdLabel}. ${incident.summary}',
              ),
              const SizedBox(height: 14),
              if (!incident.isActive)
                CalmConfirmationBanner(
                  title: incident.statusLabel,
                  message: incident.latestUpdateLabel,
                ),
              if (!incident.isActive) const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Outcome summary',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        incident.durationLabel,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        incident.responseLabel,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (incident.guidance != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Guidance used: ${incident.guidance!}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              if (incident.responders.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Who responded',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        for (final responder in incident.responders) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  responder.name,
                                  style:
                                      Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              Text(
                                responder.status,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${responder.role} · ${responder.timeLabel}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (responder != incident.responders.last)
                            const Divider(height: 20),
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
                  title: const Text('Full timeline'),
                  subtitle: const Text(
                    'Detailed updates are kept behind one extra tap for clarity.',
                  ),
                  children: [
                    for (final update in incident.updates) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          update.timeLabel,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          update.title,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(update.detail),
                      if (update != incident.updates.last)
                        const Divider(height: 20),
                    ],
                  ],
                ),
              ),
              if (incident.category == IncidentCategory.device) ...[
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.devices,
                    ),
                    child: const Text('Open Devices tab'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
