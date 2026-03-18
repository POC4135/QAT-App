import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  Future<void> _openUri(String uri) async {
    await launchUrl(Uri.parse(uri));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & support')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Support when you need clarification',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Keep help content calm and secondary. Operational tasks stay elsewhere.',
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
                      onTap: () => _openUri(
                        'mailto:quickaidtech@gmail.com?subject=QuickAid%20Support',
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Call support desk'),
                      subtitle: const Text('+1 404 555 0103'),
                      trailing: const Icon(Icons.call_outlined),
                      onTap: () => _openUri('tel:+14045550103'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Open website'),
                      subtitle: const Text('quickaidtech.com'),
                      trailing: const Icon(Icons.open_in_browser_rounded),
                      onTap: () => _openUri('https://quickaidtech.com/'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const _FaqTile(
                title: 'What is the difference between soft and hard emergency?',
                body:
                    'Soft emergency quietly alerts priority responders first. Hard emergency starts the stronger escalation path for immediate danger.',
              ),
              const SizedBox(height: 12),
              const _FaqTile(
                title: 'What happens if the app is offline?',
                body:
                    'The app shows last known status with a clear banner and suggests safe fallback actions like calling key contacts directly.',
              ),
              const SizedBox(height: 12),
              const _FaqTile(
                title: 'Why is device detail separated from the home screen?',
                body:
                    'Device health is important, but it should not compete with emergency actions. The home screen shows the summary first and detail on tap.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(title),
        childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        children: [
          Text(body),
        ],
      ),
    );
  }
}
