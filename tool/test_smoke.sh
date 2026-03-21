#!/usr/bin/env bash
set -euo pipefail

flutter test test/smoke
flutter test --platform chrome test/smoke
