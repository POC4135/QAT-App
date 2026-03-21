import 'package:flutter/material.dart';

import '../../core/launch_service.dart';
import '../../core/app_theme.dart';
import '../../widgets/simple_disclosure_card.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ui = context.qatUi;

    return Scaffold(
      appBar: AppBar(title: const Text('Help & support')),
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
                    ? 'Help if you need it'
                    : 'Support when you need clarification',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                ui.accessibilityMode
                    ? 'Support actions are shown first. Extra explanations stay behind one more tap.'
                    : 'Keep help content calm and secondary. Operational tasks stay elsewhere.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 18),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Email support'),
                      subtitle: const Text('quickaidtech@gmail.com'),
                      trailing: const Icon(Icons.open_in_new_rounded),
                      onTap: () => launchEmailMessage(
                        context,
                        'quickaidtech@gmail.com',
                        subject: 'QuickAid Support',
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Call support desk'),
                      subtitle: const Text('+1 404 555 0103'),
                      trailing: const Icon(Icons.call_outlined),
                      onTap: () => launchPhoneCall(context, '+1 404 555 0103'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Open website'),
                      subtitle: const Text('quickaidtech.com'),
                      trailing: const Icon(Icons.open_in_browser_rounded),
                      onTap: () =>
                          launchWebsiteLink(context, 'https://quickaidtech.com/'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const _FaqCard(
                title: 'Soft help or urgent help?',
                body:
                    'Soft help alerts key responders first. Urgent help starts the stronger response path for immediate danger.',
              ),
              const SizedBox(height: 12),
              const _FaqCard(
                title: 'What if the app is offline?',
                body:
                    'The app shows the last known status and suggests safe fallback actions like calling key contacts directly.',
              ),
              const SizedBox(height: 12),
              const _FaqCard(
                title: 'Why are device details on another screen?',
                body:
                    'Device health matters, but it should not compete with emergency actions. The home screen shows the summary first.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SimpleDisclosureCard(
      title: title,
      subtitle: 'Open for more information.',
      child: Text(body, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
