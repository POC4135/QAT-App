import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../models/onboarding_data.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_widgets.dart';

class OnboardingHouseholdScreen extends StatefulWidget {
  const OnboardingHouseholdScreen({super.key});

  @override
  State<OnboardingHouseholdScreen> createState() =>
      _OnboardingHouseholdScreenState();
}

class _OnboardingHouseholdScreenState extends State<OnboardingHouseholdScreen> {
  final List<_MemberForm> _members = [
    _MemberForm(id: '1'),
  ];
  bool _isLoading = false;

  void _addMember() {
    setState(() => _members.add(
          _MemberForm(id: DateTime.now().millisecondsSinceEpoch.toString()),
        ));
  }

  Future<void> _handleSendInvite() async {
    // Validate only if any field is filled
    final anyFilled = _members.any(
      (m) =>
          m.nameController.text.trim().isNotEmpty ||
          m.phoneController.text.trim().isNotEmpty ||
          m.emailController.text.trim().isNotEmpty,
    );

    if (anyFilled) {
      // Basic phone validation
      for (final m in _members) {
        final phone = m.phoneController.text.trim();
        if (phone.isNotEmpty) {
          final digits = phone.replaceAll(RegExp(r'\D'), '');
          if (digits.length < 10) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Please enter a valid phone number.')),
            );
            return;
          }
        }
      }
    }

    setState(() => _isLoading = true);

    AppStateScope.of(context).saveOnboardingStep(
      (data) => data.copyWith(
        householdMembers: _members
            .map((m) => OnboardingHouseholdMember(
                  id: m.id,
                  fullName: m.nameController.text.trim(),
                  phone: m.phoneController.text.trim(),
                  email: m.emailController.text.trim(),
                ))
            .where((m) => m.fullName.isNotEmpty)
            .toList(),
      ),
    );

    // TODO: call api.onboarding.saveHousehold(...) and send invitations

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushNamed(context, AppRoutes.onboardingEmergencyContacts);
    }
  }

  void _handleSkip() =>
      Navigator.pushNamed(context, AppRoutes.onboardingEmergencyContacts);

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OnboardingHeader(currentStep: 5, totalSteps: 6),

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
                      height: 120,
                      decoration: BoxDecoration(
                        color: palette.surfaceMuted,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '👨‍👩‍👧',
                        style: const TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Your Household',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Invite people you live with to manage your home, smart devices, and shared schedules together.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Member cards
                  ..._members.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final m = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _MemberCard(
                        form: m,
                        index: idx + 1,
                        canRemove: _members.length > 1,
                        onRemove: () => setState(() => _members.remove(m)),
                      ),
                    );
                  }),

                  // Add another member
                  OutlinedButton.icon(
                    onPressed: _addMember,
                    icon: const Icon(Icons.add),
                    label: const Text('Add another member'),
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
                  const SizedBox(height: 32),
                ],
              ),
            ),

            OnboardingFooter(
              label: 'Send Invite →',
              isLoading: _isLoading,
              onTap: _handleSendInvite,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Form model ───────────────────────────────────────────────────────────────

class _MemberForm {
  _MemberForm({required this.id})
      : nameController = TextEditingController(),
        phoneController = TextEditingController(),
        emailController = TextEditingController();
  final String id;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
}

// ── Member card ──────────────────────────────────────────────────────────────

class _MemberCard extends StatelessWidget {
  const _MemberCard({
    required this.form,
    required this.index,
    required this.canRemove,
    required this.onRemove,
  });
  final _MemberForm form;
  final int index;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'MEMBER $index',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: palette.textTertiary,
                        letterSpacing: 1.4,
                      ),
                ),
                const Spacer(),
                if (canRemove)
                  GestureDetector(
                    onTap: onRemove,
                    child: Text(
                      'Remove',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: palette.emergency,
                          ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            OnboardingTextField(
              controller: form.nameController,
              label: 'Full name',
              hint: 'Rahul Sharma',
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            OnboardingTextField(
              controller: form.phoneController,
              label: 'Phone number',
              hint: '+91 98765 43210',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            OnboardingTextField(
              controller: form.emailController,
              label: 'Email address (optional)',
              hint: 'rahul@example.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }
}
