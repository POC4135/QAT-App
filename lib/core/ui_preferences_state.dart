class UiPreferencesState {
  const UiPreferencesState({
    required this.accessibilityMode,
    required this.exclamationMode,
    required this.offlineMode,
    required this.lastSyncLabel,
  });

  final bool accessibilityMode;
  final bool exclamationMode;
  final bool offlineMode;
  final String lastSyncLabel;

  UiPreferencesState copyWith({
    bool? accessibilityMode,
    bool? exclamationMode,
    bool? offlineMode,
    String? lastSyncLabel,
  }) {
    return UiPreferencesState(
      accessibilityMode: accessibilityMode ?? this.accessibilityMode,
      exclamationMode: exclamationMode ?? this.exclamationMode,
      offlineMode: offlineMode ?? this.offlineMode,
      lastSyncLabel: lastSyncLabel ?? this.lastSyncLabel,
    );
  }
}
