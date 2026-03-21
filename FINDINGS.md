# Findings

## Summary Table
| Severity | Component | Title | Status |
| --- | --- | --- | --- |
| BLOCKER | Repo manifest | Required backend/API repo not supplied to the audit | OPEN |
| BLOCKER | Repo manifest | Required async worker/escalation repo not supplied to the audit | OPEN |
| BLOCKER | Repo manifest | Required AWS/IaC repo not supplied to the audit | OPEN |
| BLOCKER | Repo manifest | Required CI/CD repo not supplied to the audit | OPEN |
| BLOCKER | Repo manifest | Required system runbook/docs repo not supplied to the audit | OPEN |
| HIGH | Client state | Duplicate emergency triggers could create conflicting or misleading resident state | FIXED |
| HIGH | Client resilience | Offline mode previously allowed state-changing actions that could not be confirmed | FIXED |
| MEDIUM | Packaging | Placeholder app identity and unsafe Android release defaults | FIXED |
| MEDIUM | Privacy | Personal-looking sample resident/contact data was bundled in the client | FIXED |
| MEDIUM | Quality | Critical resident flows lacked targeted regression coverage | FIXED |
| MEDIUM | Delivery | The repo had no client CI verification workflow or client runbooks | FIXED |

## F-01: Required backend/API repo not supplied to the audit
- Severity: `BLOCKER`
- Component: repo manifest
- Status: `OPEN`
- Impact:
  The audit cannot inspect or verify object-level authorization, idempotency, delivery guarantees, persistence, or remote responder behavior because the backend source repo is unavailable.
- Repro:
  1. Inspect [`REPO_MANIFEST.md`](/Users/prakhar/Documents/QAT/qat/REPO_MANIFEST.md).
  2. Confirm the backend/API entry is `Not supplied`.
  3. Search local QAT-adjacent directories and confirm no backend repo is available.
