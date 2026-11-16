# ORVIKA Android security configuration review

Review date: 16 November 2026  
Scope: committed Android main manifest, Gradle release configuration, wrapper, ignore rules and targeted native dependency advisory review  
Status: source/configuration review only; no build or device execution performed

## Observed repository configuration

- Application ID and namespace are `com.orvika.app`.
- Main manifest declares CAMERA and INTERNET only.
- Camera and camera-autofocus hardware are explicitly optional, so devices without either capability are not unnecessarily filtered out; manual inspection paths remain available.
- Cleartext traffic is disabled in the main application manifest.
- No production `android:debuggable="true"` flag is declared in the main manifest.
- Release build tasks fail when the complete upload-signing configuration is absent.
- Signing properties and keystore extensions are covered by Android ignore rules.
- Gradle wrapper distribution is explicitly version-pinned.
- Android-managed cloud backup and device-to-device transfer are disabled/excluded by the current manifest and backup-rule resources.

## Targeted dependency advisory review

The current `pubspec.lock` pins:

- `mobile_scanner 7.5.0`
- `image_picker_android 0.8.13+25`
- `shared_preferences_android 2.5.4`

The targeted OSV advisory review found two relevant historical advisories, both fixed before the locked versions:

- CVE-2024-54462 / GHSA-98v2-f47x-89xw affects `image_picker_android` through 0.8.12+17; the fix is 0.8.12+18. The locked 0.8.13+25 is beyond that fixed version.
- GHSA-3hpf-ff72-j67p affects `shared_preferences_android 2.3.3`; the fix is 2.3.4. The locked 2.5.4 is beyond that fixed version.

This was a targeted lookup of known advisories, not a full scan of all Dart packages, Maven artifacts, AARs, Gradle plugins, build tools or transitive dependencies. It does not establish that the complete release dependency graph is vulnerability-free.

## Native SDK licensing and platform dependency

The locked `mobile_scanner 7.5.0` package uses bundled Google ML Kit Barcode Scanning on Android by default. The scanner plugin's BSD-3-Clause licence is distinct from the ML Kit SDK terms; the latter must be reviewed separately before distribution. AndroidX and CameraX dependencies are separately licensed. The actual resolved Maven/AAR graph and its notices must be collected from an authorised release build.

The default bundled model is available without relying on Google Play Services to download the model at first use. This does not establish that every Google service or native dependency is compatible with Aurora OS or every target store.

## Automated repository guard

`node scripts/verify-security-config.cjs` checks the above source invariants alongside the existing Web response-header/CSP checks.

The guard intentionally fails if the manifest permission set changes. If a future feature requires a new permission, the change must include a documented purpose, user-visible permission flow, privacy review and an explicit update to the allowlist.

## Android artifact verification guard

The Android validation workflow now contains artifact-level checks for both APK and AAB outputs:

- The APK verifier checks the built application ID and the merged permission set against the reviewed CAMERA + INTERNET allowlist.
- The AAB verifier uses Google's official Bundletool 1.18.3 release, downloaded from its versioned GitHub release URL and checked against the published SHA-256 digest `a099cfa1543f55593bc2ed16a70a7c67fe54b1747bb7301f37fdfd6d91028e29`.
- The AAB verifier enumerates module manifests, checks each module's package identity, and aggregates permission declarations across modules against the same allowlist.
- The workflow continues to compare APK and AAB signer certificate sets.

These are implemented checks, not completed release evidence. GitHub Actions has not been run, and no APK/AAB has been built or inspected in this review.

## Not established by this source review

- Runtime permission prompt timing and denial behaviour.
- The effective merged manifest for debug/profile/release variants.
- Whether any transitive plugin adds manifest permissions.
- Runtime network destinations or packet-level isolation.
- Complete resolved native dependency graph, SBOM, licence inventory or vulnerability scan.
- Actual release signing identity, keystore custody, APK/AAB signature or installability.
- RuStore or Aurora store-policy compliance.

## Release verification still required

1. Inspect merged manifests for the actual release variant.
2. Resolve and archive the actual Maven/AAR dependency graph, SBOM and third-party licence notices.
3. Review Google's current ML Kit terms and confirm store/region compatibility for the intended distribution.
4. Build and inspect the signed release artifact after the owner has configured private signing material.
5. Install and exercise camera permission grant/denial and manual fallback on physical devices.
6. Capture network traffic during local analysis and separate app traffic from operating-system/hosting traffic.
7. Confirm the deployed Web headers independently.

Do not treat the static script's success or a targeted advisory lookup as a completed security audit or platform certification.
