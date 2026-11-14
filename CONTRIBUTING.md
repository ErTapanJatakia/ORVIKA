# Contributing to ORVIKA

Thank you for your interest in ORVIKA. ORVIKA is a privacy-first personal
cyber-safety project. Contributions and suggestions must support its safety,
privacy, accessibility, and explainability principles.

## Project status and contribution model

ORVIKA is an early-stage prototype. Features and modules may be incomplete
or under active development; consult the root [README](README.md) for the
current product status.

The repository is publicly readable, but ORVIKA is proprietary software.
Opening a pull request does not grant permission to reuse ORVIKA, and does
not automatically grant the project rights to incorporate submitted code.
Before submitting a code change, open an issue describing the proposal and
obtain written approval from the maintainer for the contribution and its
licensing terms. Unsolicited code pull requests may be closed without
merging. Do not submit third-party or employer-owned code unless you have
the necessary rights and written permission.

## Ways to contribute

You may:
- Report a reproducible bug without exposing private or sensitive data.
- Suggest a feature or improvement through a GitHub issue.
- Identify accessibility barriers or confusing user experiences.
- Review documentation for accuracy and clarity.
- Propose a code change after receiving maintainer approval.

For security vulnerabilities, do not open a public issue. Follow
[SECURITY.md](SECURITY.md) instead.

## Before proposing a change

Please:
1. Search existing issues and discussions to avoid duplicates.
2. Explain the user problem, expected behaviour, and proposed approach.
3. Identify affected platforms and modules.
4. Consider privacy, data minimisation, accessibility, localisation, and
   low-connectivity/offline behaviour.
5. Avoid adding telemetry, trackers, remote analysis services, or new
   network dependencies without explicit maintainer approval.
6. Never include credentials, tokens, signing keys, private certificates,
   personal data, or production user data.

## Engineering expectations

Approved changes should:
- Be narrowly scoped and maintainable.
- Preserve deterministic and explainable behaviour where applicable.
- Avoid presenting suspicion or heuristic output as proof of maliciousness.
- Never automatically open inspected destinations or execute QR actions.
- Include or update relevant tests and documentation.
- Preserve existing tests. Do not delete, skip, weaken, or rewrite a test
  merely to make a failing change pass.
- Follow the existing Flutter/Dart conventions and repository structure.

The project uses GitHub Actions for Flutter dependency checks, static
analysis, unit/widget tests, and Web release-build validation. Run the
checks applicable to your change and report the exact commands and results.
Do not claim a check passed unless it actually completed successfully.

If the same test or CI strategy fails three consecutive times, stop
repeating that strategy. Investigate the cause and propose a materially
different fix or defer the change; do not weaken or remove the test.

## Pull request expectations

After approval to contribute code, submit a focused pull request that:
- References the issue or approved proposal.
- Explains what changed and why.
- Lists affected modules, platforms, and user-visible behaviour.
- Records tests and validation performed, including failures.
- Includes screenshots or recordings for material UI changes, where useful.
- Notes accessibility, localisation, privacy, and security implications.
- Identifies follow-up work and known limitations.

Keep unrelated formatting, generated files, and dependency upgrades out of
the change unless they are necessary and approved.

## Review and merge

The maintainer reviews proposals and pull requests on a best-effort basis.
There is no guaranteed review or response time. The maintainer may request
changes, ask for additional evidence, defer work, or close a contribution.
Do not merge your own changes into the authoritative branch unless you have
explicit repository permission.

## Questions

Use GitHub issues for non-sensitive project questions. For private matters,
contact the repository owner through
https://github.com/ErTapanJatakia.
