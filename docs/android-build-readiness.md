# Android build readiness

Review date: 16 November 2026  
Status: permanent Android project scaffold committed; release signing and validation remain pending

## Current repository baseline

The repository now contains a permanent Android project scaffold:

- Application ID and namespace: `com.orvika.app`.
- Kotlin Gradle DSL project configuration.
- Gradle wrapper and pinned Gradle distribution.
- Android Gradle Plugin and Kotlin plugin versions declared in `android/settings.gradle.kts`.
- Java 17 source/target compatibility.
- Main manifest with CAMERA and INTERNET permissions; camera and autofocus hardware are optional, and cleartext traffic is disabled.
- Release signing is fail-closed: release build tasks throw a Gradle exception unless all four signing values are supplied.
- `android/key.properties` and keystore files are ignored by Git.

The Flutter SDK supplies the compile SDK, NDK, minimum SDK, target SDK, version code and version name through the Flutter Gradle plugin. Those effective values must be recorded from the approved release toolchain when an Android build is authorised.

## Manual repository preflight

Run from a repository checkout:

```sh
node scripts/verify-android-release-readiness.cjs
```

The script checks required scaffold files, wrapper pinning, plugin declarations, application identity, Java compatibility, release-signing guard, manifest security invariants and Git tracking of signing files. It reports whether local signing material is configured without printing any credential values.

A structural preflight pass does not build an APK/AAB, inspect the merged manifest, verify a signature, install the app or prove store acceptance.

## Signing and key custody

- Generate a dedicated production upload key only when the release owner is ready to establish long-term custody.
- Keep the keystore outside the repository and create an encrypted offline recovery backup.
- Keep `android/key.properties` local and private.
- Do not paste credentials into chat, pull requests, issues, source files or logs.
- Do not regenerate a published upload key without following the relevant store recovery/rotation procedure.
- See [Android release signing](../android/RELEASE_SIGNING.md).

## Native SDK and distribution terms

The locked `mobile_scanner 7.5.0` package uses Google's **bundled ML Kit Barcode Scanning SDK** on Android by default. This keeps the model available without a first-use Google Play Services model download, but increases application size. The plugin's BSD-3-Clause licence does not itself grant rights to the separately distributed ML Kit SDK; Google's ML Kit terms apply to that SDK.

Before any Android store submission:

- Review the current Google ML Kit terms and applicable Google API terms for the intended distribution and operating regions.
- Confirm that the selected bundled ML Kit implementation is acceptable for the target store and supported device ecosystem, including Aurora OS. Do not assume that the presence of an Android-compatible APK establishes Aurora compatibility.
- Confirm whether the store requires additional SDK attribution, privacy disclosures, or other declarations.
- Record the resolved native dependency graph and its licences from the actual release build; the Flutter lockfile alone does not enumerate every transitive Maven/AAR dependency.
- Reassess the dependency inventory and advisories at release time. The current targeted advisory review is not a complete SBOM or CVE clearance.

## Store preparation

- RuStore: confirm the current package, signing, target SDK, privacy disclosure and metadata requirements from the official publisher documentation before submission.
- Aurora OS: confirm certificate issuance, supported signing tooling, package format and store requirements before generating an Aurora artifact. Certificate approval is an external dependency and is not represented by this repository.
- Do not assume a standard Android APK is automatically an Aurora-compatible package.

## Validation and release boundary

The owner has requested that CI and Android validation remain disabled by default. Run the complete Android build/install/device validation only after the relevant implementation batch is frozen and the owner explicitly authorises it.

No production signing key is included. No release APK/AAB was built or signed as part of this work. No physical-device validation, RuStore submission, Aurora packaging or deployment was performed.
