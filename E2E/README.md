# End-To-End Coverage Notes

## What Is Covered In This Repo Today
Client-only widget and state tests exercise:
- sign-in to the resident shell
- SOS trigger from Home
- false-alarm cancel
- acknowledge then resolve
- offline degraded-state fallback
- history and profile drill-in navigation

See:
- [`test/app_state_test.dart`](/Users/prakhar/Documents/QAT/qat/test/app_state_test.dart)
- [`test/widget_test.dart`](/Users/prakhar/Documents/QAT/qat/test/widget_test.dart)

## What Is Not Covered Because The System Is Missing
The following required end-to-end cases remain blocked until backend and infrastructure code exists:
- caregiver receives alert
- remote acknowledgement or claim
- no-response escalation after timeout
- notification retry and fallback channel behavior
- duplicate trigger deduplication at API and queue layers
- cancel vs escalation race across workers
- API authorization denial
- device heartbeat ingestion and health alert generation

## Requirements For Real E2E Coverage
1. Add backend services, notification integrations, persistence, and escalation workers.
2. Add infrastructure-as-code for queues, DLQs, alarms, and logging.
3. Stand up deterministic integration environments with mocked providers and controllable clocks.
4. Add CI-friendly end-to-end suites that validate the full incident lifecycle.
