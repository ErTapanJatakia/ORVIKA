# QR Check camera and barcode-scanning privacy design

## Scope

QR Check retains its existing manual paste-and-inspect workflow. The camera path is opt-in and returns one decoded value to the same on-device `QrPayloadAnalyzer`. It does not open destinations, join Wi-Fi networks, save contacts, send messages, or initiate payments.

## Camera session controls

- The scanner controller is created with automatic start disabled.
- The camera is requested only after the user opens the scanner and presses **Allow camera for this scan**.
- The first non-empty decoded value stops the camera before the value is returned to QR Check.
- Leaving the scanner disposes its controller; the user can also stop an active session explicitly.
- The camera is paused and released when the app/browser lifecycle reports that the app is inactive or backgrounded, and is restarted only if the user had explicitly started that scan and the scan has not already completed.
- Camera frames are not requested for persistence or uploaded by ORVIKA. The decoded value remains in the existing in-memory input/result state.
- ORVIKA does not store a remembered camera-consent flag or permission state.

## Permission limitation — important

Browsers and operating systems own camera permission prompts and persistence. Once a person grants access, a browser or OS may remember that grant and may not show another prompt on the next session. An application cannot universally force a fresh native/browser permission prompt or revoke a permission grant programmatically. Users can revoke access in their browser/site or operating-system privacy settings. The in-app control limits when ORVIKA starts and stops capture; it does not override the platform permission model.

Camera use on the web requires a secure context (HTTPS, or an eligible localhost context), a browser that exposes camera capture, and user permission. Embedded browsers, iframe permission policies, device hardware, enterprise policy and browser versions can restrict access.

## Barcode formats and platform coverage

The selected `mobile_scanner` integration uses platform-native scanning backends where available and a ZXing-based web backend. It supports QR codes and a broad set of 1D/2D formats including Aztec, Codabar, Code 39/93/128, Data Matrix, EAN-8/13, ITF, PDF417, UPC-A/E and DataBar variants. Actual availability can vary by platform, OS version and web backend.

The package currently supports Android, iOS, macOS and Web. It does not provide native Linux or Windows camera scanning. A browser-based ORVIKA Web session can run on Windows/Linux if that browser supports camera capture, but this is not the same as a native desktop application. The repository currently ships the Flutter Web project; Android is generated as a CI validation scaffold, and native iOS/macOS/Linux/Windows application projects are not currently present.

## Web decoding dependency

The package's web fallback uses ZXing WebAssembly when the browser's native BarcodeDetector API is unavailable (notably Firefox). The package documentation describes loading this fallback from jsDelivr by default. This is a decoder-library download, not an upload of camera frames or decoded QR content. It is an external dependency and must remain disclosed; a future hardening increment can vendor/self-host the exact version if we decide to eliminate this runtime CDN dependency.

## Validation boundaries

Automated Flutter tests can validate the existing manual analysis path and UI contracts. They cannot prove camera permission behavior across every browser/OS. Real-device/browser validation is required for Android Chrome, Android Firefox, desktop Chrome/Edge/Firefox/Safari where available, and any future native platform targets. No universal fresh-prompt guarantee or full cross-platform runtime claim is made.
