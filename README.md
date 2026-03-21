# QuickAid QAT App

QuickAid QAT is a Flutter-based resident emergency companion application. The
current repository contains the client application, platform packaging, local
state model, runtime configuration support, testing stack, and documentation
for the client-only system.

This app is designed around a resident emergency workflow:
- sign in quickly
- see current safety and device status
- start a soft or hard emergency
- follow responders and next steps
- review history, devices, contacts, settings, and support

## Current Scope

This repository contains:
- the Flutter client application
- platform packaging for web, Android, iOS, macOS, Linux, and Windows
- local seeded data and placeholder authentication
- accessibility mode support
- runtime emergency countdown configuration for the web client
- client-only testing, release, and support documentation

This repository does **not** contain:
- backend services
- notification infrastructure
- AWS IaC
- real authentication
- remote persistence for incidents, contacts, or devices

Treat the current app as a client-focused product prototype with strong internal
structure and testing, but not a full end-to-end production system.

## Quick Start

### Prerequisites
- Flutter `3.41.4`
- Dart SDK compatible with `sdk: ^3.11.1`
- Chrome for web development
- Android SDK for APK builds
- Apple toolchain for iOS/macOS builds

### Common commands
- `flutter pub get`
- `flutter run -d chrome`
- `flutter analyze`
- `bash tool/trust_proof.sh`
- `flutter build web`
- `flutter build apk` after the Android SDK is configured

## Documentation Hub

Start here if you are new to the repo:
- [`docs/README.md`](/Users/prakhar/Documents/QAT/qat/docs/README.md)

Core documentation:
- [`docs/architecture.md`](/Users/prakhar/Documents/QAT/qat/docs/architecture.md)
- [`docs/codebase_map.md`](/Users/prakhar/Documents/QAT/qat/docs/codebase_map.md)
- [`docs/state_and_data.md`](/Users/prakhar/Documents/QAT/qat/docs/state_and_data.md)
- [`docs/user_flows.md`](/Users/prakhar/Documents/QAT/qat/docs/user_flows.md)
- [`docs/configuration.md`](/Users/prakhar/Documents/QAT/qat/docs/configuration.md)
- [`docs/engineering_guide.md`](/Users/prakhar/Documents/QAT/qat/docs/engineering_guide.md)
- [`docs/ai_agent_guide.md`](/Users/prakhar/Documents/QAT/qat/docs/ai_agent_guide.md)

Testing and operations:
- [`docs/testing_sop.md`](/Users/prakhar/Documents/QAT/qat/docs/testing_sop.md)
- [`docs/testing_trust_proof.md`](/Users/prakhar/Documents/QAT/qat/docs/testing_trust_proof.md)
- [`docs/emergency_flow_config.md`](/Users/prakhar/Documents/QAT/qat/docs/emergency_flow_config.md)
- [`docs/runbooks/client-release.md`](/Users/prakhar/Documents/QAT/qat/docs/runbooks/client-release.md)
- [`docs/runbooks/support-triage.md`](/Users/prakhar/Documents/QAT/qat/docs/runbooks/support-triage.md)

Audit and readiness artifacts:
- [`REPO_MANIFEST.md`](/Users/prakhar/Documents/QAT/qat/REPO_MANIFEST.md)
- [`PLAN.md`](/Users/prakhar/Documents/QAT/qat/PLAN.md)
- [`FINDINGS.md`](/Users/prakhar/Documents/QAT/qat/FINDINGS.md)
- [`VERIFICATION.md`](/Users/prakhar/Documents/QAT/qat/VERIFICATION.md)
- [`PRODUCTION_READINESS_REPORT.md`](/Users/prakhar/Documents/QAT/qat/PRODUCTION_READINESS_REPORT.md)
- [`PATCHES/README.md`](/Users/prakhar/Documents/QAT/qat/PATCHES/README.md)
- [`E2E/README.md`](/Users/prakhar/Documents/QAT/qat/E2E/README.md)

## High-Level Architecture

At runtime, the app is built around these layers:
- `QuickAidRoot` in `lib/main.dart` loads persisted preferences, builds app-wide
  scopes, and creates the `MaterialApp`
- `AppStateController` in `lib/core/app_state.dart` composes session state, UI
  preferences, and the seeded emergency store
- `EmergencyFlowConfigController` in `lib/core/emergency_flow_config.dart`
  supplies the emergency countdown value
- `AppRouter` in `lib/core/app_routes.dart` owns named routes and local route
  guards
- `AppShell` in `lib/core/app_shell.dart` provides the signed-in navigation
  shell
- `QatPalette` and `QatUiConfig` in `lib/core/app_theme.dart` define the app’s
  visual system for normal and accessibility modes

## Product Behavior Summary

### Normal mode
- bottom navigation shows `Home`, `History`, `Devices`, and `Profile`
- Home includes the primary emergency CTA, status summary, contact shortcuts,
  and device highlights

### Accessibility mode
- bottom navigation collapses to `Home` and `Other`
- Home shows only primary safety content
- `Other` collects contacts, history, devices, profile, settings, help, and
  sign-out
- theme tokens switch to larger controls, stronger contrast, and reduced motion

### Emergency flow
- Home opens `EmergencyChoiceScreen`
- hard emergency is selected by default
- a countdown starts immediately
- the current selection auto-triggers if the countdown completes
- active incident handling happens on `ActiveEmergencyScreen`

## Runtime Configuration Summary

Emergency countdown configuration can come from:
- `QAT_REMOTE_CONFIG_URL` when supplied
- `web/config/emergency_flow.json` on web when no remote URL is supplied
- cached last-good config in `SharedPreferences`
- built-in default of `10` seconds as the final fallback

Important:
- [`config/emergency_flow.sample.json`](/Users/prakhar/Documents/QAT/qat/config/emergency_flow.sample.json)
  is only an example file and is not read directly by the running app

## Testing Summary

The required client verification entrypoint is:
- `bash tool/trust_proof.sh`

That top-level gate runs:
- dependency resolution
- static analysis
- unit tests
- smoke tests
- regression tests
- browser-backed smoke coverage
- web build verification

See [`docs/testing_sop.md`](/Users/prakhar/Documents/QAT/qat/docs/testing_sop.md)
for the full testing contract.
