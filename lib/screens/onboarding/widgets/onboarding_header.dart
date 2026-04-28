import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

/// Sticky header shown at the top of every onboarding step.
///
/// Contains:
///  - A back button (hidden on step 1 when [canGoBack] is false)
///  - "Step X of Y" label
///  - An animated progress bar that fills proportionally
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.canGoBack = true,
    this.onBack,
  });

  final int currentStep;
  final int totalSteps;
  final bool canGoBack;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;
    final progress = currentStep / totalSteps;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        ui.screenHorizontalPadding,
        ui.screenVerticalPadding,
        ui.screenHorizontalPadding,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Back button — hidden on step 1 (first screen after sign-in)
              if (canGoBack)
                Semantics(
                  button: true,
                  label: 'Go back',
                  child: GestureDetector(
                    onTap: onBack ?? () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: palette.surfaceMuted,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: ui.iconSize,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(width: 40),
              const Spacer(),
              Text(
                'Step $currentStep of $totalSteps',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: palette.textTertiary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: palette.surfaceMuted,
                  color: palette.ok,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
