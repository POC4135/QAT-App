import 'package:flutter/material.dart';

import '../models/device_health.dart';
import '../models/emergency_contact.dart';
import '../models/emergency_incident.dart';
import '../models/resident_account.dart';

class AppStateController extends ChangeNotifier {
  AppStateController()
      : account = ResidentAccount(
          name: 'Sample Resident',
          homeLabel: 'Sample Residence · Unit 12',
          lastSyncLabel: 'Synced 1 minute ago',
          accessibilityMode: false,
          exclamationMode: true,
          offlineMode: false,
        ),
        contacts = [
          EmergencyContact(
            id: 'contact-1',
            name: 'Primary Contact',
            role: 'Primary family contact',
            phone: '+1 404 555 0101',
            relationship: 'Family',
            priority: 1,
            isPrimary: true,
            supportsMessaging: true,
          ),
          EmergencyContact(
            id: 'contact-2',
            name: 'Primary Doctor',
            role: 'Doctor',
            phone: '+1 404 555 0102',
            relationship: 'Physician',
            priority: 2,
            isPrimary: false,
            supportsMessaging: false,
          ),
          EmergencyContact(
            id: 'contact-3',
            name: 'Society Security Desk',
            role: 'Building response desk',
            phone: '+1 404 555 0103',
            relationship: 'Security',
            priority: 3,
            isPrimary: false,
            supportsMessaging: false,
          ),
        ],
        devices = [
          DeviceHealth(
            id: 'device-1',
            name: 'Emergency Button',
            location: 'Living room',
            status: DeviceStatus.online,
            summary: 'Ready to trigger help instantly.',
            detailHint: 'Button tested yesterday and is working normally.',
            lastCheckIn: 'Checked in 2 minutes ago',
            batteryLabel: 'Battery healthy',
          ),
          DeviceHealth(
            id: 'device-2',
            name: 'Voice Module',
            location: 'Bedroom',
            status: DeviceStatus.needsAttention,
            summary: 'Microphone sensitivity drift detected.',
            detailHint:
                'Try a quick voice test today. If the issue continues, contact support.',
            lastCheckIn: 'Checked in 8 minutes ago',
            batteryLabel: 'Battery healthy',
          ),
          DeviceHealth(
            id: 'device-3',
            name: 'Gateway Hub',
            location: 'Utility panel',
            status: DeviceStatus.online,
            summary: 'Local communication is stable.',
            detailHint: 'No action needed right now.',
            lastCheckIn: 'Checked in just now',
            batteryLabel: 'Power connected',
          ),
        ],
        incidents = [
          EmergencyIncident(
            id: 'incident-3',
            title: 'Smoke alert in kitchen',
            category: IncidentCategory.emergency,
            kind: IncidentKind.smokeGas,
            status: IncidentStatus.resolved,
            severityLabel: 'Hard emergency',
            statusLabel: 'Resolved',
            summary: 'Evacuation guidance shown and security acknowledged.',
            createdLabel: 'Today · 8:20 AM',
            durationLabel: 'Resolved in 9 minutes',
            responseLabel: 'Security acknowledged',
            latestUpdateLabel: 'Resident marked safe. Siren silenced.',
            primaryActionLabel: 'View responders',
            guidance:
                'Move away from the hazard, get to fresh air, and wait for the all-clear.',
            responders: const [
              ResponderProgress(
                name: 'Society Security',
                role: 'Reached building',
                status: 'Acknowledged',
                timeLabel: '8:22 AM',
              ),
              ResponderProgress(
                name: 'Family Contacts',
                role: 'Confirmed by phone',
                status: 'Reached',
                timeLabel: '8:24 AM',
              ),
            ],
            updates: const [
              IncidentUpdate(
                title: 'Smoke alert detected',
                detail: 'Kitchen hazard flow started automatically.',
                timeLabel: '8:20 AM',
              ),
              IncidentUpdate(
                title: 'Security notified',
                detail: 'Desk unit received the emergency location.',
                timeLabel: '8:21 AM',
              ),
              IncidentUpdate(
                title: 'Resident confirmed safe',
                detail: 'Alert closed and contacts updated.',
                timeLabel: '8:29 AM',
              ),
            ],
          ),
          EmergencyIncident(
            id: 'incident-2',
            title: 'Voice module check issue',
            category: IncidentCategory.device,
            kind: IncidentKind.deviceCheck,
            status: IncidentStatus.resolved,
            severityLabel: 'Device issue',
            statusLabel: 'Resolved',
            summary: 'Sensitivity drift was corrected after a system test.',
            createdLabel: 'Yesterday · 7:45 PM',
            durationLabel: 'Disconnected for ~2 hours',
            responseLabel: 'Recovered automatically',
            latestUpdateLabel: 'System test completed successfully.',
            primaryActionLabel: 'Open device details',
            responders: const [],
            updates: const [
              IncidentUpdate(
                title: 'Attention needed',
                detail: 'Voice module missed one scheduled self-check.',
                timeLabel: '7:45 PM',
              ),
              IncidentUpdate(
                title: 'System test run',
                detail: 'Device passed the follow-up test and recovered.',
                timeLabel: '9:31 PM',
              ),
            ],
          ),
        ],
        _historyFilter = HistoryFilter.all;

