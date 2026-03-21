import 'package:flutter/material.dart';

import '../core/app_theme.dart';

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
    final ui = context.qatUi;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(ui.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              accessibilityMode ? 'Accessibility Mode is On' : 'Safety & Accessibility',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              accessibilityMode
                  ? 'Large text, stronger contrast, simpler layouts, and calmer motion are active across the app.'
                  : 'Reduce density, simplify reading, and keep safety controls obvious.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            if (accessibilityMode) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => onAccessibilityChanged(false),
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('Turn Off Accessibility Mode'),
                ),
              ),
              const SizedBox(height: 12),
            ] else
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Accessibility Mode'),
                subtitle: const Text(
                  'Larger text, bigger controls, and fewer distractions.',
                ),
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
