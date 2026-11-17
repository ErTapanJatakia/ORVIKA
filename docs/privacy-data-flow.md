# Privacy and offline data-flow audit

Status: source-reviewed baseline with automated input-persistence regression tests  
Scope: Flutter Web/Android application code on the current `main` baseline

## Security-analysis input lifecycle

The Link, QR and Message screens each own a `TextEditingController` and retain their analysis result in widget state. Their submit handlers call the corresponding deterministic domain analyzer directly. Message Check identifies configured social-engineering language, extracts visible web addresses and contact details for review, and renders generic safe-next-step guidance. It does not open links, contact extracted addresses, verify sender identity, or make a fraud verdict. The controllers are disposed with their screens.

The Link, QR and Message presentation/domain paths reviewed for this batch do not call `SharedPreferences`, perform HTTP requests, or invoke analytics APIs. The analysis result and entered content remain in the active screen state; this is not a claim about operating-system memory, browser extensions, crash dumps, screenshots, or third-party platform behaviour.

## Local persistence inventory

The current `SharedPreferences` writes reviewed in `lib/main.dart` are limited to:
- appearance theme, language and language catalogue;
- onboarding completion;
- accessibility text scale, bold text and reduced-motion preferences.

The Academy screen stores completed lesson identifiers under `academy.completed.v1`. The Privacy screen stores reviewed checklist identifiers under `privacy.reviewed.v1`. Privacy self-assessment answers (`Already in place`, `Needs attention`, or `Not sure`) remain in the active screen's memory only and are discarded when the screen is disposed or the user resets the assessment.

These values represent app preferences or progress markers. The inspected write paths do not store submitted URLs, decoded QR payloads, message text, credentials or security-analysis findings.

## Active checker input and result controls

- Link Check and QR Check expose an explicit clear action while input or a result is present. The action clears the text controller and the associated result; QR Check also clears detected-format context.
- Editing a submitted Link or QR payload immediately invalidates the previous result so that findings for an earlier value are not displayed beside a changed value.
- Message Check already invalidates its result when the message text changes and provides an explicit clear action.
- These controls clear active widget state only. They do not promise secure memory erasure from the runtime, operating system, browser process, screenshots or crash dumps.
- The clear-control regression tests verify visible UI state and controller contents; they do not constitute a forensic memory-erasure test.

## QR image picker lifecycle

- Image selection begins only after the user explicitly opens QR Check image scanning and chooses an image.
- The selected image bytes and decoded result are held in the active scanner route's memory. They are not added to SharedPreferences or sent by the QR analysis code path.
- Native picker implementations may copy the selected image into an application cache file. ORVIKA best-effort deletes the selected temporary file when it is replaced, cleared, rejected, or the scanner route is disposed. A force-stop or process termination can prevent application cleanup; remaining cache files are subject to operating-system cache lifecycle and cleanup.
- On Web, the browser owns the selected file object. ORVIKA revokes the temporary object URL created for image decoding.
- This source-level review does not prove that every OS/browser, extension, backup system or crash-reporting mechanism is free of access to temporary data. Real-device lifecycle validation remains required.

## Web image decoding

- Web image scanning decodes the selected image into an in-memory canvas and downsizes images above 8 megapixels before barcode decoding.
- When available, the browser's native `BarcodeDetector` runs against that bounded canvas. The bundled pure-Dart `zxing_lib` decoder also runs against the bounded pixel buffer; results from both paths are merged and deduplicated.
- The bundled fallback supports QR, common 1D formats (including Code 128, Code 39, EAN/UPC and ITF), Data Matrix, Aztec, PDF417 and MaxiCode. The pixel ceiling applies to both Web decoding paths, not only the fallback.
- The fallback is part of the application bundle: it does not fetch JavaScript/WASM from a CDN, call a remote decoder, or upload image bytes. The temporary object URL is revoked after scanning.
- The pixel decoder tries red, green, blue and weighted-luminance interpretations, stretches usable contrast, and enables ZXing's `tryHarder` and inverted-image hints. It continues through all channel interpretations and merges distinct results so a first hit in one channel does not suppress additional codes visible in another. These local attempts improve resilience to coloured foregrounds/backgrounds and some low-contrast designs; they do not guarantee decoding of decorative, distorted, occluded or logo-covered codes.
- The pure-Dart fallback prioritises compatibility and local processing; it can be slower and less accurate than native platform decoders. A no-result outcome is not proof that an image contains no barcode. Browser-specific image decoding, canvas and file-format support still require real-browser validation.

## Android camera-scanner SDK telemetry

