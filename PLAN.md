# Production Readiness Audit Plan

## Repo Map
- Flutter client code: [`lib/`](/Users/prakhar/Documents/QAT/qat/lib)
- Platform targets: [`android/`](/Users/prakhar/Documents/QAT/qat/android), [`ios/`](/Users/prakhar/Documents/QAT/qat/ios), [`web/`](/Users/prakhar/Documents/QAT/qat/web), [`macos/`](/Users/prakhar/Documents/QAT/qat/macos), [`linux/`](/Users/prakhar/Documents/QAT/qat/linux), [`windows/`](/Users/prakhar/Documents/QAT/qat/windows)
- Tests: [`test/`](/Users/prakhar/Documents/QAT/qat/test)
- Client CI added in this audit: [`.github/workflows/flutter-verify.yml`](/Users/prakhar/Documents/QAT/qat/.github/workflows/flutter-verify.yml)
- Client runbooks added in this audit: [`docs/runbooks/client-release.md`](/Users/prakhar/Documents/QAT/qat/docs/runbooks/client-release.md), [`docs/runbooks/support-triage.md`](/Users/prakhar/Documents/QAT/qat/docs/runbooks/support-triage.md)

### Scope Gaps Found In Repo Inventory
- No backend service code or API contracts
- No AWS infrastructure-as-code
- No queue, notification, persistence, or escalation scheduler implementation
- No server-side auth, authorization, idempotency, or audit log implementation

### Build And Test Entry Points
- `flutter analyze`
- `flutter test`
- `flutter build web`
- `flutter build apk` after the Android SDK is configured
- GitHub Actions workflow: `flutter-verify`

## Threat Model
### Trust Boundaries
- Resident client UI
- Future auth/API boundary
- Future notification and escalation boundary
- Future datastore and audit boundary
- Future device heartbeat ingestion boundary

### Assets
- resident name and home label
- emergency contact list and priority order
- incident history and current incident state
- device health summaries
- offline/degraded status messaging

### Attacker Goals
- trigger or cancel incidents incorrectly
- read or tamper with incident/contact data
- exploit placeholder client state as if it were authoritative
- recover secrets from the repository or client bundles
- abuse emergency paths through replay or duplicate actions

### Top Risks For Current Repo
- misleading emergency state transitions in client-only logic
- duplicate incident creation from repeated emergency triggers
- offline users being allowed to perform unconfirmable state changes
- shipping placeholder bundle identifiers or unsafe release signing defaults
- false production assumptions caused by the total absence of backend and AWS assets

## Test Strategy
### Static And Configuration Checks
- repo inventory and missing-component scan
- regex-based secret scan
- dependency inventory with `flutter pub deps --style=compact`
- platform packaging review for Android, iOS, macOS, and web metadata

### Client Verification
- `flutter analyze`
- unit tests for state-machine behavior
- widget tests for sign-in, trigger, cancel, acknowledge, resolve, and offline fallback
- `flutter build web`
- `flutter build apk` if the local Android SDK exists

### Blocked End-To-End Verification
The following cannot be executed from this repo because the server-side system is absent:
- caregiver notification delivery
- acknowledge or claim from a remote responder
- auto escalation after timeout
- retry, deduplication, and out-of-order queue handling
- device heartbeat ingestion
- object-level authorization at API boundaries
- AWS IAM, KMS, WAF, DLQ, CloudTrail, and alarm validation

## Production Gates
- zero open `BLOCKER`
- zero open `HIGH`
- `flutter analyze` passes
- `flutter test` passes
- `flutter build web` passes
- Android packaging verification passes once the Android SDK exists
- no secrets detected in repo scan
- client CI workflow exists and enforces analyze, test, and web build
- client release and support runbooks exist
- backend, infrastructure, and operability assets exist before any `GO` decision

## Execution Checklist
1. Inventory the repository and note missing subsystems.
2. Review client state, offline handling, packaging, and sample data.
3. Fix client correctness and privacy issues with regression tests.
4. Add minimum client CI and runbook coverage.
5. Re-run analyze, tests, build, dependency inventory, and secret scan.
6. Document findings, verification, patches, and readiness decision.
