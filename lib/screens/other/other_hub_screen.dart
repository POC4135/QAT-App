import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';

class OtherHubScreen extends StatelessWidget {
  const OtherHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
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
            Text('Other', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Everything else is grouped here so Home stays focused on help and safety.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 18),
            _OtherEntry(
              key: const ValueKey('other-entry-contacts'),
              title: 'Emergency contacts',
              subtitle: 'See who gets called first and update contact details.',
              icon: Icons.call_outlined,
              onTap: () => Navigator.pushNamed(context, AppRoutes.contacts),
            ),
            const SizedBox(height: 12),
            _OtherEntry(
              key: const ValueKey('other-entry-history'),
              title: 'History',
              subtitle: 'Review what happened and how each alert ended.',
              icon: Icons.history_rounded,
              onTap: () => Navigator.pushNamed(context, AppRoutes.history),
            ),
            const SizedBox(height: 12),
            _OtherEntry(
              key: const ValueKey('other-entry-devices'),
              title: 'Devices',
              subtitle: 'Check device health and run a system test.',
              icon: Icons.sensors_outlined,
              onTap: () => Navigator.pushNamed(context, AppRoutes.devices),
            ),
            const SizedBox(height: 12),
            _OtherEntry(
              key: const ValueKey('other-entry-profile'),
              title: 'Profile',
              subtitle: 'View your account summary and safety preferences.',
              icon: Icons.person_outline_rounded,
              onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
            ),
            const SizedBox(height: 12),
            _OtherEntry(
              key: const ValueKey('other-entry-settings'),
              title: 'Settings',
              subtitle: 'Adjust accessibility, offline mode, and sync settings.',
              icon: Icons.settings_outlined,
              onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
            ),
            const SizedBox(height: 12),
            _OtherEntry(
              key: const ValueKey('other-entry-help'),
              title: 'Help & support',
              subtitle: 'Open support contact options and common help topics.',
              icon: Icons.help_outline_rounded,
              onTap: () => Navigator.pushNamed(context, AppRoutes.help),
            ),
            const SizedBox(height: 12),
            _OtherEntry(
              key: const ValueKey('other-entry-signout'),
              title: 'Sign out',
              subtitle: 'Return to the sign-in screen.',
              icon: Icons.logout_rounded,
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
    );
  }
}

class _OtherEntry extends StatelessWidget {
  const _OtherEntry({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(ui.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(ui.cardPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: palette.surfaceMuted,
                  borderRadius: BorderRadius.circular(ui.disclosureRadius),
                ),
                child: Icon(
                  icon,
                  color: palette.textPrimary,
                  size: ui.iconSize,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.chevron_right_rounded,
                color: palette.textPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
