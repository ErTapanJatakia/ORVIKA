# Privacy and offline data-flow audit

Status: source-reviewed baseline with automated input-persistence regression tests  
Scope: Flutter Web/Android application code on the current `main` baseline

## Security-analysis input lifecycle

The Link, QR and Message screens each own a `TextEditingController` and retain their analysis result in widget state. Their submit handlers call the corresponding deterministic domain analyzer directly. The controllers are disposed with their screens.

The Link, QR and Message presentation/domain paths reviewed for this batch do not call `SharedPreferences`, perform HTTP requests, or invoke analytics APIs. The analysis result and entered content remain in the active screen state; this is not a claim about operating-system memory, browser extensions, crash dumps, screenshots, or third-party platform behaviour.

## Local persistence inventory

The current `SharedPreferences` writes reviewed in `lib/main.dart` are limited to:
- appearance theme, language and language catalogue;
- onboarding completion;
- accessibility text scale, bold text and reduced-motion preferences.

The Academy screen stores completed lesson identifiers under `academy.completed.v1`. The Privacy screen stores reviewed checklist identifiers under `privacy.reviewed.v1`.

These values represent app preferences or progress markers. The inspected write paths do not store submitted URLs, decoded QR payloads, message text, credentials or security-analysis findings.

## Analytics boundary

The Vercel integration remains a static page-view-only integration as documented in [analytics.md](analytics.md). This audit does not add events, route instrumentation, user identifiers or security-analysis telemetry. The existing production Network-tab and dashboard verification remains the evidence for deployment-level analytics operation.

## Automated regression coverage

`test/privacy_data_isolation_test.dart` exercises the actual Link, QR and Message screens with distinctive sensitive test inputs, submits each analysis, and asserts that the mocked `SharedPreferences` store remains empty.

This test proves only that these screen flows do not write to the SharedPreferences interface under test. It does not prove the absence of all possible filesystem, browser, operating-system, crash-reporting, extension, or network side channels. The repository-level source review and production/manual checks remain separate evidence.

## Offline boundary

The reviewed URL, QR and message analyzers are deterministic local code paths. The threat-intelligence assessment engine and curated intelligence library are local reference/assessment logic; source URI fields are descriptive metadata and are not fetched by the assessment domain layer. No live reputation lookup, DNS resolution, redirect following, or remote feed ingestion is implied by these modules.

This is a source-level architecture statement, not a packet-capture claim. Platform-level network validation must be performed separately on supported browsers and devices before making a comprehensive offline-conformance claim.

## Guardrails

- Do not persist security-analysis inputs or findings for convenience.
- Do not pass user-entered content or findings to Vercel Analytics.
- Keep analytics separate from security analysis.
- Preserve deterministic local analysis and explicit uncertainty.
- Do not describe this source audit or its widget tests as proof of total network isolation or complete privacy certification.
