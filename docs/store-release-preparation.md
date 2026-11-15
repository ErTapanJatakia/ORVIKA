# ORVIKA store-release preparation checklist

Status: preparation template; no store submission initiated  
Package identity: `com.orvika.app`

## RuStore

- [ ] Confirm publisher account eligibility and current individual-account requirements.
- [ ] Confirm current accepted package format, signing identity and target SDK requirements.
- [ ] Generate the production artifact only after the approved Android validation batch.
- [ ] Prepare app name, short/long description, category, age rating and supported-language metadata.
- [ ] Prepare current privacy notice, data-safety disclosures and camera-permission explanation.
- [ ] Prepare icon, phone screenshots, feature graphic and release notes to current image specifications.
- [ ] Verify support contact and vulnerability-reporting route.
- [ ] Review all permissions and third-party notices.
- [ ] Upload only the production-signed artifact; never use a debug validation APK for publication.

## Aurora OS

- [ ] Confirm Aurora certificate application has been approved and the certificate/private-key custody process is complete.
- [ ] Confirm the current Aurora SDK, package format, signing toolchain and supported API level.
- [ ] Confirm whether the Android app scaffold can be reused or whether Aurora-specific adaptation is required.
- [ ] Validate every plugin used by ORVIKA on Aurora OS, especially camera and image-picker integrations.
- [ ] Prepare Aurora-specific icon, screenshots, metadata, privacy disclosures and release notes.
- [ ] Build and sign the Aurora package using the approved certificate/toolchain.
- [ ] Install and test on a supported Aurora device or emulator before submission.

## Shared release controls

- [ ] Confirm app version and release commit.
- [ ] Confirm production upload-key custody and encrypted recovery backup.
- [ ] Verify artifact signature, package ID, version, SHA-256 digest and provenance.
- [ ] Verify offline behaviour and permission denial/fallback.
- [ ] Review final privacy, accessibility, localization and security gates.
- [ ] Obtain explicit owner approval before either store submission.

Do not mark any item complete based solely on a source file, workflow definition or static preflight script. Record the exact build, toolchain, device, result and evidence for every executed gate.
