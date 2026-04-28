import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../models/onboarding_data.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_widgets.dart';

class OnboardingProfileScreen extends StatefulWidget {
  const OnboardingProfileScreen({super.key});

  @override
  State<OnboardingProfileScreen> createState() =>
      _OnboardingProfileScreenState();
}

class _OnboardingProfileScreenState extends State<OnboardingProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    AppStateScope.of(context).saveOnboardingStep(
      (data) => data.copyWith(
        profile: OnboardingProfile(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          dateOfBirth: _dobController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          profilePhotoPath: null,
        ),
      ),
    );

    // TODO: call api.onboarding.saveProfile(...)

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushNamed(context, AppRoutes.onboardingLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OnboardingHeader(
              currentStep: 1,
              totalSteps: 6,
              canGoBack: false,
            ),

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
                          Icons.person_rounded,
                          size: 44,
                          color: palette.ok,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Set Up Your Profile',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This information helps us personalise your emergency response and share it with responders quickly.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Name row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: OnboardingTextField(
                            controller: _firstNameController,
                            label: 'First name',
                            hint: 'Ananya',
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OnboardingTextField(
                            controller: _lastNameController,
                            label: 'Last name',
                            hint: 'Sharma',
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Required'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    OnboardingTextField(
                      controller: _dobController,
                      label: 'Date of birth',
                      hint: 'DD / MM / YYYY',
                      keyboardType: TextInputType.datetime,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    OnboardingTextField(
                      controller: _phoneController,
                      label: 'Phone number',
                      hint: '+91 98765 43210',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.phone_outlined,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        final digits = v.replaceAll(RegExp(r'\D'), '');
                        if (digits.length < 10) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    OnboardingTextField(
                      controller: _emailController,
                      label: 'Email address (optional)',
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icons.mail_outline_rounded,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return null;
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(v.trim())) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // CTA footer
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
