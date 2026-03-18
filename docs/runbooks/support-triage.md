# Support Triage Runbook

## Scope
- Resident-facing client support for the Flutter application in this repository
- Covers UI, navigation, offline messaging, and local emergency-state presentation
- Does not cover backend alert delivery because there is no backend implementation in this repo

## Common Cases
### 1. User sees offline banner
- Confirm whether the app shows `Offline - showing last known status`.
- Ask the user to call their primary contact if they need immediate help.
- Do not advise them to trust any unconfirmed in-app state change while offline.

### 2. User reports a false alarm
- Verify whether the app reached the emergency status screen.
- Confirm whether the incident status is `Cancelled` or still active.
- If active and the user has connectivity, guide them to `Cancel alert`.
- If offline, guide them to call their primary contact and support desk directly.

### 3. User cannot trigger help from Home
- Check whether offline mode is enabled in Settings.
- If offline mode is active, explain that the app intentionally blocks unconfirmed alert mutations and offers direct calling instead.
- If offline mode is not active, capture screenshots and device/platform details.

### 4. User reports a device warning
- Route them to Devices, then the affected device detail.
- Ask them to run the system test.
- If the device remains in `Needs attention` or `Offline`, instruct them to call support.

## Escalation Criteria
- The emergency screen shows conflicting states
- A resolved incident can still be cancelled or acknowledged
- The offline banner is missing while connectivity is absent
- Contact or incident detail screens fail to open
- Build identity or branding appears incorrect on device

## Data To Collect
- app version and platform
- screen name where the problem occurred
- screenshots
- whether the device was offline
- exact button tapped
- whether a tel/sms action opened the platform dialer or messaging app
