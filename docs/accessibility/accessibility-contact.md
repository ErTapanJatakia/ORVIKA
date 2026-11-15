# Accessibility contact — no CAPTCHA

The accessibility contact route is intentionally static and friction-free. It does not use Cloudflare Turnstile, a server-side contact endpoint, an account, or a verification challenge.

## Contact route

- The hosted Accessibility Statement page contains direct mailto links.
- The Flutter Accessibility Statement exposes the same contact addresses as selectable text.
- The browser or device email application handles message composition and delivery.
- ORVIKA does not receive or store accessibility reports through an application API.

## Privacy and abuse trade-off

Because the contact addresses are visible in public application assets, they may be collected by automated email harvesters and receive spam. This is the deliberate trade-off for removing CAPTCHA and server-side disclosure. Use mailbox-provider spam filtering; do not add a CAPTCHA gate back to accessibility feedback.

## Security and accessibility status

- No Cloudflare Turnstile site key or secret is required.
- No Cloudflare Pages Function or contact API is required.
- Static routes remain GET/HEAD only.
- The visible Accessibility badge identifies the statement and feedback route; it is not a WCAG conformance or certification badge.
- ORVIKA makes no claim of full WCAG 2.2 AA conformance.
