import '../models/device_health.dart';
import '../models/emergency_incident.dart';
import '../widgets/status_banner.dart';

String incidentKindLabel(
  IncidentKind kind, {
  required bool accessibilityMode,
}) {
  switch (kind) {
    case IncidentKind.soft:
      return accessibilityMode ? 'Quiet help' : 'Soft emergency';
    case IncidentKind.hard:
    case IncidentKind.smokeGas:
      return accessibilityMode ? 'Urgent help' : 'Hard emergency';
    case IncidentKind.deviceCheck:
      return 'Device issue';
  }
}

String incidentStatusLabel(IncidentStatus status) {
  switch (status) {
    case IncidentStatus.active:
      return 'Active';
    case IncidentStatus.acknowledged:
      return 'Acknowledged';
    case IncidentStatus.escalated:
      return 'Escalated';
    case IncidentStatus.cancelled:
      return 'Cancelled';
    case IncidentStatus.resolved:
      return 'Resolved';
  }
}

String incidentHeadline(
  EmergencyIncident incident, {
  required bool accessibilityMode,
}) {
  if (incident.category == IncidentCategory.device) {
    return incident.title;
  }

  final kind = incidentKindLabel(
    incident.kind,
    accessibilityMode: accessibilityMode,
  );
  final status = incidentStatusLabel(incident.status).toLowerCase();
  return incident.isActive ? '$kind active' : '$kind $status';
}

StatusTone incidentTone(EmergencyIncident incident) {
  switch (incident.status) {
    case IncidentStatus.active:
    case IncidentStatus.escalated:
      return StatusTone.emergency;
    case IncidentStatus.cancelled:
      return StatusTone.warning;
    case IncidentStatus.acknowledged:
      return StatusTone.info;
    case IncidentStatus.resolved:
      return StatusTone.ok;
  }
}

String deviceStatusLabel(DeviceStatus status) {
  switch (status) {
    case DeviceStatus.online:
      return 'Online';
    case DeviceStatus.needsAttention:
      return 'Needs attention';
    case DeviceStatus.offline:
      return 'Offline';
  }
}

StatusTone deviceTone(DeviceStatus status) {
  switch (status) {
    case DeviceStatus.online:
      return StatusTone.ok;
    case DeviceStatus.needsAttention:
      return StatusTone.warning;
    case DeviceStatus.offline:
      return StatusTone.emergency;
  }
}
