import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../widgets/simple_disclosure_card.dart';
import '../../widgets/status_banner.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final ui = context.qatUi;

    final accessibilityTile = SwitchListTile.adaptive(
      title: const Text('Accessibility mode'),
      subtitle: const Text(
        'Use larger text, simpler screens, and calmer motion.',
      ),
      value: appState.account.accessibilityMode,
      onChanged: appState.setAccessibilityMode,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
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
                tone: StatusTone.info,
                title: ui.accessibilityMode
                    ? 'Keep the app calm and clear'
                    : 'Transparent degraded mode',
                message: ui.accessibilityMode
                    ? 'Important settings stay visible here. Extra settings are kept one tap deeper.'
                    : 'If the app cannot confirm a state change, it should say so clearly and offer safe fallback actions like calling primary contacts.',
              ),
              const SizedBox(height: 14),
              Card(child: accessibilityTile),
              const SizedBox(height: 14),
              if (ui.accessibilityMode)
                SimpleDisclosureCard(
                  title: 'More settings',
                  subtitle: 'Open only if you need extra controls.',
                  child: Column(
                    children: [
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Offline mode'),
                        subtitle: const Text(
                          'Show last-known-status messaging and fallback behavior.',
                        ),
                        value: appState.account.offlineMode,
                        onChanged: appState.setOfflineMode,
                      ),
                      const Divider(height: 1),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Exclamation mode'),
                        subtitle: const Text(
                          'Keep emergency prompts prominent during active incidents.',
                        ),
                        value: appState.account.exclamationMode,
                        onChanged: appState.setExclamationMode,
                      ),
                      const SizedBox(height: 14),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Current sync state',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          appState.account.lastSyncLabel,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
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
                    padding: EdgeInsets.all(ui.cardPadding),
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
            ],
          ),
        ),
      ),
    );
  }
}
