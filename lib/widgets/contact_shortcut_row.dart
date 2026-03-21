import 'package:flutter/material.dart';

import '../core/launch_service.dart';
import '../core/app_theme.dart';
import '../models/emergency_contact.dart';

class ContactShortcutRow extends StatelessWidget {
  const ContactShortcutRow({
    super.key,
    required this.contacts,
  });

  final List<EmergencyContact> contacts;

  @override
  Widget build(BuildContext context) {
    final ui = context.qatUi;
    return Column(
      children: [
        for (final contact in contacts) ...[
          Card(
            child: Padding(
              padding: EdgeInsets.all(ui.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      if (contact.isPrimary) ...[
                        const SizedBox(width: 10),
                        const Chip(label: Text('Primary')),
                      ],
                    ],
                  ),
                  SizedBox(height: ui.sectionSpacing / 1.6),
                  if (!contact.supportsMessaging || ui.accessibilityMode)
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.tonalIcon(
                            onPressed: () =>
                                launchPhoneCall(context, contact.phone),
                            icon: const Icon(Icons.call_outlined),
                            label: const Text('Call'),
                          ),
                        ),
                        if (contact.supportsMessaging) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  launchSmsMessage(context, contact.phone),
                              icon: const Icon(Icons.chat_bubble_outline_rounded),
                              label: const Text('Message'),
                            ),
                          ),
                        ],
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonalIcon(
                            onPressed: () =>
                                launchPhoneCall(context, contact.phone),
                            icon: const Icon(Icons.call_outlined),
                            label: const Text('Call'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                launchSmsMessage(context, contact.phone),
                            icon: const Icon(Icons.chat_bubble_outline_rounded),
                            label: const Text('Message'),
                          ),
                        ),
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
