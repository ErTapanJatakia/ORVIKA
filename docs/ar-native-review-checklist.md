# Arabic (Modern Standard Arabic) Native-Speaker Review Checklist

## Review status

- Locale: `ar` — Modern Standard Arabic (العربية الفصحى)
- Implementation branch: `localization/arabic-full-feature-rtl`
- Pull request: [#99](https://github.com/ErTapanJatakia/ORVIKA/pull/99)
- Translation status: native-speaker review completed and approved (confirmed by project maintainer)
- Reviewer identity: not recorded in this repository
- Review date: 2026-11-13
- RTL and accessibility checklist: completed and approved by project maintainer

## Review scope

Please review the complete in-app Arabic experience, not only the language picker:

- Onboarding, dashboard, navigation, settings, themes and accessibility controls
- Link Check, QR Check and Message Check: headings, instructions, input labels, notices, errors and all result findings
- QR camera flow: permission request/denial, unavailable camera, preview failure, scanning and stop controls
- QR image flow: selection, preview, oversized/empty image, no-code and decode errors, privacy notice
- Academy: all 8 lessons, key points, questions, options and explanations
- Privacy: all 12 practices, rationale, recommended action and limitations
- Response: all 5 playbooks, steps, evidence preservation, cautions and limitations
- Intelligence: all 10 references, signals, meanings, recommended actions and limitations
- Progress announcements, semantic labels, reset confirmations and framework-owned Material controls

## Terminology consistency

Please check that the following terms are natural, consistent and technically precise in context:

| Concept | Preferred Arabic wording |
|---|---|
| Cybersecurity | الأمن السيبراني |
| Digital safety | السلامة الرقمية |
| Privacy | الخصوصية |
| Account compromise | اختراق الحساب |
| Phishing | التصيّد الاحتيالي |
| Social engineering | الهندسة الاجتماعية |
| Multi-factor authentication | المصادقة متعددة العوامل |
| One-time password (OTP) | كلمة مرور لمرة واحدة |
| Recovery code | رمز الاسترداد |
| Passkey | مفتاح مرور |
| Security key | مفتاح أمان |
| QR code | رمز QR |
| URL / web address | عنوان URL / عنوان ويب |
| Registered domain | النطاق المسجّل |
| Hostname | اسم المضيف |
| Subdomain | نطاق فرعي |
| Punycode | Punycode |
| Malware | برمجية ضارة |
| Incident response | الاستجابة للحوادث |
| Severity / warning | مستوى الخطورة / تحذير |

The reviewer may replace these suggestions where a more established Arabic cybersecurity term is preferable. Preserve distinctions between suspicion, an observed indicator and confirmed malicious activity.

## Safety and meaning checks

- Do not strengthen heuristic findings into claims that fraud, compromise or malicious intent is confirmed.
- Preserve every limitation and privacy statement; do not imply network, reputation, malware or identity checks that the product does not perform.
- Preserve all numbers, technical identifiers, examples, placeholders and procedural order.
- Confirm that the correct Academy answer remains the correct answer after translation.
- Confirm that translated instructions do not introduce unsafe payment, account-recovery or evidence-handling advice.
- Ensure that no English fallback remains in the Arabic experience, except intentional technical terms, product names and code examples.

## RTL and typography review

Review on a real Android device and a desktop browser where possible:

- 320 px narrow viewport and common phone widths
- 200% text scaling and bold-text accessibility setting
- Both light and dark themes
- Arabic paragraphs mixed with Latin URLs, email addresses, phone numbers, IP addresses, ports, hashes, code, OTP and product names
- Cursor movement and selection in URL, QR and message input fields
- Correct visual order of icons, leading/trailing controls, back navigation, progress indicators and buttons
- No clipped Arabic glyphs, disconnected letter shaping, awkward line breaks or punctuation reversal
- Screen-reader reading order and announcements for progress, errors, severity and dialogs

## Approval

## Review outcome
The project maintainer has confirmed that the native-speaker review and this checklist are complete, and has explicitly approved the Arabic localization for promotion. No reviewer identity is published in this repository. The consolidated automated validation must still pass before the locale is promoted and merged.
