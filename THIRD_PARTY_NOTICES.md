# Third-party notices

This file records third-party components identified in the current ORVIKA source review. It complements, but does not replace, the Flutter-generated in-app licence registry.

## zxing_lib 1.1.4

ORVIKA bundles `zxing_lib`, a pure-Dart ZXing port used as an offline fallback for image-based QR and barcode decoding on Web.

- Upstream project: https://github.com/shirne/zxing-dart
- Package: https://pub.dev/packages/zxing_lib
- License: Apache License 2.0
- Copyright: ZXing authors and contributors

The full Apache 2.0 license text is included in [third_party_licenses/ZXING-DART-APACHE-2.0.txt](third_party_licenses/ZXING-DART-APACHE-2.0.txt).

## mobile_scanner 7.5.0

ORVIKA uses `mobile_scanner` for native camera-based QR scanning and the Web camera scanner.

- Upstream project: https://github.com/juliansteenbakker/mobile_scanner
- Package: https://pub.dev/packages/mobile_scanner
- License: BSD 3-Clause
- Copyright: 2022 Julian Steenbakker

The full licence text is included in [third_party_licenses/MOBILE-SCANNER-BSD-3-CLAUSE.txt](third_party_licenses/MOBILE-SCANNER-BSD-3-CLAUSE.txt).

The Android implementation declares the camera permission and optional camera hardware feature. Its inspected plugin manifest adds no provider, service, receiver, or activity.

## image_picker 1.2.4 / image_picker_android 0.8.13+25

ORVIKA uses `image_picker` to let the user select a QR image from the device gallery.

- Upstream project: https://github.com/flutter/packages/tree/main/packages/image_picker
- Package: https://pub.dev/packages/image_picker
- Android implementation: https://pub.dev/packages/image_picker_android
- Licences: BSD 3-Clause (Flutter Authors) and Apache License 2.0 (aFileChooser component)
- Copyright: 2013 The Flutter Authors; aFileChooser copyright 2011–2013 Paul Burke

The combined upstream licence text is included in [third_party_licenses/IMAGE-PICKER-ANDROID-LICENCES.txt](third_party_licenses/IMAGE-PICKER-ANDROID-LICENCES.txt).

The inspected Android manifest contributes a non-exported FileProvider with URI grants enabled and a cache-only path configuration. Its Google Play photo-picker module service is disabled and non-exported.

## zxing-wasm Web camera-decoder runtime

In browsers where the native `BarcodeDetector` API is unavailable, `mobile_scanner` can load the `zxing-wasm` WebAssembly decoder from jsDelivr. ORVIKA does not bundle this WebAssembly runtime in its own source assets; it is fetched by the browser at runtime.

- Upstream project: https://github.com/Sec-ant/zxing-wasm
- Package: https://www.npmjs.com/package/zxing-wasm
- Runtime delivery: jsDelivr CDN
- Identified component licences:
  - zxing-wasm-specific code: MIT License, copyright 2023 Ze-Zheng Wu
  - zxing-cpp and the WebAssembly bridge: Apache License 2.0; notices identify Nu-book Inc., Axel Waggershauser and Ze-Zheng Wu
  - zint encoding library: BSD 3-Clause

The MIT and Apache licence texts are included in [third_party_licenses/ZXING-WASM-MIT.txt](third_party_licenses/ZXING-WASM-MIT.txt) and [third_party_licenses/ZXING-WASM-APACHE-2.0.txt](third_party_licenses/ZXING-WASM-APACHE-2.0.txt). The zint project licence and attribution are maintained upstream at https://github.com/zint/zint/blob/master/LICENSE.

## Scope and release follow-up

This is a targeted inventory of the components identified during source review, not a complete software bill of materials or legal opinion. Flutter's in-app licence page exposes the licences registered by Flutter's package tooling. Native Android Maven dependencies brought in by plugins (including CameraX, ML Kit, AndroidX and Kotlin coroutines) still require a generated dependency/licence inventory from a resolved Android build before final store-release sign-off. No such build or dependency report has been run in this review.
