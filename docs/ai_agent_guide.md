AI/LLM agents: this file is your onboarding entrypoint after the root README.

# AI Agent Guide

## Goal

Use this guide to build reliable context before changing the QAT client. It is
written specifically for coding agents so they do not make incorrect
assumptions about what exists in the repo.

## Required Reading Order

Read these before making substantial changes:
1. [`../README.md`](/Users/prakhar/Documents/QAT/qat/README.md)
2. [`architecture.md`](/Users/prakhar/Documents/QAT/qat/docs/architecture.md)
3. [`state_and_data.md`](/Users/prakhar/Documents/QAT/qat/docs/state_and_data.md)
4. [`user_flows.md`](/Users/prakhar/Documents/QAT/qat/docs/user_flows.md)
5. [`configuration.md`](/Users/prakhar/Documents/QAT/qat/docs/configuration.md)
6. [`testing_sop.md`](/Users/prakhar/Documents/QAT/qat/docs/testing_sop.md)

Use [`codebase_map.md`](/Users/prakhar/Documents/QAT/qat/docs/codebase_map.md)
to find files quickly.

## Non-Negotiable Repo Truths

- this repo is client-only
- there is no backend or AWS infrastructure here
- sign-in is placeholder only
- contacts, devices, and incidents are locally seeded
- accessibility mode is a true app-wide behavior mode
- the emergency countdown is runtime-configurable
- `config/emergency_flow.sample.json` is not the live runtime config source

## Source of Truth Rules

When docs and code conflict:
- behavior code wins
- update docs after verifying the code path

Primary source-of-truth files by topic:
- startup: `lib/main.dart`
- app state: `lib/core/app_state.dart`
- routing: `lib/core/app_routes.dart`
- shell navigation: `lib/core/app_shell.dart`
- theming/accessibility: `lib/core/app_theme.dart`
- emergency countdown config: `lib/core/emergency_flow_config.dart`
- emergency transitions: `lib/core/emergency_store.dart`
- runtime web config: `web/config/emergency_flow.json`
- testing contract: `docs/testing_sop.md`

## Change Strategy

### If you are changing UI
- check both normal and accessibility modes
- keep Home emergency-first
- preserve accessibility mode’s two-tab shell
- avoid hardcoded sizes when theme tokens exist

### If you are changing emergency behavior
- inspect both `EmergencyChoiceScreen` and `ActiveEmergencyScreen`
- inspect `EmergencyStore` for transition rules
- preserve cancel/back safety behavior unless intentionally redesigning it
- add regression coverage

### If you are changing config behavior
- update both code and docs
- verify source precedence
- remember cached values can affect runtime behavior

### If you are changing routes
- use named routes
- guard signed-in surfaces
- provide safe fallback screens for invalid IDs or arguments

## Test Expectations

Before claiming the app is verified:
- run the suite required by `docs/testing_sop.md`
- for significant changes, run `bash tool/trust_proof.sh`

Current test layers:
- `test/unit/`
- `test/smoke/`
- `test/regression/`

Do not claim trust from a partial green unless the SOP says that partial suite
is sufficient for the change.

## Common Pitfalls

- editing the sample config file instead of the live runtime config file
- forgetting that accessibility mode changes shell navigation, not only styling
- adding direct `url_launcher` usage instead of going through `LaunchService`
- adding UI behavior without adding or moving the right tests
- assuming backend-driven behavior exists in this repo

## Preferred Workflow

1. read the relevant docs
2. inspect the current implementation
3. identify which flows and modes are affected
4. implement the change
5. add or update tests in the correct suite
6. run the required verification
7. update docs when behavior changed
