# A11Y-10 — WCAG logo and conformance-claim release gate

**Status:** Blocked — do not display a WCAG conformance logo

## Current decision

The WCAG 2.2 AA logo must not appear in the ORVIKA web or Android application, store listing, website, README, press material, or accessibility statement at this stage.

A logo is a conformance claim, not a decorative quality badge or a certification issued by W3C. Automated CI success, a generated statement, or a source-level checklist is insufficient evidence.

## Conditions before any web claim

1. Complete an evaluation of every applicable WCAG 2.2 Level A and AA success criterion for the declared web scope.
2. Test representative pages, states, responsive widths, supported browsers, keyboard-only use, and relevant screen readers.
3. Record evaluation date, methods, tools, assistive technologies, sample pages/states, results, and known limitations.
4. Resolve all failures that prevent the conformance claim; document any non-conforming content accurately.
5. Obtain owner approval of the exact claim and publish the complete accessibility statement with a verified feedback channel.

## Conditions before any Android claim

Evaluate the native Android app independently, using WCAG2ICT guidance where appropriate and Android accessibility requirements. Include TalkBack, Switch Access, platform scaling, orientation, and real-device evidence. A web conformance logo does not certify the Android app.

## Permitted interim wording

“ORVIKA is being developed with WCAG 2.2 Level AA as an accessibility target. Evaluation is in progress; full conformance has not yet been established.”

Do not use “WCAG certified”, “W3C certified”, or equivalent wording.
