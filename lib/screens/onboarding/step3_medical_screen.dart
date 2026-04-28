import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../models/onboarding_data.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_widgets.dart';

const _bloodTypes = ['A+', 'A−', 'B+', 'B−', 'AB+', 'AB−', 'O+', 'O−', 'Unknown'];

class OnboardingMedicalScreen extends StatefulWidget {
  const OnboardingMedicalScreen({super.key});

  @override
  State<OnboardingMedicalScreen> createState() =>
      _OnboardingMedicalScreenState();
}

class _OnboardingMedicalScreenState extends State<OnboardingMedicalScreen> {
  String _bloodType = 'Unknown';
  final List<String> _allergies = [];
  final _allergyController = TextEditingController();
  final List<_MedForm> _medications = [];
  final _medNotesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _allergyController.dispose();
    _medNotesController.dispose();
    super.dispose();
  }

  void _addAllergy() {
    final text = _allergyController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _allergies.add(text);
      _allergyController.clear();
    });
  }

  void _addMedication() {
    setState(() => _medications.add(_MedForm(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
        )));
  }

  Future<void> _handleContinue() async {
    setState(() => _isLoading = true);

    AppStateScope.of(context).saveOnboardingStep(
      (data) => data.copyWith(
        medical: OnboardingMedical(
          bloodType: _bloodType,
          allergies: _allergies
              .map((a) => OnboardingAllergy(
                    id: a.hashCode.toString(),
                    name: a,
                  ))
              .toList(),
          medications: _medications
              .map((m) => OnboardingMedication(
                    id: m.id,
                    name: m.nameController.text.trim(),
                    dose: m.doseController.text.trim(),
                    frequency: m.frequencyController.text.trim(),
                  ))
              .where((m) => m.name.isNotEmpty)
              .toList(),
          doctors: const [],
          medicalNotes: _medNotesController.text.trim(),
        ),
      ),
    );

    // TODO: call api.onboarding.saveMedical(...)

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushNamed(context, AppRoutes.onboardingHealth);
    }
  }

  void _handleSkip() => Navigator.pushNamed(context, AppRoutes.onboardingHealth);

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OnboardingHeader(currentStep: 3, totalSteps: 6),

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
                      child: Icon(
                        Icons.favorite_rounded,
                        size: 44,
                        color: palette.emergency,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Medical History',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Paramedics can act faster with this information. Everything is encrypted and shared only in emergencies.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Blood type
                  OnboardingSectionLabel(label: 'Blood type'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _bloodTypes.map((t) {
                      final selected = t == _bloodType;
                      return GestureDetector(
                        onTap: () => setState(() => _bloodType = t),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: selected ? palette.ok : palette.surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: selected
                                  ? palette.ok
                                  : palette.cardBorder,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            t,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: selected
                                  ? Colors.white
                                  : palette.textPrimary,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Allergies
                  OnboardingSectionLabel(label: 'Allergies'),
                  const SizedBox(height: 8),
                  if (_allergies.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _allergies.map<Widget>((a) {
                        return _AllergyTag(
                          label: a,
                          onRemove: () =>
                              setState(() => _allergies.remove(a)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _allergyController,
                          decoration: InputDecoration(
                            hintText: 'e.g. Penicillin, Peanuts',
                            hintStyle: TextStyle(color: palette.textTertiary),
                            filled: true,
                            fillColor: palette.surface,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: palette.cardBorder),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: palette.cardBorder),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _addAllergy(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.tonal(
                        onPressed: _addAllergy,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Medications
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OnboardingSectionLabel(label: 'Medications'),
                      TextButton.icon(
                        onPressed: _addMedication,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._medications.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final med = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _MedicationCard(
                        med: med,
                        index: idx + 1,
                        onRemove: () =>
                            setState(() => _medications.remove(med)),
                      ),
                    );
                  }),
                  if (_medications.isEmpty)
                    Text(
                      'No medications added',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: palette.textTertiary,
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Notes
                  OnboardingSectionLabel(
                    label: 'Additional medical notes (optional)',
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _medNotesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText:
                          'e.g. Diabetic, pacemaker fitted, surgical history…',
                      hintStyle: TextStyle(color: palette.textTertiary),
                      filled: true,
                      fillColor: palette.surface,
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: palette.cardBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: palette.cardBorder),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
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

// ── Local widgets ────────────────────────────────────────────────────────────

class _AllergyTag extends StatelessWidget {
  const _AllergyTag({
    required this.label,
    required this.onRemove,
  });
  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: palette.emergencySoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.emergency.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: palette.emergency,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close_rounded, size: 16, color: palette.emergency),
          ),
        ],
      ),
    );
  }
}

class _MedForm {
  _MedForm({required this.id})
      : nameController = TextEditingController(),
        doseController = TextEditingController(),
        frequencyController = TextEditingController();
  final String id;
  final TextEditingController nameController;
  final TextEditingController doseController;
  final TextEditingController frequencyController;
}

class _MedicationCard extends StatelessWidget {
  const _MedicationCard({
    required this.med,
    required this.index,
    required this.onRemove,
  });
  final _MedForm med;
  final int index;
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
                  'Medication $index',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: palette.textTertiary,
                        letterSpacing: 1.2,
                      ),
                ),
                const Spacer(),
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
            const SizedBox(height: 10),
            OnboardingTextField(
              controller: med.nameController,
              label: 'Medication name',
              hint: 'e.g. Metformin',
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OnboardingTextField(
                    controller: med.doseController,
                    label: 'Dose',
                    hint: '500 mg',
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OnboardingTextField(
                    controller: med.frequencyController,
                    label: 'Frequency',
                    hint: 'Twice daily',
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
