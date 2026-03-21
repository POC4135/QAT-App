import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../core/launch_service.dart';
import '../../models/device_health.dart';
import '../../widgets/simple_disclosure_card.dart';
import '../../widgets/status_banner.dart';

class DeviceDetailScreen extends StatelessWidget {
  const DeviceDetailScreen({super.key, required this.deviceId});

  final String deviceId;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final device = appState.deviceByIdOrNull(deviceId);
    if (device == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Device unavailable')),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'This device could not be found. Return to the devices tab for the latest list.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    final ui = context.qatUi;
    final tone = switch (device.status) {
      DeviceStatus.online => StatusTone.ok,
      DeviceStatus.needsAttention => StatusTone.warning,
      DeviceStatus.offline => StatusTone.emergency,
    };

    void runSystemTest() {
      appState.runSystemTest();
    }

    return Scaffold(
      appBar: AppBar(title: Text(device.name)),
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
              StatusBanner(
                tone: tone,
                title: device.status == DeviceStatus.online
                    ? 'Device ready'
                    : device.status == DeviceStatus.needsAttention
                        ? 'Device needs attention'
                        : 'Device offline',
                message: '${device.summary} ${device.lastCheckIn}',
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(ui.cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What to do',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        device.detailHint,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: runSystemTest,
                  child: const Text('Run system test'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: () => launchPhoneCall(context, '+1 404 555 0103'),
                  icon: const Icon(Icons.call_outlined),
                  label: const Text('Call support'),
                ),
              ),
              const SizedBox(height: 14),
              SimpleDisclosureCard(
                title: ui.accessibilityMode ? 'More details' : 'Location and health',
                subtitle: ui.accessibilityMode
                    ? 'Open if you want the battery level and last check-in.'
                    : 'Open for battery, location, and check-in details.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Battery: ${device.batteryLabel}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Location: ${device.location}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Last check-in: ${device.lastCheckIn}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
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
