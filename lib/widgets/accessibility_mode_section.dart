import 'package:flutter/material.dart';

class AccessibilityModeSection extends StatelessWidget {
  const AccessibilityModeSection({
    super.key,
    required this.accessibilityMode,
    required this.exclamationMode,
    required this.onAccessibilityChanged,
    required this.onExclamationChanged,
  });

  final bool accessibilityMode;
  final bool exclamationMode;
  final ValueChanged<bool> onAccessibilityChanged;
  final ValueChanged<bool> onExclamationChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Safety & Accessibility',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Reduce density, simplify reading, and keep safety controls obvious.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Accessibility Mode'),
              subtitle: const Text('Larger, calmer interface with fewer distractions.'),
              value: accessibilityMode,
              onChanged: onAccessibilityChanged,
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Exclamation Mode'),
              subtitle:
                  const Text('Keep safety prompts prominent during active incidents.'),
              value: exclamationMode,
              onChanged: onExclamationChanged,
            ),
          ],
        ),
      ),
    );
  }
}
