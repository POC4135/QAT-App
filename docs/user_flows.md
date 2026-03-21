# User Flows

## Purpose

This file describes how the app behaves from the user’s perspective. It is the
best reference for understanding the expected screen-to-screen journey in both
normal mode and accessibility mode.

## Primary Navigation Model

### Normal mode
- `Home`
- `History`
- `Devices`
- `Profile`

### Accessibility mode
- `Home`
- `Other`

In accessibility mode, `Other` is the grouped entry point for:
- contacts
- history
- devices
- profile
- settings
- help
- sign out

## Landing and Sign-In

Entry screen:
- `LandingScreen`

Behavior:
- shows username and password inputs
- accepts any credentials in this build
- signs the resident into the local session
- routes to `/home`

The help screen is reachable from landing without signing in.

## Home Flow

### Shared behavior
Home always prioritizes:
1. emergency action
2. current status
3. secondary surfaces

### Normal mode Home
Home includes:
- greeting and home label
- offline banner when offline mode is active
- primary emergency action card
- system status banner
- primary contact shortcuts
- two-device highlights grid
- active incident preview when an incident exists

Primary CTA behavior:
- if there is an active incident:
  - open emergency status
- if offline mode is on:
  - call primary contact
- otherwise:
  - open emergency choice

### Accessibility mode Home
Accessibility Home is intentionally reduced.

It includes:
- greeting
- offline banner when relevant
- primary emergency action
- system or incident status banner
- active incident preview only when relevant

It does **not** include:
- primary contact section
- device highlight section
- extra secondary disclosure content

If device warnings exist in accessibility mode, the status banner can expose an
`Open devices` action.

## Emergency Choice Flow

Route:
- `/emergency/choose`

Behavior:
- hard emergency is selected by default
- hard emergency appears first
- countdown starts immediately
- cancel and all back actions stop the countdown and return home
- if an active incident already exists, the screen redirects to active emergency

User choices:
- `Hard emergency` / `Urgent help`
- `Soft emergency` / `Quiet help`

Countdown behavior:
- the continue button shows the remaining seconds
- the current selection auto-triggers when the countdown reaches zero
- the current screen uses a stable countdown snapshot

## Active Emergency Flow

Route:
- `/emergency/active`

Behavior:
- shows incident status
- shows what the system already did
- shows guidance for hazard cases when present
- provides one primary next action
- uses confirmation before destructive cancellation/stopping
- moves detailed responder/timeline content behind a disclosure card

Primary action behavior:
- if offline mode prevents confirmed state change:
  - call primary contact instead
- if incident is acknowledged:
  - `Mark resolved`
- if incident is active:
  - `Acknowledge`
- if incident is a hazard:
  - primary label becomes `I am safe`

Secondary action behavior:
- `Cancel alert` or `Stop alarm`
- confirmation dialog required

Closed incident behavior:
- shows calm confirmation state
- offers `Back to Home`

## History Flow

Routes:
- `/history`
- `/history/detail`

Behavior:
- list is filterable by:
  - all
  - emergencies
  - devices
- detail screen shows:
  - status banner
  - outcome summary
  - responders
  - timeline

If a history item cannot be found:
- a safe fallback screen is shown
- user can return to history

## Device Flow

Routes:
- `/devices`
- `/devices/detail`

Behavior:
- device list starts with a health summary banner
- `Run system test` is always available
- each device opens a detail screen

Device detail includes:
- status banner
- what-to-do guidance
- run system test action
- call support action
- expandable details for battery, location, and check-in

If a device cannot be found:
- a safe fallback screen is shown

## Profile and Contacts Flow

Routes:
- `/profile`
- `/profile/contacts`
- `/profile/contacts/edit`
- `/profile/settings`
- `/profile/help`

Profile behavior:
- shows account summary
- surfaces emergency contacts summary
- exposes accessibility and safety settings
- links to settings, help, and sign-out

Contacts behavior:
- shows contacts in priority order
- highlights primary contact
- provides direct call action
- supports add/edit contact
- accessibility mode collapses secondary actions behind disclosure

Edit contact behavior:
- local-only form
- writes back into `EmergencyStore`
- no backend sync

## Settings Flow

Settings exposes:
- accessibility mode
- offline mode
- exclamation mode
- sync state label

Accessibility mode:
- immediately updates the whole app
- persists across restarts
- changes both visual style and shell behavior

## Help Flow

Help provides:
- email support
- call support
- website link
- small FAQ disclosures

Help is intentionally secondary and does not compete with the emergency flow.

## Sign-Out Flow

Sign-out:
- clears the signed-in session only
- does not clear local persisted preferences
- returns the user to the landing screen

## Important Behavior Notes

- offline mode is a local simulation of degraded behavior
- placeholder auth means the app is not performing real authentication
- most app data is seeded and local
- runtime countdown config changes apply to future emergency-choice visits, not
  to an already-open countdown screen
