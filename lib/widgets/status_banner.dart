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
    final style = _toneStyle(tone);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: style.border),
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
                    color: QatColors.textPrimary,
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

_BannerStyle _toneStyle(StatusTone tone) {
  switch (tone) {
    case StatusTone.ok:
      return const _BannerStyle(
        background: QatColors.okSoft,
        border: QatColors.cardBorder,
        iconBackground: Colors.white,
        foreground: QatColors.ok,
        icon: Icons.check_circle_outline_rounded,
      );
    case StatusTone.warning:
      return const _BannerStyle(
        background: QatColors.warningSoft,
        border: Color(0xFFF0D7A8),
        iconBackground: Colors.white,
        foreground: QatColors.warning,
        icon: Icons.info_outline_rounded,
      );
    case StatusTone.emergency:
      return const _BannerStyle(
        background: QatColors.emergencySoft,
        border: Color(0xFFF1C9C5),
        iconBackground: Colors.white,
        foreground: QatColors.emergency,
        icon: Icons.warning_amber_rounded,
      );
    case StatusTone.info:
      return const _BannerStyle(
        background: QatColors.infoSoft,
        border: Color(0xFFC7DEE9),
        iconBackground: Colors.white,
        foreground: QatColors.info,
        icon: Icons.wifi_tethering_error_rounded,
      );
  }
}
