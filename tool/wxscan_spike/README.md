# ORVIKA wxscan Web feasibility spike

This is an isolated browser runtime experiment. It is not imported by the production
application and does not change the production scanner.

## What CI now proves

- wxscan 0.1.7 resolves under the pinned Flutter SDK.
- The scanner WebAssembly is built from a pinned upstream Rust source commit.
- The LiteRT JavaScript/Wasm runtime is pinned and SHA-256 verified.
- The package's worker is copied from the resolved package.
- The official WeChat QR CNN detector and super-resolution TFLite models are
  fetched from a pinned weights-repository commit and SHA-256 verified.
- A deterministic synthetic QR fixture is generated in CI (never committed).
- The Flutter Web harness starts the actual worker, asserts both CNN stages
  loaded, scans the fixture through `WxScanner.scanImage`, and checks its
  expected payload in headless Chromium and Firefox.

## Model provenance and privacy

The two model files are Apache-2.0 derivatives of the WeChatCV QR models. Their
upstream checksums are checked before packaging. Model weights are public
algorithm assets, not user data. No reference photograph, QR payload from a
personal code, or other user content is uploaded or committed.

The synthetic fixture is generated locally in the CI runner. At runtime, the
browser decodes it into pixels and wxscan processes those pixels in a local
WebAssembly worker. No remote decoder, CDN scanner, camera permission, or
image upload is involved.

## Still not proven

- Decoding the user's private stylised QR photographs.
- Whether this CNN pipeline materially improves those particular dot modules,
  custom finder patterns, logo overlay, perspective and display artefacts.
- Brave-specific behaviour (Chromium is tested; Brave requires a separate
  real-browser check).
- Mobile performance, memory use, bundle transfer cost and native-platform
  compatibility.

Do not integrate into production unless the browser runtime tests pass and a
separate manual test demonstrates a measurable improvement on the private
reference images while preserving the existing ZXing QR and barcode coverage.
