import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../models/device_health.dart';
import '../../widgets/device_status_card.dart';
import '../../widgets/status_banner.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final warningCount = appState.devices
        .where((device) => device.status != DeviceStatus.online)
        .length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Devices',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Check health quickly, then drill into only the device that needs attention.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 18),
            StatusBanner(
              tone: warningCount == 0 ? StatusTone.ok : StatusTone.warning,
              title: warningCount == 0
                  ? 'All devices online'
                  : '$warningCount device${warningCount == 1 ? '' : 's'} need attention',
              message: warningCount == 0
                  ? 'No urgent action is needed right now.'
                  : 'Warnings are summarized first to avoid alarm fatigue. Open any device for simple next steps.',
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Use a system test as a maintenance action when you want a quick reassurance check.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {
                        appState.runSystemTest();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('System test completed successfully.'),
                          ),
                        );
                      },
                      child: const Text('Run system test'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            for (final device in appState.devices) ...[
              DeviceStatusCard(
                device: device,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.deviceDetail,
                  arguments: device.id,
                ),
              ),
              if (device != appState.devices.last) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
