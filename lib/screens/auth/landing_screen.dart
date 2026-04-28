import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_theme.dart';

/// Landing / splash screen — shown to unauthenticated users.
///
/// This is a pure marketing/intro screen. It does NOT collect credentials
/// directly. Tapping "Get Started" navigates to [WelcomeScreen] where the
/// phone-based OTP auth flow begins.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ui.screenHorizontalPadding,
            vertical: 32,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),

                // ── Logo + wordmark ───────────────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 88,
                        height: 88,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Alerto',
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: palette.info,       // navy
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'TECH',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: palette.ok,         // teal
                          letterSpacing: 4,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // ── Hero headline ─────────────────────────────────────────────
                Text(
                  'Your emergency\ncompanion',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: palette.textPrimary,
                    height: 1.15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Instant SOS alerts, smart device monitoring, and\nhousehold safety — all in one place.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: palette.textSecondary,
                    height: 1.55,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(flex: 3),

                // ── Feature pills ─────────────────────────────────────────────
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 8,
                  children: const [
                    _FeaturePill(icon: Icons.crisis_alert_rounded,  label: 'One-tap SOS'),
                    _FeaturePill(icon: Icons.devices_rounded,        label: 'Device health'),
                    _FeaturePill(icon: Icons.group_rounded,          label: 'Household'),
                    _FeaturePill(icon: Icons.history_rounded,        label: 'Incident log'),
                  ],
                ),

                const Spacer(flex: 2),

                // ── CTA buttons ───────────────────────────────────────────────
                SizedBox(
                  height: ui.buttonHeight,
                  child: FilledButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.authWelcome),
                    child: const Text('Get Started'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: ui.buttonHeight,
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.authWelcome),
                    child: const Text('Sign In'),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Trust footer ──────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline_rounded,
                        size: 14, color: palette.textTertiary),
                    const SizedBox(width: 6),
                    Text(
                      'End-to-end encrypted · Alerto Tech',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: palette.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Feature pill ──────────────────────────────────────────────────────────────

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: palette.ok),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
