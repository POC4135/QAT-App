import 'package:flutter/material.dart';

import '../core/presentation.dart';
import '../core/app_theme.dart';
import '../models/emergency_incident.dart';

class HistoryListItem extends StatelessWidget {
  const HistoryListItem({
    super.key,
    required this.incident,
    required this.onTap,
  });

  final EmergencyIncident incident;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;
    final color = switch (incident.status) {
      IncidentStatus.active || IncidentStatus.escalated => palette.emergency,
      IncidentStatus.cancelled => palette.warning,
      IncidentStatus.acknowledged => palette.info,
      IncidentStatus.resolved => palette.ok,
    };

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(ui.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(ui.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    incident.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ui.accessibilityMode ? 14 : 10,
                      vertical: ui.accessibilityMode ? 8 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      incidentStatusLabel(incident.status),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: color),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${incident.createdLabel} · ${incident.durationLabel}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Text(incident.summary, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 10),
              Text(
                incident.responseLabel,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: palette.textPrimary,
                ),
              ),
              if (ui.accessibilityMode) ...[
                const SizedBox(height: 8),
                Text(
                  'Tap to open the full steps and contact updates.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
