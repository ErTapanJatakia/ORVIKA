# Portugal Portuguese (pt-PT) Native-Speaker Review

## Review status

- Technical implementation and automated web CI: passed on the preceding implementation commit.
- Native-speaker review: pending.
- Release/merge status: not approved until this review is completed.
- This locale is a regional adaptation of the existing Portuguese source pack, not an independently authored translation.

## Reviewer profile

Please use a reviewer who is a native speaker of European Portuguese (Portugal), ideally familiar with consumer cybersecurity, privacy, and digital-safety terminology.

## Scope

Review the complete user-facing experience in the `pt-PT` locale, not just the translation map:

- [ ] Language selector: locale name, selection, persistence, and transition to Home.
- [ ] Core application UI: navigation, dashboard, cards, dialogs, settings, empty states, errors, and notices.
- [ ] Accessibility: labels, help text, bold-text and reduced-motion controls, and text scaling from 50% to 200%.
- [ ] Academy: all 8 lessons.
- [ ] Privacy: all 12 practices.
- [ ] Response: all 5 playbooks.
- [ ] Intelligence: all 10 references.
- [ ] Link Check and Message Check: all 22 finding identifiers, severity labels, explanations, and recommended actions.
- [ ] QR Check: camera permission, scanning, image selection, and all success/error/notice states.
- [ ] Privacy and analytics notices.
- [ ] Narrow layouts (including 320px width), long strings, and enlarged text.

## Linguistic quality criteria

For each screen and content item, check:

1. Natural European Portuguese grammar, spelling, punctuation, and register.
2. Portugal-specific vocabulary and consistent terminology (avoid Brazilian forms where a distinct Portugal usage is expected).
3. Clear, idiomatic cybersecurity and privacy terminology for a general audience.
4. Accurate meaning, risk severity, warnings, and recommended actions; do not soften or exaggerate security advice.
5. Appropriate legal/privacy wording; flag any wording that may require legal review rather than silently rewriting its meaning.
6. Consistent terminology across navigation, help, notices, feature content, and checker results.
7. No truncation, awkward wrapping, inaccessible controls, or untranslated user-facing strings.

## Findings to return

For every issue, provide:

- Screen/feature and exact source string or location.
- Current `pt-PT` wording.
- Recommended Portugal Portuguese wording.
- Reason (grammar, regional usage, clarity, security accuracy, legal concern, or layout).
- Severity: blocker, major, or minor.

Please also report any content that is already correct so that accepted wording is not changed unnecessarily.

## Approval gate

A maintainer should record the reviewer identity/credentials, review date, scope covered, unresolved findings, and explicit approval. Do not set `hasReviewedTranslation` to true or merge/promote `pt-PT` until native-speaker review is complete, all blocker/major findings are resolved, and the resulting regression CI passes.

This checklist does not itself constitute native-speaker approval.
