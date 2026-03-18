import 'package:flutter/material.dart';

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
    final tone = _statusTone(device.status);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      device.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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

_DeviceTone _statusTone(DeviceStatus status) {
  switch (status) {
    case DeviceStatus.online:
      return const _DeviceTone('Online', QatColors.ok);
    case DeviceStatus.needsAttention:
      return const _DeviceTone('Needs attention', QatColors.warning);
    case DeviceStatus.offline:
      return const _DeviceTone('Offline', QatColors.emergency);
  }
}
