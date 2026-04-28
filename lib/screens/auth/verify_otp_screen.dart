import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';

/// 6-digit OTP verification screen.
///
/// Expects a [String] route argument containing the full phone number
/// (e.g. "+91 98765 43210") that was used to send the code.
///
/// TODO: Replace [_verifyOtp] stub with a real Twilio Verify check call once
/// the backend base-URL and service credentials are configured.
class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  static const _codeLength = 6;
  static const _resendCooldown = 30; // seconds

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  bool _isLoading = false;
  String? _errorMessage;

  // Resend countdown
  int _secondsLeft = _resendCooldown;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_codeLength, (_) => TextEditingController());
    _focusNodes = List.generate(_codeLength, (_) => FocusNode());
    _startCountdown();
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendCooldown);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) t.cancel();
      });
    });
  }

  String get _enteredCode =>
      _controllers.map((c) => c.text).join();

  // Handles a single digit being typed in box at [index].
  void _onDigitChanged(int index, String value) {
    if (value.isEmpty) return;
    // Accept only the last character (guards against paste arriving here)
    final digit = value[value.length - 1];
    _controllers[index].text = digit;
    _controllers[index].selection =
        TextSelection.collapsed(offset: digit.length);

    if (_errorMessage != null) setState(() => _errorMessage = null);

    if (index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else {
      // Last box — auto-submit
      _focusNodes[index].unfocus();
      _verifyOtp();
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  /// Handles pasting a 6-digit code into any box.
  void _onPaste(String value, int index) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < _codeLength) return;
    for (int i = 0; i < _codeLength; i++) {
      _controllers[i].text = digits[i];
    }
    _focusNodes[_codeLength - 1].requestFocus();
    if (_errorMessage != null) setState(() => _errorMessage = null);
    _verifyOtp();
  }

  Future<void> _verifyOtp() async {
    final code = _enteredCode;
    if (code.length < _codeLength) {
      setState(() => _errorMessage = 'Please enter the complete 6-digit code.');
      return;
    }

    setState(() { _errorMessage = null; _isLoading = true; });

    // TODO: final result = await ApiService.verifyOtp(phone: phone, code: code);
    // TODO: if (!result.success) { setState(() { _errorMessage = result.message; _isLoading = false; }); return; }
    // Remove the artificial delay once real API is wired.
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Sign the user in with a placeholder name; the real name comes from the
    // backend user profile response (swap the TODO above to get it).
    final phone = ModalRoute.of(context)?.settings.arguments as String? ?? '';
    AppStateScope.of(context).signIn(phone);

    final appState = AppStateScope.of(context);
    if (appState.onboardingComplete) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.onboardingProfile,
        (route) => false,
      );
    }
  }

  Future<void> _resendCode() async {
    if (_secondsLeft > 0) return;
    // TODO: await ApiService.sendOtp(phone: phone);
    _startCountdown();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('A new code has been sent.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phone =
        ModalRoute.of(context)?.settings.arguments as String? ?? '';
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
                // ── Back arrow ───────────────────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    tooltip: 'Back',
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ),
                const SizedBox(height: 8),

                // ── Logo ─────────────────────────────────────────────────────
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
                  'Verify your number',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: palette.textPrimary,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.textSecondary,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: 'We sent a 6-digit code to\n'),
                      TextSpan(
                        text: phone.isEmpty ? 'your phone' : phone,
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // ── OTP boxes ────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_codeLength, (i) {
                    return _OtpBox(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      isFirst: i == 0,
                      onChanged: (v) => _onDigitChanged(i, v),
                      onKeyEvent: (e) => _onKeyEvent(i, e),
                      onPaste: (v) => _onPaste(v, i),
                      hasError: _errorMessage != null,
                      palette: palette,
                      theme: theme,
                    );
                  }),
                ),

                // ── Error message ────────────────────────────────────────────
                if (_errorMessage != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _errorMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: palette.emergency,
                    ),
                  ),
                ],
                const SizedBox(height: 28),

                // ── Verify button ────────────────────────────────────────────
                SizedBox(
                  height: ui.buttonHeight,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _verifyOtp,
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Verify'),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Resend ───────────────────────────────────────────────────
                Center(
                  child: _secondsLeft > 0
                      ? Text(
                          'Resend code in $_secondsLeft s',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: palette.textTertiary,
                          ),
                        )
                      : TextButton(
                          onPressed: _resendCode,
                          child: Text(
                            'Resend code',
                            style: TextStyle(color: palette.ok),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Single OTP digit box ──────────────────────────────────────────────────────

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.isFirst,
    required this.onChanged,
    required this.onKeyEvent,
    required this.onPaste,
    required this.hasError,
    required this.palette,
    required this.theme,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFirst;
  final ValueChanged<String> onChanged;
  final ValueChanged<KeyEvent> onKeyEvent;
  final ValueChanged<String> onPaste;
  final bool hasError;
  final QatPalette palette;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        hasError ? palette.emergency : palette.cardBorder;
    final focusedBorderColor = hasError ? palette.emergency : palette.ok;

    return SizedBox(
      width: 46,
      height: 58,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: onKeyEvent,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: isFirst,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: focusedBorderColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: palette.emergency, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: palette.emergency, width: 2),
            ),
            filled: true,
            fillColor: palette.surfaceMuted,
          ),
          onChanged: (v) {
            // Handle paste: if more than 1 char arrives, treat as paste
            if (v.length > 1) {
              onPaste(v);
            } else {
              onChanged(v);
            }
          },
        ),
      ),
    );
  }
}
