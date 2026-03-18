enum IncidentCategory { emergency, device }

enum IncidentKind { soft, hard, smokeGas, deviceCheck }

enum IncidentStatus { active, acknowledged, escalated, cancelled, resolved }

enum HistoryFilter { all, emergencies, devices }

class ResponderProgress {
  const ResponderProgress({
    required this.name,
    required this.role,
    required this.status,
    required this.timeLabel,
  });

  final String name;
  final String role;
  final String status;
  final String timeLabel;
}

class IncidentUpdate {
  const IncidentUpdate({
    required this.title,
    required this.detail,
    required this.timeLabel,
  });

  final String title;
  final String detail;
  final String timeLabel;
}

class EmergencyIncident {
  const EmergencyIncident({
    required this.id,
    required this.title,
    required this.category,
    required this.kind,
    required this.status,
    required this.severityLabel,
    required this.statusLabel,
    required this.summary,
    required this.createdLabel,
    required this.durationLabel,
    required this.responseLabel,
    required this.latestUpdateLabel,
    required this.primaryActionLabel,
    required this.responders,
    required this.updates,
    this.guidance,
  });

  final String id;
  final String title;
  final IncidentCategory category;
  final IncidentKind kind;
  final IncidentStatus status;
  final String severityLabel;
  final String statusLabel;
  final String summary;
  final String createdLabel;
  final String durationLabel;
  final String responseLabel;
  final String latestUpdateLabel;
  final String primaryActionLabel;
  final List<ResponderProgress> responders;
  final List<IncidentUpdate> updates;
  final String? guidance;

  bool get isActive =>
      status == IncidentStatus.active ||
      status == IncidentStatus.acknowledged ||
      status == IncidentStatus.escalated;

  bool get isEmergency => category == IncidentCategory.emergency;

  bool get isHazard => kind == IncidentKind.smokeGas;

  EmergencyIncident copyWith({
    String? id,
    String? title,
    IncidentCategory? category,
    IncidentKind? kind,
    IncidentStatus? status,
    String? severityLabel,
    String? statusLabel,
    String? summary,
    String? createdLabel,
    String? durationLabel,
    String? responseLabel,
    String? latestUpdateLabel,
    String? primaryActionLabel,
    List<ResponderProgress>? responders,
    List<IncidentUpdate>? updates,
    String? guidance,
  }) {
    return EmergencyIncident(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      severityLabel: severityLabel ?? this.severityLabel,
      statusLabel: statusLabel ?? this.statusLabel,
      summary: summary ?? this.summary,
      createdLabel: createdLabel ?? this.createdLabel,
      durationLabel: durationLabel ?? this.durationLabel,
      responseLabel: responseLabel ?? this.responseLabel,
      latestUpdateLabel: latestUpdateLabel ?? this.latestUpdateLabel,
      primaryActionLabel: primaryActionLabel ?? this.primaryActionLabel,
      responders: responders ?? this.responders,
      updates: updates ?? this.updates,
      guidance: guidance ?? this.guidance,
    );
  }
}
