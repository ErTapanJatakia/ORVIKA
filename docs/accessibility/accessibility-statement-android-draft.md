# ORVIKA Android Accessibility Statement — Draft

**Publication status:** Draft only — not a conformance claim  
**Evaluation status:** In progress; native Android assistive-technology evaluation is pending  
**Last updated:** 15 November 2026  
**Application ID:** `com.orvika.app`

ORVIKA aims to make its Android application accessible. The engineering target is to apply WCAG 2.2 Level AA principles where applicable to native software, using W3C WCAG2ICT guidance alongside Android platform accessibility guidance.

## Current status

Flutter widget tests cover selected semantics, headings, form labels, progress announcements, locale metadata, responsive layouts, and text scaling. These tests do not prove the Android accessibility node tree or real-world assistive-technology behaviour.

TalkBack, Switch Access, Android system font/display scaling, device orientation, and representative device journeys have not yet been fully validated on physical devices.

## Known evaluation limitations

- Native Android accessibility evaluation is incomplete.
- TalkBack and Switch Access evidence is pending.
- Android platform font and display scaling require physical-device verification.
- WCAG2ICT is interpretive guidance for applying WCAG to non-web software; it is not a separate certification.

## Feedback and contact

**Before publication, the project owner must add and verify a public accessibility feedback channel and a response process.** Do not publish this draft with placeholder contact details.

## Conformance claim

This draft makes no claim of WCAG 2.2 AA conformance or certification. Android must be assessed independently from the ORVIKA website. Publish a conformance statement only after documented native-app evaluation and closure of applicable blocking defects.
