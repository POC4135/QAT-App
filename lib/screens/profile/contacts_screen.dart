import 'package:flutter/material.dart';

import '../../core/launch_service.dart';
import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../widgets/simple_disclosure_card.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final ui = context.qatUi;

    return Scaffold(
      appBar: AppBar(title: const Text('Emergency contacts')),
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
              Text(
                ui.accessibilityMode
                    ? 'Contacts who can help'
                    : 'Manage who gets contacted first',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                ui.accessibilityMode
                    ? 'The first people called are shown clearly below.'
                    : 'Priority order is shown clearly so you can verify the first people who will hear from QuickAid during an emergency.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.editContact),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add contact'),
                ),
              ),
              const SizedBox(height: 14),
              for (final contact in appState.contacts) ...[
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(ui.cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    '${contact.priority}. ${contact.name}',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  if (contact.isPrimary)
                                    const Chip(label: Text('Primary')),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${contact.role} · ${contact.relationship}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          contact.phone,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.tonalIcon(
                            onPressed: () =>
                                launchPhoneCall(context, contact.phone),
                            icon: const Icon(Icons.call_outlined),
                            label: const Text('Call'),
                          ),
                        ),
                        if (ui.accessibilityMode) ...[
                          const SizedBox(height: 12),
                          SimpleDisclosureCard(
                            title: 'More actions',
                            subtitle:
                                'Open only if you want to edit this contact or send a message.',
                            child: Column(
                              children: [
                                if (contact.supportsMessaging)
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: () =>
                                          launchSmsMessage(context, contact.phone),
                                      icon: const Icon(
                                        Icons.chat_bubble_outline_rounded,
                                      ),
                                      label: const Text('Message'),
                                    ),
                                  ),
                                if (contact.supportsMessaging)
                                  const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () => Navigator.pushNamed(
                                      context,
                                      AppRoutes.editContact,
                                      arguments: contact.id,
                                    ),
                                    icon: const Icon(Icons.edit_outlined),
                                    label: const Text('Edit contact'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              if (contact.supportsMessaging)
                                OutlinedButton.icon(
                                  onPressed: () =>
                                      launchSmsMessage(context, contact.phone),
                                  icon: const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                  ),
                                  label: const Text('Message'),
                                ),
                              OutlinedButton.icon(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.editContact,
                                  arguments: contact.id,
                                ),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Edit'),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (contact != appState.contacts.last) const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
