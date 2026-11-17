# ORVIKA Privacy Notice

Last reviewed: 9 November 2026  
Applies to: current ORVIKA Web and application prototype

## At a glance

ORVIKA is designed to analyse submitted URLs, messages and QR payloads locally on the device. The current application does not require an ORVIKA account and does not provide cloud synchronisation of analysis history.

This notice distinguishes local security analysis from the limited external services used by the Web version.

## Data entered for security analysis

- Link Check analyses the URL text supplied by the user.
- Message Check analyses the message text supplied by the user.
- QR Check analyses manually entered or decoded QR content.
- Camera frames and selected image bytes are used for the active QR scan.
- ORVIKA does not intentionally upload these analysis inputs, camera frames, selected images or findings to an ORVIKA analysis server.
- ORVIKA does not automatically open destinations, initiate payments, send messages or join Wi-Fi networks from decoded QR content.

These are statements about the current application implementation, not a guarantee about the operating system, browser, keyboard, clipboard, extensions, backups or other software outside ORVIKA's control.

## Local device storage

The application stores interface preferences (language, theme and accessibility options) and Privacy checklist review progress using local preference storage. Submitted analysis content is not intended to be stored there.

Local preferences can remain on the device until the user clears application data or browser site data. The current application does not provide an ORVIKA account or cloud history synchronisation.

On Android, ORVIKA disables application backup and configures legacy and Android 12+ backup rules to exclude application data from cloud backup and device-to-device transfer. This is intended to keep the app's local preferences and progress on the device rather than in Android-managed backups. Device-manufacturer migration behaviour and platform-managed data outside ORVIKA's app sandbox may vary.

## Web analytics

The hosted Web application uses Vercel Web Analytics for basic page-view measurement. ORVIKA does not intentionally add submitted analysis content, account identifiers or custom security-analysis events to analytics.

Vercel processes technical request information under its own terms and privacy documentation:
https://vercel.com/docs/analytics/privacy-policy

The current implementation is page-view analytics only. Internal Flutter screen navigation is not represented as separately tracked custom events.

## Android barcode-scanning SDK

The Android camera and image barcode-scanning implementation uses the bundled Google ML Kit Barcode Scanning SDK through the `mobile_scanner` package. Barcode recognition runs on the device. Google states that ML Kit does not send the input images, video, text or resulting outputs to Google servers.

ML Kit does, however, send diagnostics and usage metrics to Google. The documented categories include device information (such as manufacturer, model and OS version), application/package information and app version, per-installation identifiers, performance metrics, API configuration (including image format and resolution), input/output size, feature version, event type and error codes. These metrics are encrypted in transit using HTTPS. Google states that this metrics data is not transferred to third parties. ML Kit may also contact Google servers for bug fixes, model updates and hardware-accelerator compatibility information.

ORVIKA does not send camera frames, selected QR images or decoded barcode payloads to Google as part of barcode recognition. This SDK-level diagnostics and usage-metrics processing is separate from ORVIKA's own page-view analytics. Google's documentation: https://developers.google.com/ml-kit/terms and https://developers.google.com/ml-kit/android-data-disclosure

## External runtime dependency

In browsers where the QR camera scanner uses the ZXing WebAssembly fallback, the browser downloads decoder code from jsDelivr. This is a code download, not an upload of camera frames, selected images or decoded QR payloads.

Web camera access requires a secure context and browser/OS permission. Browser and operating-system permission persistence is controlled by the platform; users can revoke access in site or device settings.

## Security limitations

ORVIKA provides explainable indicators, not a guarantee that a link, message, QR code or destination is safe. Analysis may be incomplete, inaccurate or out of date. Do not use it as the sole basis for financial, legal, medical or other high-impact decisions.

Some features may require connectivity to load the hosted application, analytics or browser decoder dependency. Do not assume every feature is fully offline on every platform.

## Security reports

For a suspected vulnerability, use the repository's Security tab and private vulnerability reporting option when available. Avoid publishing exploit details, credentials or personal information in a public issue.

## Changes

This notice should be updated when the application adds network-connected analysis, accounts, synchronisation, new analytics, new data storage or materially different third-party dependencies.
