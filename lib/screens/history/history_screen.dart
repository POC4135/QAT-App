import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../models/emergency_incident.dart';
import '../../widgets/history_list_item.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final incidents = appState.filteredIncidents();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'History',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Review what happened, how it ended, and who responded without reading dense logs.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: appState.historyFilter == HistoryFilter.all,
                  onSelected: (_) => appState.setHistoryFilter(HistoryFilter.all),
                ),
                ChoiceChip(
                  label: const Text('Emergencies'),
                  selected:
                      appState.historyFilter == HistoryFilter.emergencies,
                  onSelected: (_) =>
                      appState.setHistoryFilter(HistoryFilter.emergencies),
                ),
                ChoiceChip(
                  label: const Text('Devices'),
                  selected: appState.historyFilter == HistoryFilter.devices,
                  onSelected: (_) =>
                      appState.setHistoryFilter(HistoryFilter.devices),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  'Recent outcomes are shown first, with plain-language summaries. Tap any entry for the full status and response timeline.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 14),
            if (incidents.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text('No history items match this filter right now.'),
                ),
              ),
            for (final incident in incidents) ...[
              HistoryListItem(
                incident: incident,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.historyDetail,
                  arguments: incident.id,
                ),
              ),
              if (incident != incidents.last) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
