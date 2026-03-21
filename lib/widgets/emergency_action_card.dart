import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class EmergencyActionCard extends StatelessWidget {
  const EmergencyActionCard({
    super.key,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimaryTap,
    this.useRoundPrimary = false,
    this.secondaryLabel,
    this.onSecondaryTap,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimaryTap;
  final bool useRoundPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(ui.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: palette.emergencySoft,
                    borderRadius: BorderRadius.circular(ui.disclosureRadius),
                  ),
                  child: Icon(
                    Icons.support_agent_rounded,
                    color: palette.emergency,
                    size: ui.iconSize,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 18),
            if (useRoundPrimary) ...[
              Center(
                child: Semantics(
                  button: true,
                  label: primaryLabel,
                  child: InkWell(
                    onTap: onPrimaryTap,
                    borderRadius: BorderRadius.circular(36),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Column(
                        children: [
                          Ink(
                            width: ui.heroButtonSize,
                            height: ui.heroButtonSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  palette.emergency,
                                  palette.emergency.withValues(alpha: 0.92),
                                ],
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x33C63F36),
                                  blurRadius: 24,
                                  offset: Offset(0, 12),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.emergency_rounded,
                                size: 64,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            primaryLabel,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: palette.textPrimary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: Semantics(
                  button: true,
                  label: primaryLabel,
                  child: FilledButton.icon(
                    onPressed: onPrimaryTap,
                    icon: const Icon(Icons.emergency_rounded),
                    label: Text(primaryLabel),
                  ),
                ),
              ),
            ],
            if (secondaryLabel != null && onSecondaryTap != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onSecondaryTap,
                  child: Text(secondaryLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
