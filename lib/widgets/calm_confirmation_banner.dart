import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class CalmConfirmationBanner extends StatelessWidget {
  const CalmConfirmationBanner({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;

    return Container(
      padding: EdgeInsets.all(ui.cardPadding),
      decoration: BoxDecoration(
        color: palette.okSoft,
        borderRadius: BorderRadius.circular(ui.cardRadius),
        border: Border.all(
          color: palette.cardBorderStrong,
          width: ui.accessibilityMode ? 2 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_rounded, color: palette.ok, size: ui.iconSize),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(message, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