- File / line:
  - [`REPO_MANIFEST.md:1`](/Users/prakhar/Documents/QAT/qat/REPO_MANIFEST.md#L1)
  - [`PLAN.md:1`](/Users/prakhar/Documents/QAT/qat/PLAN.md#L1)
- Root cause:
  The multi-repo system inventory was never supplied to the audit environment.
- Security exploit narrative:
  Without the backend repo, there is no way to verify authorization checks, input validation, rate limits, audit integrity, or replay protection.
- Reliability failure mode:
  Incident lifecycle correctness, dedupe, and persistence behavior cannot be verified.
- Fix plan:
  Supply the backend/API repo, branch, environments, and secrets/config model in [`REPO_MANIFEST.md`](/Users/prakhar/Documents/QAT/qat/REPO_MANIFEST.md), then audit and harden it before reassessing readiness.

## F-02: Required async worker/escalation repo not supplied to the audit
- Severity: `BLOCKER`
- Component: repo manifest
- Status: `OPEN`
- Impact:
  The audit cannot inspect escalation fan-out, retry policy, out-of-order handling, notification fallback, or timed escalation logic.
- Repro:
  1. Inspect [`REPO_MANIFEST.md`](/Users/prakhar/Documents/QAT/qat/REPO_MANIFEST.md).
  2. Confirm the async worker/escalation entry is `Not supplied`.
- File / line:
  - [`REPO_MANIFEST.md:1`](/Users/prakhar/Documents/QAT/qat/REPO_MANIFEST.md#L1)
- Root cause:
  The system repo inventory does not include the worker implementation.
- Security exploit narrative:
  Notification worker behavior, actor identity propagation, and event-level auditability cannot be verified.
- Reliability failure mode:
  Timed escalation, retries, duplicate suppression, and cancellation races remain unverifiable.
- Fix plan:
  Supply the worker/escalation repo and its test/deploy surfaces, then audit duplicate handling, retries, timing, and DLQ behavior.

## F-03: Required AWS/IaC repo not supplied to the audit
- Severity: `BLOCKER`
- Component: repo manifest
- Status: `OPEN`
- Impact:
  IAM, KMS, networking, queues, alarms, WAF, backups, and restore posture cannot be inspected or validated.
- Repro:
  1. Inspect [`REPO_MANIFEST.md`](/Users/prakhar/Documents/QAT/qat/REPO_MANIFEST.md).
  2. Confirm the AWS/IaC entry is `Not supplied`.
- File / line:
  - [`REPO_MANIFEST.md:1`](/Users/prakhar/Documents/QAT/qat/REPO_MANIFEST.md#L1)
  - [`PLAN.md:11`](/Users/prakhar/Documents/QAT/qat/PLAN.md#L11)
- Root cause:
  The infrastructure source repo was not provided to the audit.
- Security exploit narrative:
  Least privilege, encryption, public exposure, and WAF posture cannot be proven without source-controlled IaC.
- Reliability failure mode:
  DLQs, alarms, backups, restore validation, and rollback-safe deployment defaults cannot be verified.
- Fix plan:
  Supply the AWS/IaC repo, environments, and policy validation tooling, then complete the infrastructure audit.

## F-04: Required CI/CD repo not supplied to the audit
- Severity: `BLOCKER`
- Component: repo manifest
- Status: `OPEN`
- Impact:
  End-to-end gated verification, rollout policy, rollback policy, and security scanning enforcement cannot be proven across the full system.
- Repro:
  1. Inspect [`REPO_MANIFEST.md`](/Users/prakhar/Documents/QAT/qat/REPO_MANIFEST.md).
  2. Confirm the CI/CD entry is `Not supplied`.
- File / line:
  - [`REPO_MANIFEST.md:1`](/Users/prakhar/Documents/QAT/qat/REPO_MANIFEST.md#L1)
  - [`.github/workflows/flutter-verify.yml:1`](/Users/prakhar/Documents/QAT/qat/.github/workflows/flutter-verify.yml#L1)
- Root cause:
  Only a client-scoped verification workflow exists in this repo.
- Security exploit narrative:
  There is no evidence that backend, infra, or deployment gates block insecure changes.
- Reliability failure mode:
  Full-system verification and staged rollout controls remain unverified.
- Fix plan:
  Supply the CI/CD repo or pipeline definitions that own backend/infra deployment and policy gates.

## F-05: Required system runbook/docs repo not supplied to the audit
- Severity: `BLOCKER`
- Component: repo manifest
- Status: `OPEN`
- Impact:
  On-call response, alert delivery outage handling, backup/restore, and rollback procedures cannot be validated for the full system.
- Repro:
  1. Inspect [`REPO_MANIFEST.md`](/Users/prakhar/Documents/QAT/qat/REPO_MANIFEST.md).
  2. Confirm the ops/runbooks entry is `Not supplied`.
- File / line:
  - [`REPO_MANIFEST.md:1`](/Users/prakhar/Documents/QAT/qat/REPO_MANIFEST.md#L1)
  - [`docs/runbooks/client-release.md:1`](/Users/prakhar/Documents/QAT/qat/docs/runbooks/client-release.md#L1)
  - [`docs/runbooks/support-triage.md:1`](/Users/prakhar/Documents/QAT/qat/docs/runbooks/support-triage.md#L1)
- Root cause:
  Only client-scoped runbooks exist in the available repo.
- Security exploit narrative:
  Incident response expectations and accountability for backend or infrastructure failures are undefined in source control.
- Reliability failure mode:
  Restoration, rollback, and outage-response playbooks for the full stack remain absent.
- Fix plan:
  Supply the system runbook/docs repo and validate it against the production readiness checklist.

## F-06: Duplicate emergency triggers could create conflicting or misleading resident state
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

## F-07: Offline mode previously allowed unconfirmable state-changing actions
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

## F-08: Placeholder app identity and unsafe Android release defaults
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

## F-09: Personal-looking sample resident and contact data bundled in the client
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

## F-10: Critical resident flows lacked targeted regression coverage
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

## F-11: The repo had no client CI verification workflow or client runbooks
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
