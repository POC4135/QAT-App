# Architecture

## Purpose

The QAT app is a client-side resident emergency companion built in Flutter. It
is structured as a local-state application with placeholder authentication,
seeded incident/device/contact data, runtime web countdown configuration, and a
strong focus on accessibility and emergency-first interaction design.

## Runtime Architecture

### App startup

`lib/main.dart` is the composition root.

Startup sequence:
1. Flutter bindings are initialized.
2. `AppPreferencesStore.load()` reads local persisted preferences from
   `SharedPreferences`.
3. `QuickAidRoot` creates:
   - `AppStateController`
   - `EmergencyFlowConfigController`
   - `LaunchService`
4. `QuickAidRoot` listens for:
   - app-state changes
   - platform reduce-motion changes
   - app lifecycle resume events
5. The app builds `MaterialApp` with:
   - the current theme
   - route generation via `AppRouter`
   - app-wide inherited scopes

### App-wide scopes

The app currently exposes three important app-wide scopes:
- `AppStateScope`
  - wraps `AppStateController`
  - is the main source of session state, preferences, contacts, devices, and
    incidents
- `EmergencyFlowConfigScope`
  - exposes the emergency countdown controller
  - provides the current countdown value and refresh behavior
- `LaunchServiceScope`
  - centralizes external launches such as phone, SMS, email, and website links

## State Architecture

`AppStateController` is the main application controller. Internally it composes:
- `AppSessionState`
  - local sign-in state only
- `UiPreferencesState`
  - accessibility mode
  - exclamation mode
  - offline mode
  - last sync label
- `EmergencyStore`
  - seeded contacts
  - seeded devices
  - seeded incident history
  - emergency lifecycle transitions

This means the current app is not server-backed. All incident, contact, and
device behaviors are local and deterministic inside the client.

## Routing and Navigation

### Named routes

The app uses named routes defined in `lib/core/app_routes.dart`.

Primary route set:
- `/`
- `/home`
- `/emergency/choose`
- `/emergency/active`
- `/history`
- `/history/detail`
- `/devices`
- `/devices/detail`
- `/profile`
- `/profile/contacts`
- `/profile/contacts/edit`
- `/profile/settings`
- `/profile/help`

### Route guard behavior

All signed-in routes are guarded locally. Only these routes are public:
- landing
- help

If a protected route is opened while signed out, `AppRouter` redirects to the
landing screen.

### Shell behavior

`AppShell` manages bottom navigation:
- normal mode:
  - `Home`
  - `History`
  - `Devices`
  - `Profile`
- accessibility mode:
  - `Home`
  - `Other`

In accessibility mode, secondary destinations remain available as routes, but
the bottom shell only surfaces the two primary destinations.

## Theme and Accessibility Architecture

The visual system is defined in `lib/core/app_theme.dart`.

Key concepts:
- `QatPalette`
  - semantic colors for normal and accessibility modes
- `QatUiConfig`
  - spacing, sizing, radius, icon sizes, hero button sizes, and reduced-motion
    behavior
- `buildQatTheme(...)`
  - builds the full `ThemeData`
  - switches to the bundled `AtkinsonHyperlegible` font
  - disables route animations when reduced motion is active

Accessibility mode affects:
- theme colors and borders
- typography scale and weight
- spacing and control sizes
- shell layout
- screen density
- disclosure depth
- motion and transitions

## Emergency Flow Architecture

The emergency flow is split into two screens:
- `EmergencyChoiceScreen`
- `ActiveEmergencyScreen`

Emergency choice behavior:
- hard emergency is selected by default
- the countdown starts automatically
- the current selection auto-triggers on timeout
- cancel and back stop the countdown and return home

Emergency active behavior:
- shows current incident status
- shows system actions already taken
- exposes the current primary action
- uses confirmation for destructive actions such as false-alarm cancel or
  stopping the alarm

The actual incident transition logic lives in `EmergencyStore`, not in the
screen widgets.

## Runtime Config Architecture

Emergency countdown configuration is owned by
`EmergencyFlowConfigController`.

Config precedence:
1. explicit `QAT_REMOTE_CONFIG_URL` if provided and valid
2. same-origin web config file at `web/config/emergency_flow.json`
3. cached last-good value in `SharedPreferences`
4. built-in default of `10`

Important runtime behavior:
- config refresh happens on startup and app resume
- the emergency-choice screen also triggers a background refresh
- an already-open emergency-choice screen uses a stable snapshot of the
  countdown; it does not change mid-countdown

## External Integrations

Current direct package integrations:
- `shared_preferences`
  - local UI preference persistence
  - cached emergency countdown config
- `http`
  - emergency countdown config fetch
- `url_launcher`
  - call, SMS, email, and website actions

All external launches go through `LaunchService`, which gives the UI a safe
fallback dialog when launching fails.

## Current Architectural Limits

- no backend or API integration
- no remote persistence
- no real auth/session validation
- no notification provider integration
- no real device heartbeat ingestion
- sample data and display strings are still embedded in the client

The app is therefore architected as a strong client-side prototype rather than
an end-to-end production system.
