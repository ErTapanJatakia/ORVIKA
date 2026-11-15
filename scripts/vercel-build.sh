#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="3.47.9"
FLUTTER_DIR="${TMPDIR:-/tmp}/orvika-flutter-${FLUTTER_VERSION}"

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  rm -rf "$FLUTTER_DIR"
  git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"
flutter --version
flutter pub get --enforce-lockfile
flutter analyze --fatal-infos
flutter test --reporter expanded
flutter build web --release --csp --no-web-resources-cdn
test -s build/web/index.html
test -s build/web/flutter_bootstrap.js
test -s build/web/main.dart.js
test -s build/web/canvaskit/canvaskit.js
test -s build/web/canvaskit/canvaskit.wasm
