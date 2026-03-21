import 'package:flutter/material.dart';

import '../core/presentation.dart';
import '../core/app_theme.dart';
import '../models/device_health.dart';

class DeviceStatusCard extends StatelessWidget {
  const DeviceStatusCard({
    super.key,
    required this.device,
    required this.onTap,
  });

  final DeviceHealth device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ui = context.qatUi;
    final palette = context.qatPalette;
    final tone = _DeviceTone(
      deviceStatusLabel(device.status),
      switch (device.status) {
        DeviceStatus.online => palette.ok,
        DeviceStatus.needsAttention => palette.warning,
        DeviceStatus.offline => palette.emergency,
      },
    );

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(ui.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(ui.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    device.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  _StatusPill(label: tone.label, color: tone.color),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${device.location} · ${device.lastCheckIn}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Text(device.summary, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.qatUi.accessibilityMode ? 14 : 10,
        vertical: context.qatUi.accessibilityMode ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}

class _DeviceTone {
  const _DeviceTone(this.label, this.color);

  final String label;
  final Color color;
}
