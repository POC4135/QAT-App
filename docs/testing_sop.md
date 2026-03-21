AI/LLM testing agents: use this file as the authoritative end-to-end testing SOP for QAT and follow it before claiming the app is verified.

# QAT Testing SOP

## Purpose
This file is the canonical testing standard for the QAT Flutter client. Use it
to decide what must be tested, which suites must pass, and what a green result
actually proves before claiming the app is verified.

## Trust Model
Green tests prove only the scenarios they cover. They do not prove all runtime
or environment behavior automatically.

The earlier failure mode in this repo was a false sense of safety from
widget-level greens without enough runtime trust. The response is a layered
testing model:
- deterministic unit tests for logic and persistence
- smoke tests for app boot and critical journeys
- regression tests for previously broken or high-risk flows
- browser-backed Chrome smoke coverage
- a web build gate to catch bundling and compile-time failures

`test/flutter_test_config.dart` is a global guardrail. It makes widget
hit-test warnings fatal so missed taps do not slip through as false greens.

## Suite Inventory

| Suite | Command | Runtime | What it proves | When it must run |
| --- | --- | --- | --- | --- |
| Unit | `bash tool/test_unit.sh` | Flutter test VM | Deterministic logic, state transitions, prefs, routing fallbacks, config parsing, theme and launch behavior | During feature work, before commit, in CI |
| Smoke | `bash tool/test_smoke.sh` | Flutter test VM + Chrome | App boot, sign-in, shell load, emergency happy path, accessibility boot sanity | Before commit, in CI, before release |
| Regression | `bash tool/test_regression.sh` | Flutter test VM | High-risk and previously broken UI flows | For any risky UI/state change, before commit, in CI |
| Trust proof | `bash tool/trust_proof.sh` | Combined | Full client verification gate | Pull requests, release candidates, CI |
| Web build | `flutter build web` | Flutter build | Compile-time and bundling integrity | In trust proof, before release |
| Android build | `flutter build apk` | Flutter build | Android packaging sanity when SDK exists | Before Android release |
| Manual release | See checklist below | Human | Visual and runtime confidence not covered by automation | Release only |

## Required Gates
### Per commit
- run the impacted suite at minimum
- if UI, navigation, or emergency flow changed, run smoke and regression
- if the change fixes a bug, add a regression test in the correct suite

### Per pull request
- `bash tool/trust_proof.sh`
- review failures before merge; do not rely on partial greens

### Per release
- `bash tool/trust_proof.sh`
- `flutter build apk` if Android SDK exists
- complete the manual release SOP

## Unit Test Standard
Put pure or mostly deterministic behavior under `test/unit/`.

Unit suite scope:
- pure logic and deterministic state
- preferences persistence
- emergency state transitions and dedupe
- router guard logic and invalid-route fallback
- remote countdown config parsing, cache, and fallback
- launch service success and failure behavior
- theme and accessibility token rules

Unit suite rules:
- keep tests independent and deterministic
- use mock preferences and fake services
- do not depend on live network or real platform integrations
- name tests by behavior, not by implementation detail

Current unit files:
- `test/unit/app_preferences_test.dart`
- `test/unit/app_state_test.dart`
- `test/unit/app_router_test.dart`
- `test/unit/app_theme_test.dart`
- `test/unit/launch_service_test.dart`
- `test/unit/emergency_flow_config_test.dart`

## Smoke Test Standard
Put critical-path boot and happy-path coverage under `test/smoke/`.

Smoke suite scope:
- boot the app
- sign in
- reach the main shell
- open emergency flow
- confirm critical screens render
- verify one happy path for normal mode and one for accessibility mode

Smoke suite rules:
- keep the suite small and stable
- cover only the minimum critical user journeys
- run the suite in both VM and Chrome-backed browser mode
- use Chrome-backed smoke to prove browser runtime boot sanity

Current smoke files:
- `test/smoke/app_boot_smoke_test.dart`
- `test/smoke/emergency_happy_path_smoke_test.dart`
- `test/smoke/accessibility_boot_smoke_test.dart`

## Regression Test Standard
Put previously broken or high-risk flows under `test/regression/`.

Regression suite scope:
- countdown auto-trigger and cancel/back handling
- accessibility-mode shell behavior
- offline fallback behavior
- device-issue navigation from home
- safe route fallbacks for missing IDs
- narrow-width and large-text resilience
- destructive-action confirmation flows

Regression suite rules:
- every shipped bug fix must add or update a regression test
- place the test in the smallest suite that expresses the risk clearly
- prefer behavior-level assertions over brittle layout-only assertions

