# Engineering Guide

## Purpose

This guide explains how to extend or modify the QAT client without fighting the
current architecture.

## General Engineering Rules

- keep Home focused on emergency-first information
- keep accessibility mode behavior intentional, not incidental
- prefer existing theme tokens over hardcoded spacing and sizes
- use the shared launch service for external actions
- add or update tests in the correct suite for every behavior change
- update docs when the product behavior or architecture materially changes

## How To Add or Change UI

### Screen changes

When changing a screen:
1. identify whether the behavior differs by accessibility mode
2. use `context.qatUi` and `context.qatPalette` rather than hardcoded values
3. keep primary actions visually dominant
4. move secondary detail behind a disclosure card when appropriate

### Reusable UI

If a pattern is used across more than one screen, prefer a widget in
`lib/widgets/`.

Examples already centralized:
- status banners
- disclosure cards
- emergency action card
- countdown action button
- confirmation banner
- accessibility mode settings card

## State Change Pattern

The current app expects widgets to:
- read app state via `AppStateScope.of(context)`
- call methods on `AppStateController`
- avoid storing parallel sources of truth in widgets

Examples:
- `setAccessibilityMode(...)`
- `setOfflineMode(...)`
- `startEmergency(...)`
- `acknowledgeIncident(...)`
- `cancelIncident(...)`
- `resolveIncident(...)`
- `saveContact(...)`

If a change requires new persistent state:
1. add it to `AppPreferencesStore` if it must persist
2. thread it through `AppStateController`
3. expose it in the relevant screen
4. add unit tests

## Routing Pattern

Named routes live in `lib/core/app_routes.dart`.

When adding a screen:
1. define a route constant
2. add the route to `AppRouter.onGenerateRoute`
3. guard it if sign-in is required
4. provide safe fallback behavior when route arguments can be missing

Do not assume route arguments are always valid. The codebase already uses safe
fallback screens for missing incidents and devices; follow that pattern.

## Accessibility Mode Expectations

Accessibility mode is not just a theme toggle. It is an app-wide behavioral
mode.

Expected differences:
- larger text and controls
- reduced motion
- stronger contrast
- fewer visible navigation destinations
- less dense default views
- more progressive disclosure

When changing a screen, verify:
- the normal mode behavior still makes sense
- accessibility mode still keeps primary tasks obvious
- large text and narrow widths do not break layout

## Emergency Flow Expectations

The emergency path is the highest-sensitivity user flow in the repo.

When changing it:
- preserve hard-emergency default selection unless intentionally redesigning
- avoid duplicate trigger paths
- keep destructive actions behind confirmation
- keep countdown behavior stable during a single screen visit
- update both unit and regression coverage

## External Actions

Do not call `url_launcher` directly from feature screens.

Use `LaunchService` helpers:
- `launchPhoneCall(...)`
- `launchSmsMessage(...)`
- `launchEmailMessage(...)`
- `launchWebsiteLink(...)`

Why:
- centralized failure handling
- consistent fallback dialog behavior
- unit-testable interface

## Theming and Visual Tokens

Use:
- `context.qatPalette`
- `context.qatUi`

Do not:
- hardcode large sets of colors
- hardcode inconsistent control sizes
- bypass the bundled font system

If theme tokens need expansion:
1. add them to `QatPalette` or `QatUiConfig`
2. wire them through `buildQatTheme`
3. add theme tests if the change is behaviorally important

## Tests and Documentation

Before finishing a code change:
- run the appropriate suite
- run `bash tool/trust_proof.sh` for non-trivial work
- update `docs/testing_sop.md` only if the testing standard changed
- update architecture/config/flow docs if the product behavior changed

## Current Architectural Limits To Respect

- no backend exists in this repo
- auth is placeholder only
- incidents, devices, and contacts are seeded locally
- runtime config is limited to countdown configuration
- support and release docs apply to the client repo only
