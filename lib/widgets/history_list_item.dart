import 'package:flutter/material.dart';

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
    final color = switch (incident.status) {
      IncidentStatus.active || IncidentStatus.escalated => QatColors.emergency,
      IncidentStatus.cancelled => QatColors.warning,
      IncidentStatus.acknowledged => QatColors.info,
      IncidentStatus.resolved => QatColors.ok,
    };

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      incident.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      incident.statusLabel,
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
                  color: QatColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
