# QR Check camera and image-scanning privacy design

## Scope

QR Check retains its existing manual paste-and-inspect workflow. Live camera scanning and selected-image scanning are separate, explicit, one-session actions. Decoded values are passed to the existing on-device `QrPayloadAnalyzer`. ORVIKA does not open destinations, join Wi-Fi networks, save contacts, send messages, or initiate payments.

## Camera session controls

- The scanner controller is created with automatic start disabled.
- The camera is requested only after the user opens the scanner and presses **Allow camera for this scan**.
- The first non-empty decoded value stops the camera before the value is returned to QR Check.
- Leaving the scanner disposes its controller; the user can also stop an active session explicitly.
- The camera is paused and released when the app/browser lifecycle reports that the app is inactive or backgrounded, and is restarted only if the user had explicitly started that scan and the scan has not already completed.
- Camera frames are not requested for persistence or uploaded by ORVIKA. The decoded value remains in the existing in-memory input/result state.
- ORVIKA does not store a remembered camera-consent flag or permission state.

## Image selection and temporary access

- Image scanning is offered through the operating system's selected-photo picker or the browser's file chooser after the user taps **Choose image**.
- ORVIKA does not request broad or persistent gallery/storage access and does not save a remembered image-library permission.
- Only the selected image is read. The selected image bytes are held in memory for the active scanner route and released when the image is cleared or the route is disposed.
- The selected image and decoded content are not uploaded by this feature. The image is not written to ORVIKA application storage.
- Images larger than 20 MiB are rejected before decoding to bound memory use.
- Multiple codes found in one image are listed; the user selects which code to inspect.
- The image picker and underlying OS/browser determine which image types can be selected. Actual decoding depends on the platform's image decoder; JPEG, PNG, WebP, GIF and BMP are common targets, while HEIC/HEIF, TIFF, AVIF and other formats vary by OS/browser. No universal support for every image format is claimed.

## Decoder/platform boundaries

- Android and Apple native implementations use `mobile_scanner.analyzeImage` and the same native scanning engines as the camera feature where supported.
- The current `mobile_scanner` release does not support `analyzeImage` on Web. ORVIKA Web therefore uses the browser's native Shape Detection `BarcodeDetector` API for selected images.
- Browser image decoding requires `BarcodeDetector`. Browsers without this API (notably Firefox) receive an explicit unsupported message for image scanning; live camera scanning remains available through the package's Web ZXing fallback.
- Web image format support is limited to formats reported by the active browser implementation. Native browser format coverage varies by browser and operating system; it is not identical to every format supported by the live ZXing-WASM camera fallback.
- Linux and Windows native app projects are not currently shipped. Browser-based ORVIKA Web may be used on those systems subject to browser support.

## Camera permission limitation

Browsers and operating systems own camera permission prompts and persistence. Once a person grants access, a browser or OS may remember that grant and may not show another prompt on the next session. An application cannot universally force a fresh native/browser permission prompt or revoke a permission grant programmatically. Users can revoke access in their browser/site or operating-system privacy settings.

## Validation boundaries

Automated Flutter tests can validate UI contracts and existing analyzer behavior. They cannot prove photo-picker behavior, image-format decoding, or barcode detection across every OS/browser. Real-device/browser validation is required for Android and major browsers. No universal every-format or every-browser guarantee is made.
