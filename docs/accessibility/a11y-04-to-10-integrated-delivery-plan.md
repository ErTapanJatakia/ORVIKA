# ORVIKA A11Y-04 to A11Y-10 — Integrated delivery record

**Batch:** A11Y-04 through A11Y-10  
**Implementation branch:** `a11y/04-android-semantics-main`  
**Validation strategy:** One consolidated implementation commit followed by one final CI run  
**Deployment:** Prohibited unless separately authorized

| Workstream | Included deliverable | Evidence / limitation |
|---|---|---|
| A11Y-04 | Android semantics assessment, result-heading semantics, form-control name tests, QR camera preview description and live error announcement | Flutter tests/CI; physical TalkBack and Switch Access still pending |
| A11Y-05 | Visual information alternatives requirements and source inventory | No dedicated map/chart feature identified in current feature inventory; future additions require text/list/table equivalents |
| A11Y-06 | Navigation, forms, onboarding, help and RTL requirements | Existing tests cover selected journeys; full keyboard/AT/device review pending |
| A11Y-07 | Automated regression gate and CI evidence policy | Existing Flutter CI executes accessibility tests; automation is not proof of conformance |
| A11Y-08 | Web and Android manual test protocol and evidence register | Not executed; real-device testing required |
| A11Y-09 | Separate web and Android accessibility statement drafts | Drafts only; owner must add verified feedback channel before publication |
| A11Y-10 | WCAG logo/conformance-claim release gate | Explicitly blocked until independent evaluations pass |

## Acceptance principles

- Preserve existing tests; do not weaken, skip, or delete them to make CI green.
- Keep web and Android evidence separate.
- Distinguish source review, automated regression, manual assistive-technology testing, and formal conformance evaluation.
- No deployment, release signing, logo publication, or conformance claim is included in this batch.
- If a criterion cannot be evaluated in the available environment, mark it pending rather than passing it by assumption.
