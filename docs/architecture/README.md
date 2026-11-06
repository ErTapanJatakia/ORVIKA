# ORVIKA architecture baseline

## Product boundary

ORVIKA is a personal cyber-safety intelligence product. Its initial scope is
consumer protection against suspicious links, QR codes, messages, impersonation,
social engineering, privacy risks and post-incident uncertainty.

## Initial application shape

- Flutter presentation layer for Android and Web/PWA.
- Feature modules: Sentinel, Link, QR, Message, Intelligence, Privacy,
  Academy, Response and Identity.
- Shared domain logic must remain independent of UI widgets and platform APIs.
- Platform integrations must sit behind narrow interfaces.
- No backend, telemetry, account system or external scanning service is required
  for the first local prototype.

## Trust and safety principles

1. A suspicion is not a confirmed malicious verdict.
2. Explain what was checked, what was not checked and the limits of each result.
3. Prefer deterministic, reproducible checks and attributable threat intelligence.
4. AI may help explain evidence; it must not invent evidence or silently determine
   a final security verdict.
5. Minimise collection and retention of personal data. Keep analysis on-device
   wherever practical.
6. Never transmit a submitted URL, message or QR payload without clear disclosure
   and user consent.
7. Build accessible flows, including readable language and senior-friendly
   interaction patterns.

## Delivery sequence

1. Establish the Flutter shell and CI.
2. Define typed domain models and a transparent analysis-result contract.
3. Implement offline URL parsing and deterministic risk indicators.
4. Add QR payload inspection without automatic navigation.
5. Add user-initiated message analysis with privacy safeguards.
6. Add education and incident-response guidance.
7. Evaluate Aurora OS integration against the supported SDK and signing process.

## Platform note

Android and Web are the first build targets. Aurora OS is a planned target and
requires validation against the current Aurora Flutter/toolchain integration
before platform-specific code or release claims are made.
