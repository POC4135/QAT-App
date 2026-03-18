import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  Future<void> _launch(String scheme, String value) async {
    await launchUrl(Uri(scheme: scheme, path: value));
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Emergency contacts')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage who gets contacted first',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Priority order is shown clearly so you can verify the first people who will hear from QuickAid during an emergency.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.editContact),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add contact'),
                ),
              ),
              const SizedBox(height: 14),
              for (final contact in appState.contacts) ...[
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
                                '${contact.priority}. ${contact.name}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            if (contact.isPrimary) const Chip(label: Text('Primary')),
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
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.tonalIcon(
                                onPressed: () => _launch('tel', contact.phone),
                                icon: const Icon(Icons.call_outlined),
                                label: const Text('Call'),
                              ),
                            ),
                            if (contact.supportsMessaging) ...[
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _launch('sms', contact.phone),
                                  icon: const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                  ),
                                  label: const Text('Message'),
                                ),
                              ),
                            ],
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.editContact,
                                  arguments: contact.id,
                                ),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Edit'),
                              ),
                            ),
                          ],
                        ),
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
