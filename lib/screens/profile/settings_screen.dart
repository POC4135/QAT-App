import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../widgets/status_banner.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StatusBanner(
                tone: StatusTone.info,
                title: 'Transparent degraded mode',
                message:
                    'If the app cannot confirm a state change, it should say so clearly and offer safe fallback actions like calling primary contacts.',
              ),
              const SizedBox(height: 14),
              Card(
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      title: const Text('Offline mode'),
                      subtitle: const Text(
                        'Simulate last-known-status messaging and fallback behavior.',
                      ),
                      value: appState.account.offlineMode,
                      onChanged: appState.setOfflineMode,
                    ),
                    const Divider(height: 1),
                    SwitchListTile.adaptive(
                      title: const Text('Accessibility mode'),
                      subtitle: const Text(
                        'Use larger, simpler presentation with lower density.',
                      ),
                      value: appState.account.accessibilityMode,
                      onChanged: appState.setAccessibilityMode,
                    ),
                    const Divider(height: 1),
                    SwitchListTile.adaptive(
                      title: const Text('Exclamation mode'),
                      subtitle: const Text(
                        'Keep emergency prompts prominent during active incidents.',
                      ),
                      value: appState.account.exclamationMode,
                      onChanged: appState.setExclamationMode,
                    ),
                  ],
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
                        'Current sync state',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        appState.account.lastSyncLabel,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
