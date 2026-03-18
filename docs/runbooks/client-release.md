# Client Release Runbook

## Scope
- Flutter client only
- Android, web, and Apple platform packaging that exists in this repo
- No backend or AWS deployment is covered here because those assets are not present in the repository

## Preconditions
- `flutter analyze` passes
- `flutter test` passes
- `flutter build web` passes
- Android SDK is installed before running `flutter build apk`
- Apple toolchain is installed before running iOS or macOS builds
- Release signing material is provided through Gradle properties or the Apple signing environment, not committed to the repo

## Release Steps
1. Pull the target commit and review [`FINDINGS.md`](/Users/prakhar/Documents/QAT/qat/FINDINGS.md) for any open items.
2. Run the GitHub Actions workflow in [`.github/workflows/flutter-verify.yml`](/Users/prakhar/Documents/QAT/qat/.github/workflows/flutter-verify.yml).
3. Run local verification for the target platform:
   - `flutter analyze`
   - `flutter test`
   - `flutter build web`
   - `flutter build apk` after the Android SDK and signing configuration are present
4. Confirm release signing inputs are injected securely:
   - `QAT_RELEASE_STORE_FILE`
   - `QAT_RELEASE_STORE_PASSWORD`
   - `QAT_RELEASE_KEY_ALIAS`
   - `QAT_RELEASE_KEY_PASSWORD`
5. Build the release artifact for the target store or hosting channel.
6. Smoke-test sign-in, SOS trigger, false-alarm cancel, acknowledge, resolve, and offline fallback.

## Rollback
1. Stop rollout of the bad build in the distribution channel.
2. Re-ship the last known good signed artifact.
3. Link the rollback decision to [`VERIFICATION.md`](/Users/prakhar/Documents/QAT/qat/VERIFICATION.md) and the incident record.
4. If the bug affects emergency handling, immediately route users to the safest manual fallback:
   - call primary contact
   - call support desk
   - rely on the last known status banner until the corrected build is live

## Evidence To Capture
- commit SHA
- verification command output
- store version/build number
- signing source used
- smoke-test checklist result
