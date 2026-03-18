import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../widgets/accessibility_mode_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final contacts = appState.contacts.take(2).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Keep contacts, safety modes, and support options in one place without crowding the primary emergency flow.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appState.account.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      appState.account.homeLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      appState.account.lastSyncLabel,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Emergency contacts',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.contacts),
                          child: const Text('Manage'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    for (final contact in contacts) ...[
                      Text(
                        '${contact.priority}. ${contact.name}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${contact.role} · ${contact.phone}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (contact != contacts.last) const Divider(height: 20),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            AccessibilityModeSection(
              accessibilityMode: appState.account.accessibilityMode,
              exclamationMode: appState.account.exclamationMode,
              onAccessibilityChanged: appState.setAccessibilityMode,
              onExclamationChanged: appState.setExclamationMode,
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Settings'),
                    subtitle: const Text('Offline mode, sync copy, and safety preferences.'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.settings),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Help & support'),
                    subtitle:
                        const Text('FAQs, support contact, and system explainers.'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.help),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Sign out'),
                    subtitle:
                        const Text('Return to the resident sign-in screen.'),
                    trailing: const Icon(Icons.logout_rounded),
                    onTap: () {
                      appState.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.landing,
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
