import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../models/emergency_incident.dart';
import '../../widgets/status_banner.dart';

class EmergencyChoiceScreen extends StatefulWidget {
  const EmergencyChoiceScreen({super.key});

  @override
  State<EmergencyChoiceScreen> createState() => _EmergencyChoiceScreenState();
}

class _EmergencyChoiceScreenState extends State<EmergencyChoiceScreen> {
  IncidentKind? _selectedKind;

  void _continue() {
    if (_selectedKind == null) {
      return;
    }
    final incident = AppStateScope.of(context).startEmergency(_selectedKind!);
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.emergencyActive,
      arguments: incident.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose emergency type')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose the clearest response path',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Keep the next action simple. Choose the option that best matches what is happening right now.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 18),
              const StatusBanner(
                tone: StatusTone.warning,
                title: 'Smoke or gas detected?',
                message:
                    'Move to safety first. Use the hard emergency flow if there is immediate danger and you need a louder response.',
              ),
              const SizedBox(height: 18),
              _EmergencyChoiceCard(
                title: 'Soft emergency',
                subtitle:
                    'Quietly alert security and priority contacts first. Best when you need help quickly without triggering a loud alarm.',
                selected: _selectedKind == IncidentKind.soft,
                onTap: () => setState(() => _selectedKind = IncidentKind.soft),
              ),
              const SizedBox(height: 12),
              _EmergencyChoiceCard(
                title: 'Hard emergency',
                subtitle:
                    'Start the stronger response path. Use this for immediate danger, no response, or a situation that should escalate quickly.',
                selected: _selectedKind == IncidentKind.hard,
                onTap: () => setState(() => _selectedKind = IncidentKind.hard),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _selectedKind == null ? null : _continue,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Continue to emergency status'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmergencyChoiceCard extends StatelessWidget {
  const _EmergencyChoiceCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor,
                  ),
                ),
                child: Icon(
                  selected ? Icons.check_rounded : Icons.circle_outlined,
                  size: 18,
                  color: selected ? Colors.white : Theme.of(context).dividerColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
