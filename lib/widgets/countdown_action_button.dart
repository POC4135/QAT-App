import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class CountdownActionButton extends StatelessWidget {
  const CountdownActionButton({
    super.key,
    required this.label,
    required this.remainingSeconds,
    required this.progress,
    required this.onPressed,
  });

  final String label;
  final int remainingSeconds;
  final double progress;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;
    final buttonColor = Theme.of(context).colorScheme.primary;
    final safeProgress = progress.clamp(0.0, 1.0);
    final countdownText = ui.accessibilityMode
        ? '$remainingSeconds sec'
        : '${remainingSeconds}s';

    return Semantics(
      button: true,
      label: label,
      value:
          'Auto triggers in $remainingSeconds second${remainingSeconds == 1 ? '' : 's'}.',
      onTap: onPressed,
      child: SizedBox(
        width: double.infinity,
        height: ui.buttonHeight,
        child: Material(
          color: buttonColor,
          borderRadius: BorderRadius.circular(ui.disclosureRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(ui.disclosureRadius),
            onTap: onPressed,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ui.disclosureRadius),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: safeProgress,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: ui.accessibilityMode ? 0.14 : 0.18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ui.accessibilityMode ? 20 : 18,
                        vertical: ui.accessibilityMode ? 12 : 10,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              label,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ui.accessibilityMode ? 14 : 10,
                              vertical: ui.accessibilityMode ? 8 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: palette.surface.withValues(
                                alpha: ui.accessibilityMode ? 0.22 : 0.18,
                              ),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.7),
                                width: ui.accessibilityMode ? 1.5 : 1,
                              ),
                            ),
                            child: Text(
                              countdownText,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: LinearProgressIndicator(
                      value: safeProgress,
                      minHeight: ui.accessibilityMode ? 5 : 4,
                      backgroundColor: Colors.white.withValues(alpha: 0.14),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
