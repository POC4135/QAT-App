class AppSessionState {
  const AppSessionState({
    required this.isSignedIn,
    required this.residentName,
    required this.homeLabel,
    this.onboardingComplete = false,
  });

  final bool isSignedIn;
  final String residentName;
  final String homeLabel;

  /// Whether the user has completed (or skipped) the onboarding flow.
  /// New users are routed through onboarding before reaching the main app.
  final bool onboardingComplete;

  AppSessionState copyWith({
    bool? isSignedIn,
    String? residentName,
    String? homeLabel,
    bool? onboardingComplete,
  }) {
    return AppSessionState(
      isSignedIn: isSignedIn ?? this.isSignedIn,
      residentName: residentName ?? this.residentName,
      homeLabel: homeLabel ?? this.homeLabel,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }
}
