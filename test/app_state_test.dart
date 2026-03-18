import 'package:flutter_test/flutter_test.dart';

import 'package:qat/core/app_state.dart';
import 'package:qat/models/emergency_incident.dart';

void main() {
  test('duplicate emergency trigger reuses the existing active incident', () {
    final state = AppStateController();
    final originalCount = state.incidents.length;

    final first = state.startEmergency(IncidentKind.soft);
    final second = state.startEmergency(IncidentKind.hard);

    expect(second.id, first.id);
    expect(state.incidents.length, originalCount + 1);
    expect(state.incidents.where((incident) => incident.isActive).length, 1);
  });

  test('incident transitions follow acknowledge then resolve', () {
    final state = AppStateController();
    final incident = state.startEmergency(IncidentKind.soft);

    state.resolveIncident(incident.id);
    expect(state.incidentById(incident.id).status, IncidentStatus.active);

    state.acknowledgeIncident(incident.id);
    expect(
      state.incidentById(incident.id).status,
      IncidentStatus.acknowledged,
    );

    state.resolveIncident(incident.id);
    expect(state.incidentById(incident.id).status, IncidentStatus.resolved);

    state.cancelIncident(incident.id);
    expect(state.incidentById(incident.id).status, IncidentStatus.resolved);
  });

  test('offline mode disables state-changing readiness flag', () {
    final state = AppStateController();

    expect(state.canSubmitStateChanges, isTrue);

    state.setOfflineMode(true);
    expect(state.canSubmitStateChanges, isFalse);
  });
}
