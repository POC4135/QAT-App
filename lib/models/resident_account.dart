class ResidentAccount {
  const ResidentAccount({
    required this.name,
    required this.homeLabel,
    required this.lastSyncLabel,
    required this.accessibilityMode,
    required this.exclamationMode,
    required this.offlineMode,
  });

  final String name;
  final String homeLabel;
  final String lastSyncLabel;
  final bool accessibilityMode;
  final bool exclamationMode;
  final bool offlineMode;

  ResidentAccount copyWith({
    String? name,
    String? homeLabel,
    String? lastSyncLabel,
    bool? accessibilityMode,
    bool? exclamationMode,
    bool? offlineMode,
  }) {
    return ResidentAccount(
      name: name ?? this.name,
      homeLabel: homeLabel ?? this.homeLabel,
      lastSyncLabel: lastSyncLabel ?? this.lastSyncLabel,
      accessibilityMode: accessibilityMode ?? this.accessibilityMode,
      exclamationMode: exclamationMode ?? this.exclamationMode,
      offlineMode: offlineMode ?? this.offlineMode,
    );
  }
}
