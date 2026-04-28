import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_state.dart';
import '../../core/app_theme.dart';
import '../../models/onboarding_data.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_widgets.dart';

class OnboardingHealthScreen extends StatefulWidget {
  const OnboardingHealthScreen({super.key});

  @override
  State<OnboardingHealthScreen> createState() => _OnboardingHealthScreenState();
}

class _OnboardingHealthScreenState extends State<OnboardingHealthScreen> {
  final List<_HospitalForm> _hospitals = [
    _HospitalForm(id: '1'),
  ];
  final List<_DoctorForm> _doctors = [];
  bool _isLoading = false;

  void _addHospital() {
    setState(() => _hospitals.add(
          _HospitalForm(id: DateTime.now().millisecondsSinceEpoch.toString()),
        ));
  }

  void _addDoctor() {
    setState(() => _doctors.add(
          _DoctorForm(id: DateTime.now().millisecondsSinceEpoch.toString()),
        ));
  }

  Future<void> _handleContinue() async {
    setState(() => _isLoading = true);

    AppStateScope.of(context).saveOnboardingStep(
      (data) => data.copyWith(
        health: OnboardingHealth(
          preferredHospitals: _hospitals
              .map((h) => OnboardingHospital(
                    id: h.id,
                    name: h.nameController.text.trim(),
                    address: h.addressController.text.trim(),
                  ))
              .where((h) => h.name.isNotEmpty)
              .toList(),
          preferredDoctors: _doctors
              .map((d) => OnboardingDoctor(
                    id: d.id,
                    name: d.nameController.text.trim(),
                    specialty: d.specialtyController.text.trim(),
                    hospital: d.hospitalController.text.trim(),
                    phone: d.phoneController.text.trim(),
                  ))
              .where((d) => d.name.isNotEmpty)
              .toList(),
        ),
      ),
    );

    // TODO: call api.onboarding.saveHealth(...)

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushNamed(context, AppRoutes.onboardingHousehold);
    }
  }

  void _handleSkip() =>
      Navigator.pushNamed(context, AppRoutes.onboardingHousehold);

  @override
  Widget build(BuildContext context) {
    final palette = context.qatPalette;
    final ui = context.qatUi;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OnboardingHeader(currentStep: 4, totalSteps: 6),

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
                        color: palette.infoSoft,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.local_hospital_rounded,
                        size: 44,
                        color: palette.info,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Health & Preferences',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Responders can contact the right facility faster when they know your preferred hospitals and doctors.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Preferred hospitals
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OnboardingSectionLabel(label: 'Preferred hospitals'),
                      TextButton.icon(
                        onPressed: _addHospital,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._hospitals.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final h = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _HospitalCard(
                        form: h,
                        index: idx + 1,
                        canRemove: _hospitals.length > 1,
                        onRemove: () => setState(() => _hospitals.remove(h)),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),

                  // Preferred doctors
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OnboardingSectionLabel(label: 'Preferred doctors'),
                      TextButton.icon(
                        onPressed: _addDoctor,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_doctors.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OutlinedButton.icon(
                        onPressed: _addDoctor,
                        icon: const Icon(Icons.person_add_outlined),
                        label: const Text('Add a doctor'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                        ),
                      ),
                    )
                  else
                    ..._doctors.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final d = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _DoctorCard(
                          form: d,
                          index: idx + 1,
                          onRemove: () => setState(() => _doctors.remove(d)),
                        ),
                      );
                    }),

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

// ── Form data holders ────────────────────────────────────────────────────────

class _HospitalForm {
  _HospitalForm({required this.id})
      : nameController = TextEditingController(),
        addressController = TextEditingController();
  final String id;
  final TextEditingController nameController;
  final TextEditingController addressController;
}

class _DoctorForm {
  _DoctorForm({required this.id})
      : nameController = TextEditingController(),
        specialtyController = TextEditingController(),
        hospitalController = TextEditingController(),
        phoneController = TextEditingController();
  final String id;
  final TextEditingController nameController;
  final TextEditingController specialtyController;
  final TextEditingController hospitalController;
  final TextEditingController phoneController;
}

// ── Local card widgets ───────────────────────────────────────────────────────

class _HospitalCard extends StatelessWidget {
  const _HospitalCard({
    required this.form,
    required this.index,
    required this.canRemove,
    required this.onRemove,
  });
  final _HospitalForm form;
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
                Icon(Icons.local_hospital_outlined,
                    size: 18, color: palette.info),
                const SizedBox(width: 6),
                Text(
                  'Hospital $index',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: palette.textTertiary,
                        letterSpacing: 1.2,
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
            const SizedBox(height: 10),
            OnboardingTextField(
              controller: form.nameController,
              label: 'Hospital name',
              hint: 'Manipal Hospitals',
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            OnboardingTextField(
              controller: form.addressController,
              label: 'Address (optional)',
              hint: '98, HAL Airport Road',
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({
    required this.form,
    required this.index,
    required this.onRemove,
  });
  final _DoctorForm form;
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
                Icon(Icons.person_outline_rounded,
                    size: 18, color: palette.info),
                const SizedBox(width: 6),
                Text(
                  'Doctor $index',
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
              controller: form.nameController,
              label: 'Doctor name',
              hint: 'Dr. Priya Nair',
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OnboardingTextField(
                    controller: form.specialtyController,
                    label: 'Specialty',
                    hint: 'Cardiologist',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OnboardingTextField(
                    controller: form.phoneController,
                    label: 'Phone',
                    hint: '+91 98765 43210',
                    keyboardType: TextInputType.phone,
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
