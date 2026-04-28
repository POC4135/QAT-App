import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../models/onboarding_data.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_widgets.dart';

class OnboardingLocationScreen extends StatefulWidget {
  const OnboardingLocationScreen({super.key});

  @override
  State<OnboardingLocationScreen> createState() =>
      _OnboardingLocationScreenState();
}

class _OnboardingLocationScreenState extends State<OnboardingLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _houseIdentifierController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _houseIdentifierController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    AppStateScope.of(context).saveOnboardingStep(
      (data) => data.copyWith(
        location: OnboardingLocation(
          addressLine1: _addressLine1Controller.text.trim(),
          addressLine2: _addressLine2Controller.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim(),
          postalCode: _postalCodeController.text.trim(),
          country: 'India',
          houseIdentifier: _houseIdentifierController.text.trim(),
        ),
      ),
    );

    // TODO: call api.onboarding.saveLocation(...)

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushNamed(context, AppRoutes.onboardingMedical);
    }
  }

  void _handleSkip() =>
      Navigator.pushNamed(context, AppRoutes.onboardingMedical);

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OnboardingHeader(currentStep: 2, totalSteps: 6),

            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ui.screenHorizontalPadding,
                  ),
                  children: [
                    const SizedBox(height: 24),

                    // Illustration
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: palette.surfaceMuted,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on_rounded,
                          size: 44,
                          color: palette.ok,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Location Details',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Emergency responders need your exact address. This is shared only during an active incident.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),

                    OnboardingTextField(
                      controller: _addressLine1Controller,
                      label: 'Street address',
                      hint: '14, MG Road',
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.home_outlined,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Required'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    OnboardingTextField(
                      controller: _addressLine2Controller,
                      label: 'Apartment / floor / building (optional)',
                      hint: 'Flat 3B, Sunrise Towers',
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    OnboardingTextField(
                      controller: _houseIdentifierController,
                      label: 'Unit / house identifier (optional)',
                      hint: 'e.g. Block C, Villa 7',
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: OnboardingTextField(
                            controller: _cityController,
                            label: 'City',
                            hint: 'Bengaluru',
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: OnboardingTextField(
                            controller: _stateController,
                            label: 'State',
                            hint: 'Karnataka',
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: OnboardingTextField(
                            controller: _postalCodeController,
                            label: 'PIN',
                            hint: '560001',
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Privacy note
                    OnboardingInfoBox(
                      icon: Icons.lock_outline_rounded,
                      text:
                          'Your address is encrypted and shared only with verified emergency responders when an SOS is active.',
                    ),

                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: _handleSkip,
                        child: Text(
                          'Skip for now',
                          style: TextStyle(color: palette.textTertiary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            OnboardingFooter(
              label: 'Continue',
              isLoading: _isLoading,
              onTap: _handleContinue,
            ),
          ],
        ),
      ),
    );
  }
}
