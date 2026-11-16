# ORVIKA Web/PWA readiness

Status: source metadata and static preflight implemented; build and browser validation not run.

## Source changes

- The Web App Manifest now has a stable root identity, relative start URL and scope, standalone display preference, display overrides, application language, categories and an explicit preference against related-app promotion.
- The manifest retains local 192px, 512px and maskable SVG icon assets.
- The HTML entrypoint declares mobile-web-app and Apple standalone presentation metadata, a Safari pinned-tab mask icon and the manifest.
- Flutter remains the sole owner of its Web bootstrap and any generated service-worker registration. ORVIKA does not add a competing hand-written service worker.
- Vercel analytics continues to load through the existing first-party bootstrap; it is not a security-analysis data channel.

## Static preflight

After an authorised Flutter Web build, run:

```sh
flutter build web
node scripts/verify-pwa-readiness.cjs
```

The preflight validates manifest identity/scope/start URL, icon references and declared SVG dimensions, maskable icon presence, HTML install metadata and the generated Flutter bootstrap when a build output exists. It does not fetch a site, install an app, inspect browser storage, or prove offline operation.

## Required release validation

1. Confirm install prompts and standalone launch on current Chrome/Edge Android and supported desktop Chromium browsers.
2. Confirm Safari Add to Home Screen behaviour on iOS. The current Apple touch-icon reference is SVG; if the target iOS version does not render it correctly, add a dedicated PNG touch icon before release.
3. Verify first load online, subsequent launch offline, offline navigation, reload while offline, reconnect and update to a newer release.
4. Verify Flutter's generated service-worker/cache strategy for the exact production build. Do not assume every runtime dependency is cached.
5. Confirm the externally fetched ZXing WebAssembly decoder remains an optional network dependency and QR image/camera content is not uploaded.
6. Verify cache invalidation and rollback after a new deployment; ensure stale app shells recover cleanly.
7. Check Vercel and Cloudflare Pages independently because deployment base paths and headers can differ.
8. Record browser, OS, build commit, install result, offline result, cache/update result and any defects.

## Offline limitations

The PWA shell and Flutter assets may be cached by the Flutter-generated service worker, depending on the Flutter build strategy. This does not guarantee that every feature is available offline: the browser decoder dependency may require a first network fetch, and hosted analytics needs connectivity. Never claim total offline capability until the production artifact has passed the checks above.


## Web camera decoder CSP dependency

The live Web camera scanner currently loads its ZXing WebAssembly decoder from `cdn.jsdelivr.net`. The deployed Content Security Policy therefore permits that exact origin for script loading and decoder fetches (`script-src` and `connect-src`); it does not permit wildcard external sources. This remains a third-party runtime dependency and can be unavailable when the CDN is blocked or offline. Selected-image fallback decoding remains bundled locally.
