# Findings

## Summary Table
| Severity | Component | Title | Status |
| --- | --- | --- | --- |
| BLOCKER | Backend | No backend or API implementation for auth, incident lifecycle, notifications, escalation, or persistence | OPEN |
| BLOCKER | AWS / Infra | No AWS IaC for IAM, encryption, networking, queues, alarms, logging, or backups | OPEN |
| HIGH | Client state | Duplicate emergency triggers could create conflicting or misleading resident state | FIXED |
| HIGH | Client resilience | Offline mode previously allowed state-changing actions that could not be confirmed | FIXED |
| MEDIUM | Packaging | Placeholder app identity and unsafe Android release defaults | FIXED |
| MEDIUM | Privacy | Personal-looking sample resident/contact data was bundled in the client | FIXED |
| MEDIUM | Quality | Critical resident flows lacked targeted regression coverage | FIXED |
| MEDIUM | Delivery | The repo had no client CI verification workflow or client runbooks | FIXED |

## F-01: No backend or API implementation for core emergency flows
- Severity: `BLOCKER`
- Component: backend
- Status: `OPEN`
- Impact:
  The repository cannot prove object-level authorization, idempotency, delivery guarantees, escalation timing, persistence, or remote responder behavior. End-to-end emergency correctness is therefore unverifiable.
- Repro:
  1. Inventory the repository root.
  2. Confirm only Flutter client/platform directories exist.
  3. Confirm there is no API, worker, notification, datastore, or scheduler code.
