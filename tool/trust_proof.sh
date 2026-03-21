#!/usr/bin/env bash
set -euo pipefail

flutter pub get
flutter analyze
bash tool/test_unit.sh
bash tool/test_smoke.sh
bash tool/test_regression.sh
flutter build web
