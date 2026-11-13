# Android release signing

ORVIKA's Android release build must be signed with a private upload key. The
repository intentionally contains no keystore or signing password.

## Local build

1. Generate an upload keystore and keep at least one encrypted offline backup.
2. Store the keystore outside the repository where practical.
3. Create `android/key.properties` (this file is git-ignored):

```properties
storeFile=/absolute/path/to/orvika-upload-key.jks
storePassword=REPLACE_WITH_PRIVATE_STORE_PASSWORD
keyAlias=orvika-upload
keyPassword=REPLACE_WITH_PRIVATE_KEY_PASSWORD
```

4. Build with `flutter build appbundle --release` or
   `flutter build apk --release`.

The Gradle build accepts the same four values from environment variables:
`ORVIKA_UPLOAD_STORE_FILE`, `ORVIKA_UPLOAD_STORE_PASSWORD`,
`ORVIKA_UPLOAD_KEY_ALIAS`, and `ORVIKA_UPLOAD_KEY_PASSWORD`. Use your CI
secret store if building remotely; never print these values in logs.

## Key custody

- The developer owns and controls the upload key and its recovery backup.
- Never commit the keystore, `key.properties`, passwords, or private key material.
- Do not regenerate or replace the upload key casually after publishing.
- For Google Play, configure Play App Signing and retain the upload key separately.
- Confirm RuStore's current signing and package requirements before the first
  production submission.

Release tasks deliberately fail when signing is not configured. This prevents
an accidentally debug-signed or unsigned artifact from being mistaken for a
store-ready release. Debug builds remain available for development.
