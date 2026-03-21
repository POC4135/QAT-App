# State and Data

## Purpose

This document explains the app’s in-memory state model, persisted preferences,
seeded domain data, and the rules that drive incident/device/contact behavior.

## State Ownership

The app’s main state owner is `AppStateController`.

It composes three concerns:
- session state
- UI preferences
- emergency domain store

This is important because screens do not own the real application state. They
read from `AppStateScope` and call methods on `AppStateController`.

## Session State

`AppSessionState` models the local sign-in session.

Current behavior:
- sign-in is placeholder only
- any username/password is accepted
- `signIn()` sets `isSignedIn = true`
- `signOut()` sets `isSignedIn = false`
- resident name updates from the username if provided

There is no backend token, no real identity provider, and no server-side
session validation in this repo.

## UI Preferences

`UiPreferencesState` models user-facing display preferences.

Current preferences:
- `accessibilityMode`
- `exclamationMode`
- `offlineMode`
- `lastSyncLabel`

### Persistence

Persistence is handled by `AppPreferencesStore` via `SharedPreferences`.

Persisted keys:
- `accessibility_mode`
- `exclamation_mode`
- `offline_mode`
- `cached_emergency_auto_trigger_seconds`
- `cached_emergency_config_fetched_at_ms`

These values are restored on startup in `main.dart`.

## Domain Models

### `ResidentAccount`
Represents the resident-facing account summary shown to the UI.

Fields:
- resident name
- home label
- sync label
- accessibility mode
- exclamation mode
- offline mode

### `EmergencyContact`
Represents a contact in the emergency chain.

Fields:
- `id`
- `name`
- `role`
- `phone`
- `relationship`
- `priority`
- `isPrimary`
- `supportsMessaging`

### `DeviceHealth`
Represents a monitored device.

Fields:
- `id`
- `name`
- `location`
- `status`
- `summary`
- `detailHint`
- `lastCheckIn`
- `batteryLabel`

Device status enum:
- `online`
- `needsAttention`
- `offline`

### `EmergencyIncident`
Represents either:
- an emergency incident
- a device-related history item

Key fields:
- `id`
- `title`
- `category`
- `kind`
- `status`
- summary/display labels
- responder list
- update timeline
- optional guidance text

Important enums:
- `IncidentCategory`
  - `emergency`
  - `device`
- `IncidentKind`
  - `soft`
  - `hard`
  - `smokeGas`
  - `deviceCheck`
- `IncidentStatus`
  - `active`
  - `acknowledged`
  - `escalated`
  - `cancelled`
  - `resolved`

## Seeded Data Model

The app uses `EmergencyStore.seeded()` as the current source of contacts,
devices, and history data.

Seeded objects include:
- three emergency contacts
- three devices
- two historical incidents

This seeded store is currently the source of truth for the app’s domain data.
There is no server synchronization in this repo.

## Emergency Store Behavior

`EmergencyStore` owns the local domain rules for:
- reading contacts/devices/incidents
- creating a new emergency incident
- acknowledging an incident
- cancelling an incident
- resolving an incident
- running a device system test
- saving a contact

### Active incident rule

`startEmergency()` first checks for an existing active incident.

If one exists:
- it returns the existing active incident
- it does not create a duplicate incident

This is the current local dedupe behavior.

### Current transition rules

Allowed transitions:
- `active` -> `acknowledged`
- `active` -> `cancelled`
- `acknowledged` -> `resolved`
- `escalated` -> `acknowledged`
- `escalated` -> `cancelled`

Blocked transitions:
- resolving directly from `active`
- cancelling after `resolved`
- cancelling after `cancelled`

The store enforces these transition constraints before mutating an incident.

### System test behavior

`runSystemTest()` resets all devices to:
- `online`
- success summary
- fresh last check-in

This is a deterministic local simulation rather than a real device diagnostic.

## Presentation Helpers

`lib/core/presentation.dart` centralizes shared labels and tones:
- incident kind label
- incident status label
- incident headline
- incident tone
- device status label
- device tone

Use these helpers when building shared copy or status UI so terminology stays
consistent across screens.

## Remote Countdown Config State

`EmergencyFlowConfigController` holds the emergency countdown config.

It exposes:
- current config
- countdown seconds
- load status
- last error
- refresh behavior

The controller uses:
- a repository to fetch config
- `SharedPreferences` to cache the last good value

This state is intentionally separate from `AppStateController`.

## Known Data Limits

- many seeded model fields still carry display-oriented strings
- there is no serialization layer for contacts, devices, or incidents
- there is no backend identity or authorization model
- there is no server clock or remote event ordering
- state is reset to seeded data on fresh app launch except for persisted
  preferences and cached config values