Current regression files:
- `test/regression/emergency_choice_regression_test.dart`
- `test/regression/accessibility_regression_test.dart`
- `test/regression/home_and_devices_regression_test.dart`
- `test/regression/router_and_detail_regression_test.dart`

## Scripts and Commands
The repo testing scripts mirror the suite structure.

### Named scripts
- `tool/test_unit.sh`
- `tool/test_smoke.sh`
- `tool/test_regression.sh`
- `tool/trust_proof.sh`

### Command behavior
`tool/test_unit.sh`
- runs deterministic unit-level tests only

`tool/test_smoke.sh`
- runs the critical boot and navigation widget tests in the VM
- runs the Chrome-backed smoke subset in the browser runtime

`tool/test_regression.sh`
- runs the higher-risk widget and regression coverage

`tool/trust_proof.sh`
1. `flutter pub get`
2. `flutter analyze`
3. `bash tool/test_unit.sh`
4. `bash tool/test_smoke.sh`
5. `bash tool/test_regression.sh`
6. `flutter build web`

CI must call only the top-level trust-proof script.

## Manual Release SOP
Run this checklist before release:
1. Launch in Chrome and confirm there is no blank screen or startup exception.
2. Complete one normal-mode emergency journey.
3. Complete one accessibility-mode journey.
4. Inspect Home, Emergency, Devices, and Profile visually in both modes.
5. If Android SDK is present, run `flutter build apk` and perform one install/run sanity pass.

If a step fails, record:
- the failing step
- exact error or observed behavior
- environment used
- whether the failure is reproducible

## Failure Triage
### `flutter analyze` fails
- treat as a code-quality gate failure
- fix warnings/errors before trusting any later results

### Unit suite fails
- isolate the logic or state regression first
- do not proceed to UI-only debugging until unit truth is restored

### Chrome smoke fails
- treat as higher-severity than VM-only widget failures
- inspect browser-runtime differences, startup path, and web-specific behavior

### Web build fails
- treat as a release blocker for web
- fix compile-time, asset, or bundling issues before shipping

## How To Add Coverage For New Features
When a feature changes:
1. decide whether the risk is unit, smoke, or regression
2. add tests to the matching suite
3. add support harness helpers only when reuse is clear
4. update this SOP only if the testing standard itself changes

When a bug is fixed:
1. reproduce it
2. add a regression test first or alongside the fix
3. verify the regression test fails before the fix when feasible
4. rerun the appropriate suite and then trust proof

## Important Interface and Process Changes
- testing is a first-class repo interface, with named scripts under `tool/`
- this master SOP is the canonical contributor and AI-agent contract
- the broad widget bucket has been split into named smoke and regression suites
- CI continues to use one top-level gate, but that gate now composes explicit suites
- future bug fixes must include a regression test in the correct suite
- update this SOP only when the testing standard itself changes

## Known Limits
- this repository contains the Flutter client only
- there is no backend integration environment in this repo
- there is no real device farm in this repo
- Android build validation depends on a locally configured Android SDK
- passing client suites does not prove backend, provider, or infrastructure behavior

## Appendix: Current Critical Flows Covered
### Unit cases
- accessibility mode persists across reload
- offline and exclamation preferences persist
- cached countdown config persists
- emergency trigger dedupes active incidents
- invalid state transitions do not mutate terminal incidents
- route guard blocks signed-out access to protected routes
- missing route arguments fall back safely
- theme uses bundled Atkinson font and accessibility tokens
- remote config parsing clamps invalid values
- remote config refresh stores last-good values
- launch failures surface user-visible fallback behavior

### Smoke cases
- app boots to landing
- sign-in reaches the main shell
- normal mode exposes the expected primary nav
- accessibility mode switches the shell immediately
- emergency flow can be entered from home
- active emergency screen renders and accepts one happy-path action

### Regression cases
- hard emergency is default on emergency choice
- countdown auto-triggers selected emergency
- cancel and back stop countdown without creating an incident
- changing selection before timeout changes the resulting incident kind
- false-alarm cancel requires confirmation
- offline mode shows degraded fallback
- accessibility home removes non-primary sections
- accessibility device issue action opens devices screen
- normal home device cards render in grid form
- detail routes handle missing IDs safely
- large text on narrow width does not break the accessibility shell

## Repo Test Layout
The repo test layout mirrors the suite model:
- `test/unit/`
- `test/smoke/`
- `test/regression/`
- `test/support/` for shared pump helpers, fake services, and fixtures
- `test/flutter_test_config.dart` for global test guardrails
