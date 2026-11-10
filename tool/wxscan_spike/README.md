# ORVIKA wxscan Web feasibility spike

This directory is an isolated experiment. It is not imported by the production
application and does not change the production scanner.

## Purpose

Verify that wxscan 0.1.7 resolves under the Flutter SDK pinned by ORVIKA CI,
that its browser worker/WebAssembly payload can be fetched and packaged, and
that the configured paths survive a release Web build.

## Current compatibility findings

- ORVIKA CI pins Flutter 3.47.9.
- wxscan 0.1.7 declares Dart >=3.10 and Flutter >=3.38.1.
- The production app currently declares Dart >=3.4.0. Do not raise that
  production constraint for this spike.
- wxscan is an advanced QR decoder, not a replacement for ZXing's broader
  1D/2D barcode format support.
- Its browser implementation uses a worker and four local files. Three are
  fetched by `dart run wxscan:fetch_web`; the worker is supplied by the package.
- CNN model weights are optional in the package, but without them the package
  explicitly documents reduced detection capability. A proper accuracy test
  must include pinned model files and verify their SHA-256 values.
- Its native build hook downloads/builds Rust and TensorFlow Lite assets.
  This spike must report any network/build dependency; runtime scanning must
  not depend on a third-party CDN or remote service.

## First-stage acceptance

1. Dependency resolution succeeds without changing the production
   `pubspec.yaml` or `pubspec.lock`.
2. `dart run wxscan:fetch_web` creates the expected local Web payload.
3. Flutter Web release compilation succeeds with local worker/Wasm paths.
4. The resulting build contains the worker, scanner Wasm, TFLite loader and
   TFLite Wasm files.
5. No production scanner code, analytics, CSP, deployment settings or
   personal reference images are changed.

## Not yet proven

- Runtime worker startup in Firefox, Chrome and Brave.
- Decoding the user's two private stylised QR photographs.
- Whether the CNN models improve this particular dot-pattern/custom-finder/
  central-logo sample.
- Android/iOS native build compatibility and binary-size impact.
- Full performance and memory behaviour on mobile devices.

Do not integrate this package into production unless the first-stage checks
pass and a separate browser test proves a measurable improvement on the
reference sample while retaining ordinary QR and Code 128 coverage.

## Privacy

Reference photographs must remain private and must never be committed to this
public repository. Use only synthetic fixtures in repository tests. All image
bytes for any future runtime test must remain in browser memory and must not
be uploaded to a remote decoder.
