import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/emergency_contact.dart';

class ContactShortcutRow extends StatelessWidget {
  const ContactShortcutRow({
    super.key,
    required this.contacts,
  });

  final List<EmergencyContact> contacts;

  Future<void> _launch(String scheme, String value) async {
    await launchUrl(Uri(scheme: scheme, path: value));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final contact in contacts) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contact.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${contact.role} · ${contact.phone}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (contact.isPrimary)
                        Chip(label: const Text('Primary')),
                    ],
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _launch('sms', contact.phone),
                            icon: const Icon(Icons.chat_bubble_outline_rounded),
                            label: const Text('Message'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (contact != contacts.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}
