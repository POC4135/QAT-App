import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/presentation.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../models/device_health.dart';
import '../../widgets/device_status_card.dart';
import '../../widgets/status_banner.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({
    super.key,
    this.showScreenTitle = true,
  });

  final bool showScreenTitle;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final warningCount = appState.devices
        .where((device) => device.status != DeviceStatus.online)
        .length;
    final ui = context.qatUi;

    void runSystemTest() {
      appState.runSystemTest();
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          ui.screenHorizontalPadding,
          ui.screenVerticalPadding,
          ui.screenHorizontalPadding,
          32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showScreenTitle) ...[
              Text('Devices', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                ui.accessibilityMode
                    ? 'Check device health at a glance.'
                    : 'Check health quickly, then drill into only the device that needs attention.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 18),
            ],
            StatusBanner(
              tone: warningCount == 0
                  ? deviceTone(DeviceStatus.online)
                  : deviceTone(DeviceStatus.needsAttention),
              title: warningCount == 0
                  ? 'All devices online'
                  : '$warningCount device${warningCount == 1 ? '' : 's'} need attention',
              message: warningCount == 0
                  ? 'No urgent action is needed right now.'
                  : 'Warnings are summarized first to avoid alarm fatigue. Open any device for simple next steps.',
            ),
            const SizedBox(height: 14),
            if (ui.accessibilityMode)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: runSystemTest,
                  child: const Text('Run system test'),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: EdgeInsets.all(ui.cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Use a system test as a maintenance action when you want a quick reassurance check.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: runSystemTest,
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

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Devices')),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: const DevicesScreen(showScreenTitle: false),
      ),
    );
  }
}
