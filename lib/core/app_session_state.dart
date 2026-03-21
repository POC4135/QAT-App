class AppSessionState {
  const AppSessionState({
    required this.isSignedIn,
    required this.residentName,
    required this.homeLabel,
  });

  final bool isSignedIn;
  final String residentName;
  final String homeLabel;

  AppSessionState copyWith({
    bool? isSignedIn,
    String? residentName,
    String? homeLabel,
  }) {
    return AppSessionState(
      isSignedIn: isSignedIn ?? this.isSignedIn,
      residentName: residentName ?? this.residentName,
      homeLabel: homeLabel ?? this.homeLabel,
    );
  }
}
