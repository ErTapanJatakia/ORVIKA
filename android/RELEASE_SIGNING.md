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

## Optional GitHub Actions signing

The Android validation workflow always produces a debug validation APK. It only
produces a production-signed APK and AAB when all four repository or environment
secrets are configured:

- `ORVIKA_UPLOAD_KEYSTORE_BASE64`: base64-encoded upload keystore bytes
- `ORVIKA_UPLOAD_STORE_PASSWORD`
- `ORVIKA_UPLOAD_KEY_ALIAS`
- `ORVIKA_UPLOAD_KEY_PASSWORD`

Encode the keystore locally without uploading it to a public location:

```bash
base64 -w 0 /secure/path/orvika-upload-key.jks
```

Copy the resulting value directly into the private GitHub Actions secret
`ORVIKA_UPLOAD_KEYSTORE_BASE64`. Add the three passwords/alias as separate
GitHub Actions secrets. Never paste these values into issues, pull requests,
chat, workflow logs, or repository files. The workflow writes the keystore to
the ephemeral runner's temporary directory and removes it when the runner is
discarded.
