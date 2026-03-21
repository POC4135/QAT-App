import 'package:flutter/material.dart';

import '../core/app_theme.dart';

enum StatusTone { ok, warning, emergency, info }

class StatusBanner extends StatelessWidget {
  const StatusBanner({
    super.key,
    required this.tone,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon,
  });

  final StatusTone tone;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;
    final style = _toneStyle(palette, tone);

    return Container(
      padding: EdgeInsets.all(ui.cardPadding),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(ui.cardRadius),
        border: Border.all(
          color: style.border,
          width: ui.accessibilityMode ? 2 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: style.iconBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon ?? style.icon, color: style.foreground),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(message, style: Theme.of(context).textTheme.bodyMedium),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 14),
                  FilledButton.tonal(
                    onPressed: onAction,
                    child: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerStyle {
  const _BannerStyle({
    required this.background,
    required this.border,
    required this.iconBackground,
    required this.foreground,
    required this.icon,
  });

  final Color background;
  final Color border;
  final Color iconBackground;
  final Color foreground;
  final IconData icon;
}

_BannerStyle _toneStyle(QatPalette palette, StatusTone tone) {
  switch (tone) {
    case StatusTone.ok:
      return _BannerStyle(
        background: palette.okSoft,
        border: palette.cardBorderStrong,
        iconBackground: Colors.white,
        foreground: palette.ok,
        icon: Icons.check_circle_outline_rounded,
      );
    case StatusTone.warning:
      return _BannerStyle(
        background: palette.warningSoft,
        border: palette.warning,
        iconBackground: Colors.white,
        foreground: palette.warning,
        icon: Icons.info_outline_rounded,
      );
    case StatusTone.emergency:
      return _BannerStyle(
        background: palette.emergencySoft,
        border: palette.emergency,
        iconBackground: Colors.white,
        foreground: palette.emergency,
        icon: Icons.warning_amber_rounded,
      );
    case StatusTone.info:
      return _BannerStyle(
        background: palette.infoSoft,
        border: palette.info,
        iconBackground: Colors.white,
        foreground: palette.info,
        icon: Icons.wifi_tethering_error_rounded,
      );
  }
}