- File / line:
  - Repository inventory evidence: no `api/`, `server/`, `backend/`, `lambda/`, or worker paths under the repo root
  - [`README.md:1`](/Users/prakhar/Documents/QAT/qat/README.md#L1)
  - [`pubspec.yaml:1`](/Users/prakhar/Documents/QAT/qat/pubspec.yaml#L1)
- Root cause:
  This repository contains only the client application, but it was treated as though it represented the full product.
- Security exploit narrative:
  Without a server implementation, there is no enforceable authorization boundary. Any claims about IDOR prevention, rate limiting, replay protection, or audit integrity would be speculative.
- Reliability failure mode:
  Alert delivery, acknowledgement races, escalation timers, retries, and deduplication cannot be verified because the code that would implement them is missing.
- Fix plan:
  Add the real backend/API and worker code, then audit auth, authorization, idempotency, queues, persistence, and notification flows before reassessing readiness.

## F-02: No AWS infrastructure-as-code or production operations stack
- Severity: `BLOCKER`
- Component: aws_infrastructure
- Status: `OPEN`
- Impact:
  There is no source-controlled definition for IAM, KMS, networking, queues, WAF, logging, alarms, DLQs, backups, or restore procedures. Least privilege and disaster recovery cannot be established.
- Repro:
  1. List top-level directories.
  2. Confirm there is no `infra/`, `terraform/`, `cloudformation/`, or `aws/` path.
- File / line:
  - Repository inventory evidence: no infrastructure directory exists under the repo root
  - [`README.md:1`](/Users/prakhar/Documents/QAT/qat/README.md#L1)
- Root cause:
  Infrastructure and operations assets are not in the repository.
- Security exploit narrative:
  Without IaC, IAM grants, encryption policies, public exposure, and logging posture cannot be reviewed or enforced.
- Reliability failure mode:
  Queue retry safety, DLQs, alarms, backups, and restore validation are absent from source control.
- Fix plan:
  Add AWS IaC and ops definitions, then validate least privilege, encryption, network exposure, alarms, backups, restore, and rollback behavior.

## F-03: Duplicate emergency triggers could create conflicting or misleading resident state
- Severity: `HIGH`
- Component: client state
- Status: `FIXED`
- Impact:
  Repeated emergency taps could create duplicate incidents or lose correct active-history ordering, which would undermine trust in the resident-visible state trail.
- Repro before fix:
  1. Create an active emergency.
  2. Trigger another emergency before the first one closes.
  3. Observe duplicate or misleading incident state behavior.
- File / line:
  - Active-incident dedupe: [`lib/core/app_state.dart:242`](/Users/prakhar/Documents/QAT/qat/lib/core/app_state.dart#L242)
  - Reuse existing incident: [`lib/core/app_state.dart:243`](/Users/prakhar/Documents/QAT/qat/lib/core/app_state.dart#L243)
  - Preserve history ordering: [`lib/core/app_state.dart:310`](/Users/prakhar/Documents/QAT/qat/lib/core/app_state.dart#L310)
  - Regression test: [`test/app_state_test.dart:7`](/Users/prakhar/Documents/QAT/qat/test/app_state_test.dart#L7)
- Root cause:
  Client state mutation allowed repeated trigger entry without first checking for an already-active incident.
- Reliability mitigation:
  `startEmergency` now returns the existing active incident instead of creating a second one, and the regression test verifies only one active incident remains.

## F-04: Offline mode previously allowed unconfirmable state-changing actions
- Severity: `HIGH`
- Component: client resilience
- Status: `FIXED`
- Impact:
  A resident could believe an acknowledge, cancel, or resolve action succeeded while offline even though no authoritative system could confirm it.
- Repro before fix:
  1. Enable offline mode.
  2. Start or continue an emergency flow.
  3. Attempt a state-changing action.
- File / line:
  - Offline readiness gate: [`lib/core/app_state.dart:172`](/Users/prakhar/Documents/QAT/qat/lib/core/app_state.dart#L172)
  - Home degraded-state banner and fallback: [`lib/screens/home/home_screen.dart:59`](/Users/prakhar/Documents/QAT/qat/lib/screens/home/home_screen.dart#L59), [`lib/screens/home/home_screen.dart:94`](/Users/prakhar/Documents/QAT/qat/lib/screens/home/home_screen.dart#L94), [`lib/screens/home/home_screen.dart:104`](/Users/prakhar/Documents/QAT/qat/lib/screens/home/home_screen.dart#L104)
  - Emergency screen fallback behavior: [`lib/screens/emergency/active_emergency_screen.dart:51`](/Users/prakhar/Documents/QAT/qat/lib/screens/emergency/active_emergency_screen.dart#L51), [`lib/screens/emergency/active_emergency_screen.dart:65`](/Users/prakhar/Documents/QAT/qat/lib/screens/emergency/active_emergency_screen.dart#L65), [`lib/screens/emergency/active_emergency_screen.dart:176`](/Users/prakhar/Documents/QAT/qat/lib/screens/emergency/active_emergency_screen.dart#L176)
  - Regression tests: [`test/app_state_test.dart:39`](/Users/prakhar/Documents/QAT/qat/test/app_state_test.dart#L39), [`test/widget_test.dart:120`](/Users/prakhar/Documents/QAT/qat/test/widget_test.dart#L120)
- Root cause:
  The client UI treated offline state as informational instead of authoritative for emergency action gating.
- Reliability mitigation:
  The app now blocks unconfirmable mutations, shows a degraded-state banner, and routes the resident to the safest available fallback: calling the primary contact directly.

## F-05: Placeholder app identity and unsafe Android release defaults
- Severity: `MEDIUM`
- Component: packaging
- Status: `FIXED`
- Impact:
  Shipping with placeholder identifiers or using debug-style release defaults can break store identity, signing hygiene, and trust in published artifacts.
- Repro before fix:
  1. Review Android and Apple platform metadata.
  2. Observe default sample identifiers and release configuration patterns.
- File / line:
  - Android package and release signing properties: [`android/app/build.gradle.kts:1`](/Users/prakhar/Documents/QAT/qat/android/app/build.gradle.kts#L1), [`android/app/build.gradle.kts:22`](/Users/prakhar/Documents/QAT/qat/android/app/build.gradle.kts#L22), [`android/app/build.gradle.kts:45`](/Users/prakhar/Documents/QAT/qat/android/app/build.gradle.kts#L45), [`android/app/build.gradle.kts:56`](/Users/prakhar/Documents/QAT/qat/android/app/build.gradle.kts#L56)
  - Android app label: [`android/app/src/main/AndroidManifest.xml:2`](/Users/prakhar/Documents/QAT/qat/android/app/src/main/AndroidManifest.xml#L2)
  - Android main activity namespace: [`android/app/src/main/kotlin/com/quickaidtech/qat/MainActivity.kt:1`](/Users/prakhar/Documents/QAT/qat/android/app/src/main/kotlin/com/quickaidtech/qat/MainActivity.kt#L1)
  - iOS display name: [`ios/Runner/Info.plist:9`](/Users/prakhar/Documents/QAT/qat/ios/Runner/Info.plist#L9)
  - iOS bundle identifier references: `ios/Runner.xcodeproj/project.pbxproj:375`, `:554`, `:576`
  - macOS bundle identity: [`macos/Runner/Configs/AppInfo.xcconfig:8`](/Users/prakhar/Documents/QAT/qat/macos/Runner/Configs/AppInfo.xcconfig#L8)
  - Web app identity: [`web/manifest.json:2`](/Users/prakhar/Documents/QAT/qat/web/manifest.json#L2)
- Root cause:
  The project still carried sample Flutter metadata and default release assumptions.
- Mitigation:
  The app now uses `com.quickaidtech.qat`, `QuickAid`, and an explicit release-signing configuration path rather than silently relying on unsafe defaults.

## F-06: Personal-looking sample resident and contact data bundled in the client
- Severity: `MEDIUM`
- Component: privacy
- Status: `FIXED`
- Impact:
  Shipping realistic personal names in the bundle creates avoidable privacy and trust concerns, even if the data is only demo content.
- Repro before fix:
  1. Inspect bundled sample state in the app controller.
  2. Observe person-like names in resident and contact records.
- File / line:
  - Sanitized resident and contact placeholders: [`lib/core/app_state.dart:10`](/Users/prakhar/Documents/QAT/qat/lib/core/app_state.dart#L10), [`lib/core/app_state.dart:21`](/Users/prakhar/Documents/QAT/qat/lib/core/app_state.dart#L21), [`lib/core/app_state.dart:31`](/Users/prakhar/Documents/QAT/qat/lib/core/app_state.dart#L31)
- Root cause:
  The original mock state used personal-looking identity values instead of clearly synthetic data.
- Mitigation:
  Demo content now uses clearly generic placeholders such as `Sample Resident`, `Primary Contact`, and `Primary Doctor`.

## F-07: Critical resident flows lacked targeted regression coverage
- Severity: `MEDIUM`
- Component: quality
- Status: `FIXED`
- Impact:
  Without targeted tests, emergency regressions could reach users silently.
- Repro before fix:
  1. Inspect the prior test suite.
  2. Observe missing coverage for duplicate-trigger handling, cancel flow, resolve flow, and offline degraded mode.
- File / line:
  - State tests: [`test/app_state_test.dart:7`](/Users/prakhar/Documents/QAT/qat/test/app_state_test.dart#L7)
  - Widget tests: [`test/widget_test.dart:30`](/Users/prakhar/Documents/QAT/qat/test/widget_test.dart#L30), [`test/widget_test.dart:51`](/Users/prakhar/Documents/QAT/qat/test/widget_test.dart#L51), [`test/widget_test.dart:76`](/Users/prakhar/Documents/QAT/qat/test/widget_test.dart#L76), [`test/widget_test.dart:120`](/Users/prakhar/Documents/QAT/qat/test/widget_test.dart#L120)
- Root cause:
  The test suite covered basic rendering but not the most failure-sensitive emergency paths.
- Mitigation:
  New unit and widget tests now pin the client-side resident flows that were hardened in this audit.

## F-08: The repo had no client CI verification workflow or client runbooks
- Severity: `MEDIUM`
- Component: delivery
- Status: `FIXED`
- Impact:
  Verification depended entirely on manual local execution, and there was no written release or support procedure for the client.
- Repro before fix:
  1. Inspect repository root for `.github/workflows` and runbook files.
  2. Observe that neither existed.
- File / line:
  - CI workflow: [`.github/workflows/flutter-verify.yml:1`](/Users/prakhar/Documents/QAT/qat/.github/workflows/flutter-verify.yml#L1)
  - Release runbook: [`docs/runbooks/client-release.md:1`](/Users/prakhar/Documents/QAT/qat/docs/runbooks/client-release.md#L1)
  - Support runbook: [`docs/runbooks/support-triage.md:1`](/Users/prakhar/Documents/QAT/qat/docs/runbooks/support-triage.md#L1)
- Root cause:
  The repository lacked operational scaffolding for client verification and response.
- Mitigation:
  This audit adds a GitHub Actions verification workflow and two client-focused runbooks.
