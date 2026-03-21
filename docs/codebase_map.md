# Codebase Map

## Purpose

This file maps the repository to responsibilities so a new engineer or AI agent
can find the right place to make changes quickly.

## Top-Level Structure

- `lib/`
  - application source
- `test/`
  - unit, smoke, regression, and support test code
- `docs/`
  - documentation package
- `tool/`
  - test orchestration scripts
- `web/`
  - web host assets and runtime config file
- `android/`, `ios/`, `macos/`, `linux/`, `windows/`
  - platform packaging and host entrypoints
- `assets/`
  - bundled fonts
- `config/`
  - example configuration files only, not direct runtime sources

## Application Source Map

### `lib/main.dart`
Use this file when you need to change:
- app startup
- app-wide scope creation
- initial theme setup
- root dependency injection

### `lib/core/`
Core runtime infrastructure.

Key files:
- `app_state.dart`
  - main app controller and inherited scope
- `app_routes.dart`
  - named routes and route guard behavior
- `app_shell.dart`
  - signed-in shell navigation
- `app_theme.dart`
  - design tokens, theme, and reduced-motion transitions
- `app_preferences.dart`
  - `SharedPreferences` wrapper
- `emergency_store.dart`
  - local seeded state and incident/device/contact mutations
- `emergency_flow_config.dart`
  - countdown config model, repository, controller, and fetch rules
- `launch_service.dart`
  - safe external action launching
- `presentation.dart`
  - shared labels and status/tone helpers

### `lib/models/`
Domain models.

Files:
- `resident_account.dart`
- `emergency_contact.dart`
- `device_health.dart`
- `emergency_incident.dart`

### `lib/screens/`
Feature screens grouped by functional area.

Subdirectories:
- `auth/`
  - landing and placeholder sign-in
- `home/`
  - primary dashboard
- `emergency/`
  - emergency choice and active emergency
- `history/`
  - history list and detail
- `devices/`
  - device list and detail
- `profile/`
  - profile, contacts, settings, help
- `other/`
  - accessibility-mode secondary hub

### `lib/widgets/`
Reusable presentation components.

Use this directory for:
- status banners
- emergency action card
- countdown button
- disclosure cards
- confirmation banner/dialog
- device and history cards
- accessibility settings section

## Test Structure

The test layout mirrors the testing SOP.

- `test/unit/`
  - deterministic logic and state
- `test/smoke/`
  - critical boot and happy-path journeys
- `test/regression/`
  - high-risk and previously broken flows
- `test/support/`
  - shared test harness helpers
- `test/flutter_test_config.dart`
  - global test guardrail for fatal hit-test warnings

## Tooling Structure

- `tool/test_unit.sh`
- `tool/test_smoke.sh`
- `tool/test_regression.sh`
- `tool/trust_proof.sh`

These scripts are the executable layer behind the documented testing SOP.

## Documentation Structure

- `docs/README.md`
  - documentation hub
- `docs/architecture.md`
  - runtime architecture
- `docs/state_and_data.md`
  - domain/state details
- `docs/user_flows.md`
  - user journey behavior
- `docs/configuration.md`
  - runtime/build config
- `docs/engineering_guide.md`
  - implementation conventions
- `docs/ai_agent_guide.md`
  - AI-specific onboarding guidance
- `docs/testing_sop.md`
  - canonical testing standard

## Platform and Packaging Files

### Android
- `android/app/build.gradle.kts`
  - app id
  - SDK levels
  - release signing property contract
- `android/app/src/main/AndroidManifest.xml`
  - display name
  - launcher activity

### Web
- `web/index.html`
  - web shell page
- `web/manifest.json`
  - app metadata and PWA manifest
- `web/config/emergency_flow.json`
  - default runtime emergency countdown config for web

### Apple platforms
- `ios/Runner/Info.plist`
  - display metadata and iOS host settings
- `macos/Runner/Configs/AppInfo.xcconfig`
  - macOS app name and bundle identifier

### Pub and assets
- `pubspec.yaml`
  - dependencies
  - version
  - bundled font assets

## Where To Make Common Changes

### Change the home screen
- `lib/screens/home/home_screen.dart`

### Change emergency countdown behavior
- `lib/screens/emergency/emergency_choice_screen.dart`
- `lib/core/emergency_flow_config.dart`
- `web/config/emergency_flow.json`

### Change accessibility mode behavior
- `lib/core/app_theme.dart`
- `lib/core/app_shell.dart`
- screens that branch on `context.qatUi.accessibilityMode`

### Add a new screen
1. add the screen under the appropriate `lib/screens/` subdirectory
2. register or route to it in `lib/core/app_routes.dart`
3. add or update tests in the correct suite
4. update docs if the behavior materially changes

### Add a new persistent preference
1. add getters/setters in `lib/core/app_preferences.dart`
2. thread it into `AppStateController`
3. expose it in the relevant screen
4. add unit coverage

### Add a new external action
Use `lib/core/launch_service.dart` rather than calling `url_launcher`
directly from a widget.
