# ORVIKA Message Check — detection and limitations

## Purpose

Message Check is a deterministic, on-device triage aid for pasted SMS, email and chat text. It highlights configured social-engineering cues so a user can pause and verify a request. It is not a machine-learning classifier, sender-authentication system, threat-intelligence lookup or fraud verdict.

## Local checks

The current rule set looks for:

- urgency and pressure language;
- credential, sign-in and OTP/authentication-code references;
- payment, transfer, refund and financial-action language;
- unexpected prizes and rewards;
- threats, penalties and consequences;
- claims of authority or impersonation involving banks, government, police, delivery, employers and support teams;
- secrecy and isolation requests;
- remote-access, screen-sharing and application-installation lures;
- requests involving sensitive identity or banking information;
- gift-card, cryptocurrency and voucher payment methods;
- visible web addresses, including separately flagged hxxp/hxxps obfuscation;
- email addresses and phone-number-like contact details.

Some text patterns include English, Hindi and Russian phrases. Coverage is intentionally limited and does not represent complete multilingual detection.

## Output semantics

Each matched pattern creates an explanatory finding with an informational, caution or warning severity. Severity describes the type of cue, not a calibrated probability or confirmed level of danger. Multiple findings can apply to one message.

Visible web addresses and contact details are extracted for display only. ORVIKA does not open URLs, resolve domains, follow redirects, send messages, call phone numbers, verify email addresses or identify the sender. Obfuscated hxxp/hxxps addresses are reported separately and are not silently converted into clickable links.

If no configured cue matches, the result explicitly says that no listed cues were detected; it must not say that the message is safe.

## User guidance

Message Check encourages users not to reply, pay, share authentication codes or install software in response to unsolicited instructions; to verify claims using independently obtained official contact details; and to preserve the original message and sender details if reporting may be necessary.

## Privacy boundary

Message text, extracted addresses and findings remain in the active screen state. The analyzer is synchronous local code. It does not use HTTP, SharedPreferences or analytics. The user can clear the message and its results from the screen. This source-level description does not claim that the operating system, browser, extensions, screenshots or crash diagnostics cannot access device memory.

## Limitations

- Pattern matching can produce false positives and false negatives.
- Attackers can use wording, languages, images, attachments, voice notes or context not covered by the current rule set.
- A detected address or contact detail is not proof of maliciousness.
- A missing finding is not evidence that a message is legitimate.
- No attachment, sender header, domain reputation, DNS, redirect or live threat feed is inspected.
- Native-speaker review and broader multilingual test corpora are required before claiming comprehensive language coverage.

Do not describe Message Check as confirming fraud, authenticating senders, or guaranteeing message safety.