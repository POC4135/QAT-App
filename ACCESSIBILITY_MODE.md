# Accessibility Mode

Accessibility Mode is a real app-wide presentation mode for older adults and low-vision users. When it is on, the app immediately rebuilds with larger controls, stronger contrast, simpler layouts, and reduced motion.

## Core Rules

- High-contrast light palette with darker borders and text
- Larger typography, spacing, icons, and touch targets
- Reduced visible choices on each screen
- No non-essential motion
- Plain-language copy for emergency flows
- One clear way to turn the mode off from Profile

## Persistence

- The setting is stored locally with `shared_preferences`
- It is read before `runApp`, so the landing screen also reflects the saved mode
- The mode updates immediately because the app root now listens to app-state changes

## Theme And Token Differences

- `QatPalette.normal` vs `QatPalette.accessibility` controls colors and contrast
- `QatUiConfig.normal` vs `QatUiConfig.accessibility` controls spacing, button height, icon size, hero button size, and card radius
- Accessibility Mode also forces `reducedMotion`

## Motion Rules

- Route transitions use a no-animation page transition builder when reduced motion is active
- Critical confirmations do not rely on snackbars in Accessibility Mode
- Detail sections use static disclosure cards instead of animated expansion tiles

## Screen Changes

- `Landing`
  - Larger input fields and button sizing
  - Shorter sign-in copy
  - Accessible mode is visible immediately on restart

- `Home`
  - SOS remains the largest centered control
  - Status stays directly below SOS
  - Secondary content moves behind a single `More details` disclosure
  - Primary contact calling remains one tap away

- `Emergency Choice`
  - Copy changes to `Quiet help` and `Urgent help`
  - Hazard warning uses simpler evacuation-first language
  - One clear continue action remains at the bottom

- `Emergency In Progress`
  - One dominant primary action and one visible secondary action
  - Responder list and timeline move behind `Details`
  - Accessibility Mode avoids snackbars for critical state changes
  - Hazard guidance stays high on the screen

- `Contacts`
  - Each row promotes `Call` first
  - Editing and messaging move behind `More actions`
  - Add contact remains a full-width primary button

- `History`
  - Dense explanatory copy is removed in Accessibility Mode
  - Incident details use a simplified summary plus one `Details` disclosure

- `Devices`
  - Device health summary stays at the top
  - `Run system test` is shown as a simple full-width action in Accessibility Mode
  - Battery and metadata move behind `More details`

- `Profile`
  - Accessibility section moves to the top when the mode is on
  - A large `Turn Off Accessibility Mode` control is always above the fold

- `Settings`
  - Accessibility toggle stays visible first
  - Less-important controls move into one `More settings` disclosure in Accessibility Mode

- `Help`
  - Support actions stay large and obvious
  - FAQs use simple disclosure cards instead of long scrolling text

- `Edit Contact`
  - Accessibility Mode adds a short plain-language instruction card
  - Form fields inherit larger spacing and larger controls from the global theme

## Before / After Notes

- `Landing`
  - Before: standard sign-in card with normal sizing
  - After: larger inputs, clearer copy, accessibility-aware launch state

- `Home`
  - Before: primary content plus secondary sections always visible
  - After: emergency action first, status second, secondary detail collapsed

- `Emergency Choice`
  - Before: more product-style emergency terminology
  - After: simpler language and faster recognition under stress

- `Emergency In Progress`
  - Before: more visible detail and snackbar-based confirmations
  - After: one-action focus, calmer confirmations, details hidden until requested

- `Profile`
  - Before: accessibility controls were present but visually secondary
  - After: accessibility controls become the first card and the off-control is obvious

## Remaining Limitations

- The setting persists locally only; there is no cross-device account sync in this repo
- System font scaling is supported by layout and larger tokens, but there is no separate backend-stored accessibility profile
- Native haptics and sound confirmations are still out of scope for this client-only build
