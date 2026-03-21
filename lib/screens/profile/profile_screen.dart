import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../widgets/accessibility_mode_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    this.showScreenTitle = true,
  });

  final bool showScreenTitle;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final contacts = appState.contacts.take(2).toList();
    final ui = context.qatUi;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          ui.screenHorizontalPadding,
          ui.screenVerticalPadding,
          ui.screenHorizontalPadding,
          32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showScreenTitle) ...[
              Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                ui.accessibilityMode
                    ? 'Keep contacts and safety settings easy to reach.'
                    : 'Keep contacts, safety modes, and support options in one place without crowding the primary emergency flow.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 18),
            ],
            if (ui.accessibilityMode) ...[
              AccessibilityModeSection(
                accessibilityMode: appState.account.accessibilityMode,
                exclamationMode: appState.account.exclamationMode,
                onAccessibilityChanged: appState.setAccessibilityMode,
                onExclamationChanged: appState.setExclamationMode,
              ),
              const SizedBox(height: 16),
            ],
            Card(
              child: Padding(
                padding: EdgeInsets.all(ui.cardPadding),
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
                padding: EdgeInsets.all(ui.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency contacts',
                      style: Theme.of(context).textTheme.titleMedium,
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
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ui.accessibilityMode
                          ? FilledButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, AppRoutes.contacts),
                              child: const Text('Manage contacts'),
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.contacts,
                                ),
                                child: const Text('Manage'),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            if (!ui.accessibilityMode) ...[
              const SizedBox(height: 16),
              AccessibilityModeSection(
                accessibilityMode: appState.account.accessibilityMode,
                exclamationMode: appState.account.exclamationMode,
                onAccessibilityChanged: appState.setAccessibilityMode,
                onExclamationChanged: appState.setExclamationMode,
              ),
            ],
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Settings'),
                    subtitle: const Text(
                      'Offline mode, sync copy, and safety preferences.',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Help & support'),
                    subtitle: const Text(
                      'FAQs, support contact, and system explainers.',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.help),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Sign out'),
                    subtitle: const Text('Return to the resident sign-in screen.'),
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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: const ProfileScreen(showScreenTitle: false),
      ),
    );
  }
}
