# Turnstile-protected accessibility contact endpoint

This Pages Function returns accessibility contact addresses only after Cloudflare Turnstile Siteverify succeeds.

## Cloudflare Pages environment configuration

In the ORVIKA Pages project, configure **Settings → Variables and Secrets**:

| Name | Type | Value |
| --- | --- | --- |
| `ORVIKA_TURNSTILE_SECRET` | Secret | Secret belonging to the existing Turnstile widget. Never commit or expose it to the browser. |
| `ORVIKA_TURNSTILE_HOSTNAMES` | Variable | `orvika.pages.dev,orvika-web.vercel.app` |
| `ORVIKA_ACCESSIBILITY_CONTACT_EMAILS` | Secret | JSON array containing the two owner-approved email addresses. |

The site key is public and may be used by the browser widget. The widget action must be exactly `contact_reveal`. Production hostnames must not include localhost or 127.0.0.1.

## Endpoint contract

- `POST /api/accessibility-contact`
- Request JSON: `{"turnstileToken":"<single-use token>"}`
- Success JSON: `{"emails":["..."]}`
- Server-side Siteverify must return success=true, action=contact_reveal, and an exact allowlisted hostname.
- Origin is independently checked against the hostname allowlist; CORS is never wildcarded.
- Responses are non-cacheable. Invalid configuration or Siteverify failure fails closed.
- Middleware permits POST/OPTIONS only on this exact path; static routes remain GET/HEAD only.

## Deployment and validation

This change does not deploy the Pages project. After review/merge, configure the three values above and deploy only through the separately authorized release process. Validate using a fresh real widget token and confirm that replay is rejected. Until then, live end-to-end validation remains pending.
