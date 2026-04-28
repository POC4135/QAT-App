import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_routes.dart';
import '../../core/app_theme.dart';

/// Phone-number entry screen.
///
/// Collects a mobile number with country-code prefix, then navigates to
/// [AppRoutes.authVerifyOtp] passing the fully-formed number as a [String]
/// route argument.
///
/// TODO: Replace [_sendOtp] stub with a real Twilio Verify call once backend
/// base-URL and credentials are wired in (e.g. via `ApiService.sendOtp`).
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _phoneController = TextEditingController();
  final _phoneFocus = FocusNode();
  bool _isLoading = false;
  String? _phoneError;

  // Country codes shown in the picker.
  static const _countryCodes = [
    _CountryCode(flag: '🇮🇳', dial: '+91', name: 'India'),
    _CountryCode(flag: '🇺🇸', dial: '+1',  name: 'United States'),
    _CountryCode(flag: '🇬🇧', dial: '+44', name: 'United Kingdom'),
    _CountryCode(flag: '🇦🇪', dial: '+971', name: 'UAE'),
    _CountryCode(flag: '🇸🇬', dial: '+65', name: 'Singapore'),
  ];
  _CountryCode _selectedCode = _countryCodes.first;

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  String? _validatePhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return 'Phone number is required';
    if (digits.length < 7)  return 'Enter a valid phone number';
    return null;
  }

  Future<void> _sendOtp() async {
    final error = _validatePhone(_phoneController.text);
    if (error != null) {
      setState(() => _phoneError = error);
      _phoneFocus.requestFocus();
      return;
    }
    setState(() { _phoneError = null; _isLoading = true; });

    final fullPhone =
        '${_selectedCode.dial}${_phoneController.text.trim()}';

    // TODO: await ApiService.sendOtp(phone: fullPhone);
    // Remove the artificial delay below once real API is wired.
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushNamed(
      context,
      AppRoutes.authVerifyOtp,
      arguments: fullPhone,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: ui.screenHorizontalPadding,
            vertical: 32,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Back arrow ──────────────────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    tooltip: 'Back',
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ),
                const SizedBox(height: 8),

                // ── Logo (small) ─────────────────────────────────────────────
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 56,
                    height: 56,
                  ),
                ),
                const SizedBox(height: 32),

                // ── Heading ──────────────────────────────────────────────────
                Text(
                  'Enter your\nphone number',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: palette.textPrimary,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'We\'ll send a one-time code to verify your number.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: palette.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // ── Phone input row ──────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Country code chip
                    _CountryPicker(
                      selected: _selectedCode,
                      codes: _countryCodes,
                      onChanged: (code) =>
                          setState(() => _selectedCode = code),
                    ),
                    const SizedBox(width: 10),
                    // Number field
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        focusNode: _phoneFocus,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        autofocus: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[\d\s\-\(\)]')),
                        ],
                        onSubmitted: (_) => _sendOtp(),
                        onChanged: (_) {
                          if (_phoneError != null) {
                            setState(() => _phoneError = null);
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Phone number',
                          hintText: '98765 43210',
                          errorText: _phoneError,
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: palette.textTertiary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Send OTP button ──────────────────────────────────────────
                SizedBox(
                  height: ui.buttonHeight,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _sendOtp,
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Send Code'),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Privacy note ─────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline_rounded,
                        size: 14, color: palette.textTertiary),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Your number is only used for sign-in. We never share it.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: palette.textTertiary,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Country picker ────────────────────────────────────────────────────────────

class _CountryCode {
  const _CountryCode({
    required this.flag,
    required this.dial,
    required this.name,
  });
  final String flag;
  final String dial;
  final String name;
}

class _CountryPicker extends StatelessWidget {
  const _CountryPicker({
    required this.selected,
    required this.codes,
    required this.onChanged,
  });
  final _CountryCode selected;
  final List<_CountryCode> codes;
  final ValueChanged<_CountryCode> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () async {
        final picked = await showModalBottomSheet<_CountryCode>(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (ctx) {
            return ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Text('Select country',
                      style: theme.textTheme.titleMedium),
                ),
                const Divider(height: 1),
                ...codes.map((code) => ListTile(
                      leading: Text(code.flag,
                          style: const TextStyle(fontSize: 22)),
                      title: Text(code.name),
                      trailing: Text(
                        code.dial,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                      onTap: () => Navigator.pop(ctx, code),
                    )),
                const SizedBox(height: 8),
              ],
            );
          },
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: palette.cardBorder),
          borderRadius: BorderRadius.circular(12),
          color: palette.surfaceMuted,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selected.flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 6),
            Text(
              selected.dial,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.expand_more_rounded,
                size: 18, color: palette.textTertiary),
          ],
        ),
      ),
    );
  }
}
