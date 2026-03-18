import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_state.dart';
import '../../models/device_health.dart';
import '../../widgets/status_banner.dart';

class DeviceDetailScreen extends StatelessWidget {
  const DeviceDetailScreen({super.key, required this.deviceId});

  final String deviceId;

  Future<void> _callSupport() async {
    await launchUrl(Uri(
      scheme: 'tel',
      path: '+1 404 555 0103',
    ));
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final device = appState.deviceById(deviceId);
    final tone = switch (device.status) {
      DeviceStatus.online => StatusTone.ok,
      DeviceStatus.needsAttention => StatusTone.warning,
      DeviceStatus.offline => StatusTone.emergency,
    };

    return Scaffold(
      appBar: AppBar(title: Text(device.name)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
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
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What to do',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(device.detailHint),
                      const SizedBox(height: 10),
                      Text(
                        'Battery: ${device.batteryLabel}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location and health',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Text('Location: ${device.location}'),
                      const SizedBox(height: 8),
                      Text('Last check-in: ${device.lastCheckIn}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    appState.runSystemTest();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('A fresh system test has been run.'),
                      ),
                    );
                  },
                  child: const Text('Run system test'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: _callSupport,
                  icon: const Icon(Icons.call_outlined),
                  label: const Text('Call support'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
