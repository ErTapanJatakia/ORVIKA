# ORVIKA Android security configuration review

Review date: 16 November 2026  
Scope: committed Android main manifest, Gradle release configuration, wrapper and ignore rules  
Status: source/configuration review only; no build or device execution performed

## Observed repository configuration

- Application ID and namespace are `com.orvika.app`.
- Main manifest declares CAMERA and INTERNET only.
- Camera hardware is optional, so devices without a camera can still use manual inspection paths.
- Cleartext traffic is disabled in the main application manifest.
- No production `android:debuggable="true"` flag is declared in the main manifest.
- Release build tasks fail when the complete upload-signing configuration is absent.
- Signing properties and keystore extensions are covered by Android ignore rules.
- Gradle wrapper distribution is explicitly version-pinned.

## Automated repository guard

`node scripts/verify-security-config.cjs` now checks the above invariants alongside the existing Web response-header/CSP checks.

The guard intentionally fails if the manifest permission set changes. If a future feature requires a new permission, the change must include a documented purpose, user-visible permission flow, privacy review and an explicit update to the allowlist.

## Not established by this source review

- Runtime permission prompt timing and denial behaviour.
- The effective merged manifest for debug/profile/release variants.
- Whether any transitive plugin adds manifest permissions.
- Runtime network destinations or packet-level isolation.
- Actual release signing identity, keystore custody, APK/AAB signature or installability.
- RuStore or Aurora store-policy compliance.

## Release verification still required

1. Inspect merged manifests for the actual release variant.
2. Build and inspect the signed release artifact after the owner has configured private signing material.
3. Install and exercise camera permission grant/denial and manual fallback on physical devices.
4. Capture network traffic during local analysis and separate app traffic from operating-system/hosting traffic.
5. Confirm the deployed Web headers independently.

Do not treat the static script's success as a completed security audit or platform certification.
