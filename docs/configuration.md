# Configuration and Build Inputs

## Purpose

This document describes the runtime inputs, persisted preferences, build
configuration, and platform packaging details that affect how the QAT client
behaves.

## Flutter and Package Configuration

Primary package metadata lives in `pubspec.yaml`.

Important package facts:
- package name: `qat`
- app description: `Resident emergency companion for QuickAid Tech.`
- version: `1.0.0+1`
- SDK constraint: `^3.11.1`

Primary runtime dependencies:
- `http`
- `shared_preferences`
- `url_launcher`

Bundled font:
- `AtkinsonHyperlegible`

## Local Preferences

Persisted via `SharedPreferences` in `AppPreferencesStore`.

Stored values:
- accessibility mode
- exclamation mode
- offline mode
- cached emergency countdown seconds
- cached countdown fetch timestamp

These values are local to the device/browser profile and are loaded at app
startup.

## Emergency Countdown Configuration

### Source precedence

The emergency countdown value resolves in this order:
1. `QAT_REMOTE_CONFIG_URL` if provided and valid
2. same-origin `web/config/emergency_flow.json` on web
3. cached last-good value
4. built-in default of `10`

### Live file paths

Use these files correctly:
- [`web/config/emergency_flow.json`](/Users/prakhar/Documents/QAT/qat/web/config/emergency_flow.json)
  - live web runtime source when no remote URL is configured
- [`config/emergency_flow.sample.json`](/Users/prakhar/Documents/QAT/qat/config/emergency_flow.sample.json)
  - example/reference only

### Remote override

Provide a remote URL using:

```bash
flutter run \
  --dart-define=QAT_REMOTE_CONFIG_URL=https://example.com/emergency_flow.json
```

Rules:
- only HTTPS URLs are accepted
- remote URL takes precedence over the local web config file
- the app adds a cache-busting query parameter on fetch

### Countdown constraints

- minimum: `3`
- maximum: `30`
- default: `10`

## Build and Release Inputs

### Android

Key file:
- `android/app/build.gradle.kts`

Important values:
- namespace: `com.quickaidtech.qat`
- applicationId: `com.quickaidtech.qat`
- Java/Kotlin target: `17`

Release signing expects these Gradle properties:
- `QAT_RELEASE_STORE_FILE`
- `QAT_RELEASE_STORE_PASSWORD`
- `QAT_RELEASE_KEY_ALIAS`
- `QAT_RELEASE_KEY_PASSWORD`

Behavior:
- release signing is used only when all required properties are present
- the build does not intentionally fall back to debug signing for production

### Android manifest

Key file:
- `android/app/src/main/AndroidManifest.xml`

Important values:
- launcher label: `QuickAid`
- Flutter embedding v2

### Web

Key files:
- `web/index.html`
- `web/manifest.json`
- `web/config/emergency_flow.json`

Important notes:
- `manifest.json` still uses Flutter defaults for some visual metadata such as
  `background_color` and `theme_color`
- web runtime config lives under `web/config/`

### iOS

Key file:
- `ios/Runner/Info.plist`

Important values:
- display name: `QuickAid`
- bundle display metadata comes from Flutter version/build values

### macOS

Key file:
- `macos/Runner/Configs/AppInfo.xcconfig`

Important values:
- product name: `QuickAid`
- bundle identifier: `com.quickaidtech.qat`

## Development and Run Commands

Common commands:
- `flutter pub get`
- `flutter run -d chrome`
- `flutter analyze`
- `bash tool/trust_proof.sh`
- `flutter build web`
- `flutter build apk`

### Toolchain notes

- Chrome is required for local web runs and browser-backed smoke tests
- Android SDK is required for APK builds
- Apple tooling is required for iOS/macOS packaging

## Operational Caveats

- changing `config/emergency_flow.sample.json` does not change the running app
- changing `web/config/emergency_flow.json` affects the web runtime source
- already-open emergency countdown screens keep their current snapshot
- local browser/device caches can preserve prior preferences and cached config

## Related Docs

- [`emergency_flow_config.md`](/Users/prakhar/Documents/QAT/qat/docs/emergency_flow_config.md)
- [`testing_sop.md`](/Users/prakhar/Documents/QAT/qat/docs/testing_sop.md)
- [`runbooks/client-release.md`](/Users/prakhar/Documents/QAT/qat/docs/runbooks/client-release.md)
