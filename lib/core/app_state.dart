import 'package:flutter/material.dart';

import 'app_session_state.dart';
import 'app_preferences.dart';
import 'emergency_store.dart';
import 'ui_preferences_state.dart';
import '../models/device_health.dart';
import '../models/emergency_contact.dart';
import '../models/emergency_incident.dart';
import '../models/onboarding_data.dart';
import '../models/resident_account.dart';

class AppStateController extends ChangeNotifier {
  AppStateController({
    AppPreferencesStore? preferences,
    bool initialAccessibilityMode = false,
  })  : _preferences = preferences,
        _session = AppSessionState(
          isSignedIn: false,
          residentName: 'Sample Resident',
          homeLabel: 'Sample Residence · Unit 12',
          onboardingComplete: preferences?.onboardingComplete ?? false,
        ),
        _uiPreferences = UiPreferencesState(
          accessibilityMode:
              preferences?.accessibilityMode ?? initialAccessibilityMode,
          exclamationMode: preferences?.exclamationMode ?? true,
          offlineMode: preferences?.offlineMode ?? false,
          lastSyncLabel:
              (preferences?.offlineMode ?? false)
                  ? 'Last sync 12 minutes ago'
                  : 'Synced 1 minute ago',
        ),
        _emergencyStore = EmergencyStore.seeded(),
        _historyFilter = HistoryFilter.all;

  final AppPreferencesStore? _preferences;
  AppSessionState _session;
  UiPreferencesState _uiPreferences;
  final EmergencyStore _emergencyStore;
  HistoryFilter _historyFilter;
  OnboardingData _onboardingData = OnboardingData.empty;

  AppSessionState get session => _session;
  UiPreferencesState get uiPreferences => _uiPreferences;
  bool get isSignedIn => _session.isSignedIn;
  bool get onboardingComplete => _session.onboardingComplete;
  OnboardingData get onboardingData => _onboardingData;
  ResidentAccount get account => ResidentAccount(
        name: _session.residentName,
        homeLabel: _session.homeLabel,
        lastSyncLabel: _uiPreferences.lastSyncLabel,
        accessibilityMode: _uiPreferences.accessibilityMode,
        exclamationMode: _uiPreferences.exclamationMode,
        offlineMode: _uiPreferences.offlineMode,
      );
  List<EmergencyContact> get contacts => _emergencyStore.contacts;
  List<DeviceHealth> get devices => _emergencyStore.devices;
  List<EmergencyIncident> get incidents => _emergencyStore.incidents;

  HistoryFilter get historyFilter => _historyFilter;
  bool get canSubmitStateChanges => !_uiPreferences.offlineMode;
  EmergencyIncident? get activeIncident => _emergencyStore.activeIncident;
  List<EmergencyContact> get primaryContacts => _emergencyStore.primaryContacts;

  List<EmergencyIncident> filteredIncidents() {
    switch (_historyFilter) {
      case HistoryFilter.all:
        return incidents;
      case HistoryFilter.emergencies:
        return incidents
            .where((incident) => incident.category == IncidentCategory.emergency)
            .toList();
      case HistoryFilter.devices:
        return incidents
            .where((incident) => incident.category == IncidentCategory.device)
            .toList();
    }
  }

  void signIn(String name) {
    _session = _session.copyWith(isSignedIn: true);
    if (name.trim().isNotEmpty) {
      _session = _session.copyWith(residentName: name.trim());
    }
    notifyListeners();
  }

  void signOut() {
    _session = _session.copyWith(isSignedIn: false);
    notifyListeners();
  }

  // ── Onboarding ────────────────────────────────────────────────────────────

  /// Saves data from a single onboarding step into the in-memory store.
  /// Each step calls this with a partial [OnboardingData] update.
  void saveOnboardingStep(OnboardingData Function(OnboardingData) updater) {
    _onboardingData = updater(_onboardingData);
    notifyListeners();
  }

  /// Marks onboarding as complete, persists the flag, and optionally updates
  /// the resident name from the collected profile data.
  void markOnboardingComplete() {
    final profile = _onboardingData.profile;
    _session = _session.copyWith(
      onboardingComplete: true,
      residentName: profile != null && profile.fullName.isNotEmpty
          ? profile.fullName
          : _session.residentName,
    );
    notifyListeners();
    _preferences?.setOnboardingComplete(true);
  }

  void setHistoryFilter(HistoryFilter value) {
    if (_historyFilter == value) {
      return;
    }
    _historyFilter = value;
    notifyListeners();
  }

  void setAccessibilityMode(bool value) {
    _uiPreferences = _uiPreferences.copyWith(accessibilityMode: value);
    notifyListeners();
    _preferences?.setAccessibilityMode(value);
  }

  void setExclamationMode(bool value) {
    _uiPreferences = _uiPreferences.copyWith(exclamationMode: value);
    notifyListeners();
    _preferences?.setExclamationMode(value);
  }

  void setOfflineMode(bool value) {
    _uiPreferences = _uiPreferences.copyWith(
      offlineMode: value,
      lastSyncLabel: value ? 'Last sync 12 minutes ago' : 'Synced just now',
    );
    notifyListeners();
    _preferences?.setOfflineMode(value);
  }

  EmergencyIncident startEmergency(IncidentKind kind) {
    final incident = _emergencyStore.startEmergency(kind);
    notifyListeners();
    return incident;
  }

  void acknowledgeIncident(String incidentId) {
    if (_emergencyStore.acknowledgeIncident(incidentId)) {
      notifyListeners();
    }
  }

  void cancelIncident(String incidentId) {
    if (_emergencyStore.cancelIncident(incidentId)) {
      notifyListeners();
    }
  }

  void resolveIncident(String incidentId) {
    if (_emergencyStore.resolveIncident(incidentId)) {
      notifyListeners();
    }
  }

  void runSystemTest() {
    _emergencyStore.runSystemTest();
    _uiPreferences = _uiPreferences.copyWith(lastSyncLabel: 'Synced just now');
    notifyListeners();
  }

  EmergencyIncident incidentById(String id) {
    return incidentByIdOrNull(id) ??
        (throw StateError('Incident not found for id: $id'));
  }

  EmergencyIncident? incidentByIdOrNull(String? id) {
    return _emergencyStore.incidentByIdOrNull(id);
  }

  DeviceHealth deviceById(String id) {
    return deviceByIdOrNull(id) ??
        (throw StateError('Device not found for id: $id'));
  }

  DeviceHealth? deviceByIdOrNull(String? id) {
    return _emergencyStore.deviceByIdOrNull(id);
  }

  EmergencyContact? contactById(String? id) {
    return _emergencyStore.contactById(id);
  }

  void saveContact(EmergencyContact contact) {
    _emergencyStore.saveContact(contact);
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppStateController> {
  const AppStateScope({
    super.key,
    required AppStateController notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppStateController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in context');
    return scope!.notifier!;
  }
}
