# Production Readiness Audit Plan

## Audit Mode
- This repository is the client/audit hub for a multi-repo system review.
- The authoritative cross-repo inventory is tracked in [`REPO_MANIFEST.md`](/Users/prakhar/Documents/QAT/qat/REPO_MANIFEST.md).
- Current audit reality: only the client repo is available locally; backend, workers, AWS/IaC, CI/CD, and system ops docs are not supplied.

## Repo Map
- Flutter client code: [`lib/`](/Users/prakhar/Documents/QAT/qat/lib)
- Platform targets: [`android/`](/Users/prakhar/Documents/QAT/qat/android), [`ios/`](/Users/prakhar/Documents/QAT/qat/ios), [`web/`](/Users/prakhar/Documents/QAT/qat/web), [`macos/`](/Users/prakhar/Documents/QAT/qat/macos), [`linux/`](/Users/prakhar/Documents/QAT/qat/linux), [`windows/`](/Users/prakhar/Documents/QAT/qat/windows)
- Tests: [`test/`](/Users/prakhar/Documents/QAT/qat/test)
- Client CI added in this audit: [`.github/workflows/flutter-verify.yml`](/Users/prakhar/Documents/QAT/qat/.github/workflows/flutter-verify.yml)
- Client runbooks added in this audit: [`docs/runbooks/client-release.md`](/Users/prakhar/Documents/QAT/qat/docs/runbooks/client-release.md), [`docs/runbooks/support-triage.md`](/Users/prakhar/Documents/QAT/qat/docs/runbooks/support-triage.md)

### Cross-Repo Manifest
- Client/mobile-web:
  - repo: `QAT-App`
  - remote: `https://github.com/POC4135/QAT-App`
  - branch: `main`
  - local path: `/Users/prakhar/Documents/QAT/qat`
- Backend/API:
  - repo: not supplied
  - status: `BLOCKER`
- Async workers/escalation:
  - repo: not supplied
  - status: `BLOCKER`
- AWS/IaC:
  - repo: not supplied
  - status: `BLOCKER`
- CI/CD definitions:
  - repo: not supplied
  - status: `BLOCKER`
- Ops/runbooks/support docs:
  - repo: not supplied
  - status: `BLOCKER`

### Scope Gaps Found In Repo Inventory
- No backend/API repo supplied for auth, incident lifecycle, or persistence
- No worker/escalation repo supplied for fan-out, retries, or timing logic
- No AWS infrastructure-as-code repo supplied
- No system-level CI/CD repo supplied
- No system-level runbook/docs repo supplied
- Only the client repo is available for direct inspection and remediation in this environment

### Build And Test Entry Points
- `flutter analyze`
- `flutter test`
- `flutter build web`
- `flutter build apk` after the Android SDK is configured
- GitHub Actions workflow: `flutter-verify`

## Threat Model
### Trust Boundaries
- Resident client UI
- Backend/API boundary
- Worker/queue and notification boundary
- Datastore and audit boundary
- Device heartbeat ingestion boundary
- AWS infrastructure and deploy boundary

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
- false production assumptions caused by missing backend, worker, AWS, CI/CD, and ops repos

## Test Strategy
### Static And Configuration Checks
- repo inventory and missing-component scan
- cross-repo manifest completeness check
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
The following cannot be executed until the missing system repos are supplied:
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
- all required repos are present in [`REPO_MANIFEST.md`](/Users/prakhar/Documents/QAT/qat/REPO_MANIFEST.md)
- `flutter analyze` passes
- `flutter test` passes
- `flutter build web` passes
- Android packaging verification passes once the Android SDK exists
- no secrets detected in repo scan
- client CI workflow exists and enforces analyze, test, and web build
- client release and support runbooks exist
- backend, worker, infrastructure, CI/CD, and operability assets exist before any `GO` decision

## Execution Checklist
1. Lock the multi-repo inventory in [`REPO_MANIFEST.md`](/Users/prakhar/Documents/QAT/qat/REPO_MANIFEST.md).
2. Open `BLOCKER` findings for every missing source repo or deploy environment.
3. Review the client repo and retain client-side hardening as baseline.
4. Pull in backend, worker, AWS/IaC, CI/CD, and ops-doc repos before any further end-to-end claims.
5. Run discovery-only review across every supplied repo and document findings before fixing.
6. Fix all `BLOCKER` and `HIGH` issues with regression coverage.
7. Re-run client, backend, infra, and E2E verification.
8. Publish the final `GO` or `NO-GO` decision.