  bool isSignedIn = false;
  ResidentAccount account;
  List<EmergencyContact> contacts;
  List<DeviceHealth> devices;
  List<EmergencyIncident> incidents;
  HistoryFilter _historyFilter;
  int _idCounter = 100;

  HistoryFilter get historyFilter => _historyFilter;
  bool get canSubmitStateChanges => !account.offlineMode;

  EmergencyIncident? get activeIncident {
    for (final incident in incidents) {
      if (incident.isActive) {
        return incident;
      }
    }
    return null;
  }

  List<EmergencyContact> get primaryContacts {
    final sorted = [...contacts]..sort((a, b) => a.priority.compareTo(b.priority));
    return sorted.take(2).toList();
  }

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
    isSignedIn = true;
    if (name.trim().isNotEmpty) {
      account = account.copyWith(name: name.trim());
    }
    notifyListeners();
  }

  void signOut() {
    isSignedIn = false;
    notifyListeners();
  }

  void setHistoryFilter(HistoryFilter value) {
    if (_historyFilter == value) {
      return;
    }
    _historyFilter = value;
    notifyListeners();
  }

  void setAccessibilityMode(bool value) {
    account = account.copyWith(accessibilityMode: value);
    notifyListeners();
  }

  void setExclamationMode(bool value) {
    account = account.copyWith(exclamationMode: value);
    notifyListeners();
  }

  void setOfflineMode(bool value) {
    account = account.copyWith(
      offlineMode: value,
      lastSyncLabel: value ? 'Last sync 12 minutes ago' : 'Synced just now',
    );
    notifyListeners();
  }

  EmergencyIncident startEmergency(IncidentKind kind) {
    final existingIncident = activeIncident;
    if (existingIncident != null) {
      return existingIncident;
    }

    final isHard = kind == IncidentKind.hard || kind == IncidentKind.smokeGas;
    final primaryContactName = primaryContacts.isEmpty
        ? 'Primary contact'
        : primaryContacts.first.name;
    final incident = EmergencyIncident(
      id: 'incident-${_idCounter++}',
      title: isHard ? 'Hard emergency active' : 'Soft emergency active',
      category: IncidentCategory.emergency,
      kind: kind,
      status: IncidentStatus.active,
      severityLabel: isHard ? 'Hard emergency' : 'Soft emergency',
      statusLabel: 'Active',
      summary: isHard
          ? 'Security, nearby contacts, and escalation actions were triggered.'
          : 'Security and priority contacts were alerted quietly.',
      createdLabel: 'Now',
      durationLabel: 'Started just now',
      responseLabel: isHard ? 'Contacts alerted' : 'Quiet alert sent',
      latestUpdateLabel:
          'Open emergency status to follow responders and next steps.',
      primaryActionLabel:
          kind == IncidentKind.smokeGas ? 'I\'m safe' : 'Acknowledge',
      guidance: kind == IncidentKind.smokeGas
          ? 'Move to fresh air and keep distance from the hazard before using the app.'
          : null,
      responders: [
        const ResponderProgress(
          name: 'Society Security',
          role: 'Desk unit notified',
          status: 'Notified',
          timeLabel: 'Just now',
        ),
        ResponderProgress(
          name: primaryContactName,
          role: 'Primary contact',
          status: 'Alerted',
          timeLabel: 'Just now',
        ),
        if (isHard)
          const ResponderProgress(
            name: 'Nearby responders',
            role: 'Escalation path',
            status: 'Preparing',
            timeLabel: 'Starts in 1 minute',
          ),
      ],
      updates: [
        IncidentUpdate(
          title: isHard ? 'Hard emergency triggered' : 'Soft emergency triggered',
          detail: isHard
              ? 'Alarm protocol is active and responders are being escalated.'
              : 'The system has started the quiet response flow.',
          timeLabel: 'Now',
        ),
        const IncidentUpdate(
          title: 'Primary contacts alerted',
          detail: 'Contacts can now acknowledge and move toward the resident.',
          timeLabel: 'Now',
        ),
      ],
    );

    incidents = [incident, ...incidents];
    notifyListeners();
    return incident;
  }

  void acknowledgeIncident(String incidentId) {
    _replaceIncident(
      incidentId,
      (incident) => incident.copyWith(
        status: IncidentStatus.acknowledged,
        statusLabel: 'Acknowledged',
        latestUpdateLabel: 'Resident acknowledged the alert. Contacts updated.',
        summary: 'The system received a safety acknowledgment from the resident.',
        primaryActionLabel: 'Mark resolved',
        updates: [
          const IncidentUpdate(
            title: 'Resident acknowledged',
            detail: 'Contacts were informed that the resident is responsive.',
            timeLabel: 'Now',
          ),
          ...incident.updates,
        ],
      ),
      canTransform: (incident) =>
          incident.status == IncidentStatus.active ||
          incident.status == IncidentStatus.escalated,
    );
  }

  void cancelIncident(String incidentId) {
    _replaceIncident(
      incidentId,
      (incident) => incident.copyWith(
        status: IncidentStatus.cancelled,
        statusLabel: 'Cancelled',
        latestUpdateLabel: 'Alert cancelled. Contacts were sent a calm closure update.',
        summary: 'The alert was stopped and the system confirmed the closure.',
        primaryActionLabel: 'Back to home',
        updates: [
          const IncidentUpdate(
            title: 'Alert cancelled',
            detail: 'Siren and escalation path were stopped.',
            timeLabel: 'Now',
          ),
          ...incident.updates,
        ],
      ),
      canTransform: (incident) =>
          incident.status == IncidentStatus.active ||
          incident.status == IncidentStatus.escalated,
    );
  }

  void resolveIncident(String incidentId) {
    _replaceIncident(
      incidentId,
      (incident) => incident.copyWith(
        status: IncidentStatus.resolved,
        statusLabel: 'Resolved',
        latestUpdateLabel: 'Resident confirmed safety. Responders were updated.',
        summary: 'The incident is now closed and all responders received the final status.',
        primaryActionLabel: 'Back to home',
        updates: [
          const IncidentUpdate(
            title: 'Incident resolved',
            detail: 'The resident was marked safe and the alert was closed.',
            timeLabel: 'Now',
          ),
          ...incident.updates,
        ],
      ),
      canTransform: (incident) =>
          incident.status == IncidentStatus.acknowledged,
    );
  }

  void runSystemTest() {
    devices = devices
        .map(
          (device) => device.copyWith(
            status: DeviceStatus.online,
            summary: 'Ready and working normally.',
            detailHint: 'The latest system test completed successfully.',
            lastCheckIn: 'Checked in just now',
          ),
        )
        .toList();
    account = account.copyWith(lastSyncLabel: 'Synced just now');
    notifyListeners();
  }

  EmergencyIncident incidentById(String id) {
    return incidents.firstWhere((incident) => incident.id == id);
  }

  DeviceHealth deviceById(String id) {
    return devices.firstWhere((device) => device.id == id);
  }

  EmergencyContact? contactById(String? id) {
    if (id == null) {
      return null;
    }
    for (final contact in contacts) {
      if (contact.id == id) {
        return contact;
      }
    }
    return null;
  }

  void saveContact(EmergencyContact contact) {
    final existingIndex = contacts.indexWhere((item) => item.id == contact.id);
    if (existingIndex == -1) {
      contacts = [...contacts, contact];
    } else {
      contacts = [...contacts]..[existingIndex] = contact;
    }

    contacts.sort((a, b) => a.priority.compareTo(b.priority));
    notifyListeners();
  }

  void _replaceIncident(
    String incidentId,
    EmergencyIncident Function(EmergencyIncident incident) transform,
    {bool Function(EmergencyIncident incident)? canTransform,}
  ) {
    incidents = incidents
        .map(
          (incident) => incident.id == incidentId &&
                  (canTransform == null || canTransform(incident))
              ? transform(incident)
              : incident,
        )
        .toList();
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