The Android camera and native image-scanning path uses the bundled Google ML Kit Barcode Scanning SDK through `mobile_scanner`. Barcode input images/video and decoded outputs are processed on-device and are not sent to Google according to Google's ML Kit terms. Separately, ML Kit sends diagnostics and usage metrics to Google, including documented device/app information, per-installation identifiers, performance, API configuration, input/output size, feature version, event type and error codes. These metrics are encrypted in transit; Google states they are not transferred to third parties. ML Kit may contact Google for bug fixes, model updates and hardware-accelerator compatibility information.

This SDK telemetry is not generated by ORVIKA's checker code and is not ORVIKA security-analysis telemetry. The Android scanner screen discloses it before camera use, and the Privacy Notice records the data categories and provider references. Store privacy declarations must account for this SDK behaviour. Source references: https://developers.google.com/ml-kit/terms and https://developers.google.com/ml-kit/android-data-disclosure.

## Static privacy-boundary guard

`scripts/verify-privacy-boundaries.cjs` scans the Link, QR and Message feature source for accidental network clients, outbound navigation, persistent browser storage, SharedPreferences and analytics calls. The temporary-file cleanup implementation is explicitly excluded from the `dart:io` restriction because native cache-file deletion is its purpose. The guard also checks that the analytics bootstrap does not read form/input content or emit custom feature events. This is a source-regression guard, not a proof against indirect dependencies, runtime platform traffic, browser extensions, crash reporting or hosting/CDN logs.

## Analytics boundary

The Vercel integration remains a static page-view-only integration as documented in [analytics.md](analytics.md). It measures aggregate page-view and basic technical visitor metrics; ORVIKA does not add custom feature events, route instrumentation, user identifiers or security-analysis telemetry. Hosting/CDN infrastructure may independently process request metadata such as IP address, browser headers and security logs. This application-source audit does not establish the provider's exact retention or prove that no technical personal data is processed. The existing production Network-tab and dashboard verification remains the evidence for deployment-level analytics operation.

## Privacy self-assessment boundary

The Privacy module is a user-guided self-assessment, not a device scanner or compliance audit. It presents 12 practices across accounts, device, apps and browsing. Each practice explains why it matters, an action the user can take, and an important limitation. The user may select one of three session-only responses: already in place, needs attention, or not sure.

Editorial priority labels (high, recommended, routine) are fixed guidance to help sequence the review. They are not personalised risk ratings, vulnerability findings, or evidence that a device or account is exposed. The summary counts only the user's current in-session responses. These answers are not written to SharedPreferences, analytics, or a remote service.

The separate reviewed checkbox records only that guidance was reviewed; its stable practice identifier is stored locally so progress can be resumed. Reset clears those local review marks and the current in-session answers. It does not modify operating-system, application, browser, or account settings. A completed checklist is not a security certification or professional privacy assessment.

## Automated regression coverage

`test/privacy_data_isolation_test.dart` exercises the actual Link, QR and Message screens with distinctive sensitive test inputs, submits each analysis, and asserts that the mocked `SharedPreferences` store remains empty.

This test proves only that these screen flows do not write to the SharedPreferences interface under test. It does not prove the absence of all possible filesystem, browser, operating-system, crash-reporting, extension, or network side channels. The Privacy widget tests additionally verify that selecting an assessment response updates the in-session summary without writing any key to SharedPreferences. The repository-level source review and production/manual checks remain separate evidence.

## Offline boundary

The reviewed URL, QR and message analyzers are deterministic local code paths. The threat-intelligence assessment engine and curated intelligence library are local reference/assessment logic; source URI fields are descriptive metadata and are not fetched by the assessment domain layer. No live reputation lookup, DNS resolution, redirect following, or remote feed ingestion is implied by these modules.

This is a source-level architecture statement, not a packet-capture claim. Platform-level network validation must be performed separately on supported browsers and devices before making a comprehensive offline-conformance claim.

## Guardrails

- Do not persist security-analysis inputs or findings for convenience.
- Do not pass user-entered content or findings to Vercel Analytics.
- Keep analytics separate from security analysis.
- Preserve deterministic local analysis and explicit uncertainty.
- Do not describe this source audit or its widget tests as proof of total network isolation or complete privacy certification.


## Live camera network dependency

The Web live-camera scanning path uses the package's ZXing WebAssembly runtime fetched from `cdn.jsdelivr.net`; this is distinct from selected-image scanning, whose pure-Dart pixel decoder is bundled locally. The camera decoder download is permitted by the exact-origin CSP rule documented in [qr-camera-privacy.md](qr-camera-privacy.md). Camera frames and decoded payloads are not intentionally uploaded by ORVIKA, but live camera scanning may be unavailable offline or when the CDN is blocked.
