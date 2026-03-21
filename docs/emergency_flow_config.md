# Emergency Flow Remote Config

QuickAid can pull the emergency countdown from a runtime JSON file so admins can
change the auto-trigger timing without rebuilding the app.

## JSON contract

```json
{
  "emergencyAutoTriggerSeconds": 10
}
```

- Accepted range: `3` to `30`
- Invalid values are clamped or ignored
- If the fetch fails, the app falls back to:
  1. the last cached good value
  2. the built-in default of `10`

## Runtime source of truth

- [`config/emergency_flow.sample.json`](/Users/prakhar/Documents/QAT/qat/config/emergency_flow.sample.json)
  is only an example file for reference.
- The web app reads
  [`web/config/emergency_flow.json`](/Users/prakhar/Documents/QAT/qat/web/config/emergency_flow.json)
  by default when no `QAT_REMOTE_CONFIG_URL` is provided.
- If `QAT_REMOTE_CONFIG_URL` is set, that HTTPS URL takes precedence over the
  bundled web path.

## App configuration

Pass the hosted config URL at runtime:

```bash
flutter run \
  --dart-define=QAT_REMOTE_CONFIG_URL=https://example.com/emergency_flow.json
```

## Update timing

- The app refreshes the config on startup and when the app resumes.
- The emergency-choice screen also triggers a background refresh.
- An already-running countdown does **not** change mid-screen.
- New server values apply on the next emergency-choice screen visit.
- The app adds a cache-busting query parameter on fetch so web updates are not
  hidden behind a stale browser cache.
