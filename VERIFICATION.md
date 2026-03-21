# Verification

## Commands Executed
| Command | Result | Notes |
| --- | --- | --- |
| `flutter analyze` | PASS | `No issues found! (ran in 1.9s)` |
| `flutter test` | PASS | `00:04 +9: All tests passed!` |
| `flutter build web` | PASS | `Built build/web` |
| `flutter build apk` | FAIL | Local environment missing Android SDK |
| `flutter pub deps --style=compact` | PASS | Dependency inventory captured |
| secret scan with `rg` | PASS | No secret-pattern hits found |
| repo inventory (`find . -maxdepth 2 -type d`) | PASS | Confirms client-only repo shape and missing backend / AWS assets |
| local repo discovery (`find /Users/prakhar/Documents -maxdepth 3 -type d`) | PASS | Confirms no separate backend, worker, AWS/IaC, CI/CD, or ops repos are available locally |

## Key Output Snippets
### `flutter analyze`
```text
No issues found! (ran in 1.9s)
```

### `flutter test`
```text
00:04 +9: All tests passed!
```

### `flutter build web`
```text
Wasm dry run succeeded.
Compiling lib/main.dart for the Web... 31.6s
Built build/web
```

### `flutter build apk`
```text
[!] No Android SDK found. Try setting the ANDROID_HOME environment variable.
```

### Secret Scan
Command used:
```text
rg -n --glob '!build/**' --glob '!pubspec.lock' --glob '!android/.gradle/**' --glob '!**/*.png' "AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_\\-]{35}|-----BEGIN (RSA|EC|DSA|OPENSSH|PRIVATE) KEY-----|aws_secret_access_key|secret_access_key|xox[baprs]-[0-9A-Za-z-]+|ghp_[0-9A-Za-z]{36}|eyJ[a-zA-Z0-9_-]{10,}\\.[a-zA-Z0-9._-]{10,}\\.[a-zA-Z0-9._-]{10,}" .
```

Result:
```text
No matches
```

## Before / After Confirmation
### Duplicate emergency trigger handling
- Before:
  repeated trigger actions could produce misleading incident state.
- After:
  `startEmergency` returns the current active incident and preserves history ordering.
- Proof:
  [`lib/core/app_state.dart:242`](/Users/prakhar/Documents/QAT/qat/lib/core/app_state.dart#L242)
  [`test/app_state_test.dart:7`](/Users/prakhar/Documents/QAT/qat/test/app_state_test.dart#L7)

### Offline degraded-mode safety
- Before:
  the resident could believe an unconfirmed mutation succeeded while offline.
- After:
  offline mode blocks state-changing actions and routes the user to direct calling.
- Proof:
  [`lib/core/app_state.dart:172`](/Users/prakhar/Documents/QAT/qat/lib/core/app_state.dart#L172)
  [`lib/screens/home/home_screen.dart:59`](/Users/prakhar/Documents/QAT/qat/lib/screens/home/home_screen.dart#L59)
  [`lib/screens/emergency/active_emergency_screen.dart:51`](/Users/prakhar/Documents/QAT/qat/lib/screens/emergency/active_emergency_screen.dart#L51)
  [`test/widget_test.dart:120`](/Users/prakhar/Documents/QAT/qat/test/widget_test.dart#L120)

### Incident transition guardrails
- Before:
  critical resident flows were not pinned by tests.
- After:
  acknowledge, resolve, and cancel behaviors are covered by unit and widget tests.
- Proof:
  [`lib/core/app_state.dart:315`](/Users/prakhar/Documents/QAT/qat/lib/core/app_state.dart#L315)
  [`lib/core/app_state.dart:339`](/Users/prakhar/Documents/QAT/qat/lib/core/app_state.dart#L339)
  [`lib/core/app_state.dart:363`](/Users/prakhar/Documents/QAT/qat/lib/core/app_state.dart#L363)
  [`test/widget_test.dart:51`](/Users/prakhar/Documents/QAT/qat/test/widget_test.dart#L51)
  [`test/widget_test.dart:76`](/Users/prakhar/Documents/QAT/qat/test/widget_test.dart#L76)

## Verification Gaps
- Cross-repo audit is blocked because only the client repo is present locally; required backend, worker, AWS/IaC, CI/CD, and system docs repos were not supplied.
- Android release verification is blocked in this environment until the Android SDK is installed.
- No backend, AWS, or queue-driven system exists in the repo, so end-to-end incident delivery and escalation gates remain unexecutable.
- No advisory-backed SCA database scan was available in this offline repo session; only dependency inventory and in-repo secret scanning were completed.
