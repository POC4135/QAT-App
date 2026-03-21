import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/presentation.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../models/emergency_incident.dart';
import '../../widgets/calm_confirmation_banner.dart';
import '../../widgets/simple_disclosure_card.dart';
import '../../widgets/status_banner.dart';

class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({super.key, required this.incidentId});

  final String incidentId;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final incident = appState.incidentByIdOrNull(incidentId);
    final ui = context.qatUi;

    if (incident == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(ui.accessibilityMode ? 'What happened' : 'Incident details'),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'This history item could not be found. Return to history for the latest list.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.history,
                      (route) => false,
                    ),
                    child: const Text('Open history'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final tone = incidentTone(incident);

    return Scaffold(
      appBar: AppBar(
        title: Text(ui.accessibilityMode ? 'What happened' : 'Incident details'),
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
              StatusBanner(
                tone: tone,
                title: incidentHeadline(
                  incident,
                  accessibilityMode: ui.accessibilityMode,
                ),
                message:
                    '${incidentStatusLabel(incident.status)} · ${incident.createdLabel}. ${incident.summary}',
              ),
              const SizedBox(height: 14),
              if (!incident.isActive) ...[
                CalmConfirmationBanner(
                  title: incident.statusLabel,
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
              SimpleDisclosureCard(
                title: ui.accessibilityMode ? 'Details' : 'More details',
                subtitle: ui.accessibilityMode
                    ? 'Open if you want the contact updates and full timeline.'
                    : 'Open for responders and the full step-by-step timeline.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (incident.responders.isNotEmpty) ...[
                      Text(
                        'Who responded',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      for (final responder in incident.responders) ...[
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              responder.name,
                              style: Theme.of(context).textTheme.titleSmall,
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
                      const SizedBox(height: 18),
                    ],
                    Text(
                      'Timeline',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 10),
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
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.devices),
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
