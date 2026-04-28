/// Shared widgets used across all onboarding step screens.
library;

import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

// ── Text field ───────────────────────────────────────────────────────────────

/// A label + text field combo styled to match the QAT design system.
class OnboardingTextField extends StatelessWidget {
  const OnboardingTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.obscureText = false,
    this.maxLines = 1,
    this.validator,
    this.errorText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final IconData? prefixIcon;
  final bool obscureText;
  final int maxLines;
  final String? Function(String?)? validator;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final theme = Theme.of(context);

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: palette.cardBorder),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: palette.ok, width: 1.5),
    );
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: palette.emergency, width: 1.5),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: palette.textTertiary,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          obscureText: obscureText,
          maxLines: maxLines,
          onChanged: onChanged,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: palette.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: palette.textTertiary),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: palette.textTertiary)
                : null,
            filled: true,
            fillColor: palette.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: border,
            enabledBorder: errorText != null ? errorBorder : border,
            focusedBorder: errorText != null ? errorBorder : focusedBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
            errorText: errorText,
          ),
          validator: validator,
        ),
      ],
    );
  }
}

// ── Section label ────────────────────────────────────────────────────────────

class OnboardingSectionLabel extends StatelessWidget {
  const OnboardingSectionLabel({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: palette.textTertiary,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

// ── Info box ─────────────────────────────────────────────────────────────────

class OnboardingInfoBox extends StatelessWidget {
  const OnboardingInfoBox({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.infoSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.info.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: palette.info),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.info,
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Footer CTA ───────────────────────────────────────────────────────────────

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.cardBorder)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          onPressed: isLoading ? null : onTap,
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Text(label),
        ),
      ),
    );
  }
}
