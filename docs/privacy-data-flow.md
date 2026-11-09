# Privacy and offline data-flow audit

Status: source-reviewed baseline with automated input-persistence regression tests  
Scope: Flutter Web/Android application code on the current `main` baseline

## Security-analysis input lifecycle

The Link, QR and Message screens each own a `TextEditingController` and retain their analysis result in widget state. Their submit handlers call the corresponding deterministic domain analyzer directly. The controllers are disposed with their screens.

The Link, QR and Message presentation/domain paths reviewed for this batch do not call `SharedPreferences`, perform HTTP requests, or invoke analytics APIs. The analysis result and entered content remain in the active screen state; this is not a claim about operating-system memory, browser extensions, crash dumps, screenshots, or third-party platform behaviour.

## Local persistence inventory

The current `SharedPreferences` writes reviewed in `lib/main.dart` are limited to:
- appearance theme, language and language catalogue;
- onboarding completion;
- accessibility text scale, bold text and reduced-motion preferences.

The Academy screen stores completed lesson identifiers under `academy.completed.v1`. The Privacy screen stores reviewed checklist identifiers under `privacy.reviewed.v1`.

These values represent app preferences or progress markers. The inspected write paths do not store submitted URLs, decoded QR payloads, message text, credentials or security-analysis findings.

## QR image picker lifecycle

- Image selection begins only after the user explicitly opens QR Check image scanning and chooses an image.
- The selected image bytes and decoded result are held in the active scanner route's memory. They are not added to SharedPreferences or sent by the QR analysis code path.
- Native picker implementations may copy the selected image into an application cache file. ORVIKA best-effort deletes the selected temporary file when it is replaced, cleared, rejected, or the scanner route is disposed. A force-stop or process termination can prevent application cleanup; remaining cache files are subject to operating-system cache lifecycle and cleanup.
- On Web, the browser owns the selected file object. ORVIKA revokes the temporary object URL created for image decoding.
- This source-level review does not prove that every OS/browser, extension, backup system or crash-reporting mechanism is free of access to temporary data. Real-device lifecycle validation remains required.

## Web image decoding

- Web image scanning tries the browser's native BarcodeDetector first when available.
- If that API is absent, rejects the image format, or returns no result, ORVIKA falls back to the bundled pure-Dart `zxing_lib` decoder. The fallback supports QR, common 1D formats (including Code 128, Code 39, EAN/UPC and ITF), Data Matrix, Aztec, PDF417 and MaxiCode.
- The browser decodes the selected image into an in-memory canvas pixel buffer. Images above 16 megapixels are downscaled before fallback decoding to bound memory and CPU use.
- The fallback is part of the application bundle: it does not fetch JavaScript/WASM from a CDN, call a remote decoder, or upload image bytes. The temporary object URL is revoked after scanning.
- The pure-Dart fallback prioritises compatibility and local processing; it can be slower and less accurate than native platform decoders. A no-result outcome is not proof that an image contains no barcode.

## Analytics boundary

The Vercel integration remains a static page-view-only integration as documented in [analytics.md](analytics.md). It measures aggregate page-view and basic technical visitor metrics; ORVIKA does not add custom feature events, route instrumentation, user identifiers or security-analysis telemetry. Hosting/CDN infrastructure may independently process request metadata such as IP address, browser headers and security logs. This application-source audit does not establish the provider's exact retention or prove that no technical personal data is processed. The existing production Network-tab and dashboard verification remains the evidence for deployment-level analytics operation.

## Automated regression coverage

`test/privacy_data_isolation_test.dart` exercises the actual Link, QR and Message screens with distinctive sensitive test inputs, submits each analysis, and asserts that the mocked `SharedPreferences` store remains empty.

This test proves only that these screen flows do not write to the SharedPreferences interface under test. It does not prove the absence of all possible filesystem, browser, operating-system, crash-reporting, extension, or network side channels. The repository-level source review and production/manual checks remain separate evidence.

## Offline boundary

The reviewed URL, QR and message analyzers are deterministic local code paths. The threat-intelligence assessment engine and curated intelligence library are local reference/assessment logic; source URI fields are descriptive metadata and are not fetched by the assessment domain layer. No live reputation lookup, DNS resolution, redirect following, or remote feed ingestion is implied by these modules.

This is a source-level architecture statement, not a packet-capture claim. Platform-level network validation must be performed separately on supported browsers and devices before making a comprehensive offline-conformance claim.

## Guardrails

- Do not persist security-analysis inputs or findings for convenience.
- Do not pass user-entered content or findings to Vercel Analytics.
- Keep analytics separate from security analysis.
- Preserve deterministic local analysis and explicit uncertainty.
- Do not describe this source audit or its widget tests as proof of total network isolation or complete privacy certification.
