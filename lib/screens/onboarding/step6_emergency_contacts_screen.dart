import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../models/onboarding_data.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_widgets.dart';

class OnboardingEmergencyContactsScreen extends StatefulWidget {
  const OnboardingEmergencyContactsScreen({super.key});

  @override
  State<OnboardingEmergencyContactsScreen> createState() =>
      _OnboardingEmergencyContactsScreenState();
}

class _OnboardingEmergencyContactsScreenState
    extends State<OnboardingEmergencyContactsScreen> {
  final List<_ContactForm> _contacts = [
    _ContactForm(id: '1', isPrimary: true),
  ];
  bool _isLoading = false;

  void _addContact() {
    setState(() => _contacts.add(
          _ContactForm(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            isPrimary: false,
          ),
        ));
  }

  void _removeContact(String id) {
    if (_contacts.length <= 1) return;
    setState(() => _contacts.removeWhere((c) => c.id == id));
  }

  void _setPrimary(String id) {
    setState(() {
      for (final c in _contacts) {
        c.isPrimary = c.id == id;
      }
    });
  }

  bool _validate() {
    bool valid = true;
    for (final c in _contacts) {
      c.nameError = null;
      c.phoneError = null;
      if (c.nameController.text.trim().isEmpty) {
        c.nameError = 'Name is required';
        valid = false;
      }
      final digits = c.phoneController.text.replaceAll(RegExp(r'\D'), '');
      if (digits.isEmpty) {
        c.phoneError = 'Phone number is required';
        valid = false;
      } else if (digits.length < 10) {
        c.phoneError = 'Enter a valid phone number';
        valid = false;
      }
    }
    setState(() {}); // refresh error display
    return valid;
  }

  Future<void> _handleComplete() async {
    if (!_validate()) return;
    setState(() => _isLoading = true);

    AppStateScope.of(context).saveOnboardingStep(
      (data) => data.copyWith(
        emergencyContacts: _contacts
            .map((c) => OnboardingEmergencyContact(
                  id: c.id,
                  fullName: c.nameController.text.trim(),
                  phone: c.phoneController.text.trim(),
                  relation: c.relationController.text.trim(),
                  isPrimary: c.isPrimary,
                ))
            .toList(),
      ),
    );

    AppStateScope.of(context).markOnboardingComplete();

    // TODO: call api.onboarding.saveEmergencyContacts(...)
    // TODO: call api.onboarding.complete()

    if (mounted) {
      setState(() => _isLoading = false);
      // Replace entire stack so back-nav doesn't return to onboarding
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    }
  }

  void _handleSkip() {
    AppStateScope.of(context).markOnboardingComplete();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
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
            OnboardingHeader(currentStep: 6, totalSteps: 6),

            Expanded(
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
                        color: palette.emergencySoft,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '✳',
                        style: TextStyle(
                          fontSize: 44,
                          color: palette.emergency,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Emergency Contacts',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'These contacts will be notified immediately in case of an incident.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Contact cards
                  ..._contacts.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final c = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ContactCard(
                        form: c,
                        index: idx + 1,
                        canRemove: _contacts.length > 1,
                        onRemove: () => _removeContact(c.id),
                        onSetPrimary: () => _setPrimary(c.id),
                      ),
                    );
                  }),

                  // Add contact
                  OutlinedButton.icon(
                    onPressed: _addContact,
                    icon: const Icon(Icons.person_add_outlined),
                    label: const Text('Add another contact'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Center(
                    child: TextButton(
                      onPressed: _handleSkip,
                      child: Text(
                        'Skip for now',
                        style: TextStyle(color: palette.textTertiary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Info box
                  OnboardingInfoBox(
                    icon: Icons.info_outline_rounded,
                    text:
                        'Emergency contacts are notified by SMS and phone call when an SOS is triggered. You can update these anytime from your Profile.',
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),

            OnboardingFooter(
              label: 'Add Emergency Contacts',
              isLoading: _isLoading,
              onTap: _handleComplete,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Form model ───────────────────────────────────────────────────────────────

class _ContactForm {
  _ContactForm({required this.id, required bool isPrimary})
      : nameController = TextEditingController(),
        phoneController = TextEditingController(),
        relationController = TextEditingController(),
        isPrimary = isPrimary;
  final String id;
  bool isPrimary;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController relationController;
  String? nameError;
  String? phoneError;
}

// ── Contact card ─────────────────────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.form,
    required this.index,
    required this.canRemove,
    required this.onRemove,
    required this.onSetPrimary,
  });
  final _ContactForm form;
  final int index;
  final bool canRemove;
  final VoidCallback onRemove;
  final VoidCallback onSetPrimary;

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    return parts
        .take(2)
        .map((w) => w.isEmpty ? '' : w[0])
        .join()
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final theme = Theme.of(context);
    final nameText = form.nameController.text;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Text(
                  form.isPrimary
                      ? 'CONTACT $index · PRIMARY'
                      : 'CONTACT $index',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: form.isPrimary
                        ? palette.ok
                        : palette.textTertiary,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (!form.isPrimary && canRemove) ...[
                  GestureDetector(
                    onTap: onSetPrimary,
                    child: Text(
                      'Set primary',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: palette.ok,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                if (canRemove)
                  GestureDetector(
                    onTap: onRemove,
                    child: Text(
                      'Remove',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: palette.emergency,
                      ),
                    ),
                  ),
              ],
            ),

            // Avatar preview (shown once a name is typed)
            if (nameText.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: palette.surfaceMuted,
                      shape: BoxShape.circle,
                      border: Border.all(color: palette.cardBorder),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _initials(nameText),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: palette.ok,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      nameText,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  if (form.isPrimary)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: palette.ok,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Primary',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ],

            const SizedBox(height: 12),
            OnboardingTextField(
              controller: form.nameController,
              label: 'Full name',
              hint: 'Sunita Sharma',
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              errorText: form.nameError,
              onChanged: (_) {}, // triggers rebuild for avatar preview
            ),
            const SizedBox(height: 10),
            OnboardingTextField(
              controller: form.phoneController,
              label: 'Phone number',
              hint: '+91 98765 43210',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              errorText: form.phoneError,
            ),
            const SizedBox(height: 10),
            OnboardingTextField(
              controller: form.relationController,
              label: 'Relation (optional)',
              hint: 'e.g. Daughter, Son, Spouse',
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }
}
