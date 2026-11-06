# ORVIKA

**Online Risk Verification, Intelligence, Knowledge & Assistance**

**Personal Cyber Safety Intelligence**  
*Check Before You Trust.*

> See the Risk. Verify the Signal. Stay in Control.

ORVIKA is being developed as a privacy-conscious digital safety companion to help
people assess suspicious links, QR codes, messages and online interactions,
understand potential risks, and choose safer next steps.

## Project status

<kbd>Early development · Foundation phase</kbd>

The initial Flutter application shell is under construction. The current screen
is a UI preview; its tool tiles do not perform live security analysis yet.

## Product principles

- **Evidence before verdicts:** indicators and uncertainty are explained.
- **Privacy by design:** minimise data collection and favour local processing.
- **User control:** never silently submit personal content to external services.
- **Accessible by default:** clear language, readable layouts and inclusive flows.
- **No false assurance:** AI-generated suspicion is never presented as a confirmed
  malicious finding.

## Planned capabilities

- Sentinel — personal safety dashboard
- Link — URL and domain inspection
- QR — QR payload inspection before opening
- Message — suspicious SMS, email and chat analysis
- Intelligence — evidence-led explanations
- Privacy — digital hygiene guidance
- Academy — practical cyber-safety education
- Response — post-incident guidance
- Identity — account and identity safety guidance

## Technology direction

- Flutter / Dart
- Android and Web/PWA as initial build targets
- Aurora OS integration to be validated against its supported Flutter toolchain
- GitHub Actions for automated analysis, tests and web build checks

## Development

Prerequisites: Flutter stable channel and the Dart SDK bundled with Flutter.

```bash
flutter pub get
flutter analyze --fatal-infos
flutter test
flutter build web --release
```

See [the architecture baseline](docs/architecture/README.md) for product
boundaries, trust principles and delivery sequencing.

## Brand

**ORVIKA** — *Your Personal Digital Safety Companion*  
**Проверь, прежде чем доверять.**
