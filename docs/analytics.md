# ORVIKA Web Analytics

## Architecture

ORVIKA is a Flutter Web single-page application. This integration uses
Vercel's framework-independent Web Analytics script from `web/index.html`.
It does not use the Next.js `<Analytics />` component or add a JavaScript
package to the Flutter dependency graph.

Analytics remains disabled until the project's Vercel-specific script path is
configured. Local development and preview builds therefore do not silently
send traffic to the production analytics project.

## Enablement

1. Open the ORVIKA project in the Vercel dashboard.
2. Open **Analytics** and enable **Web Analytics** for the project.
3. Copy the project-specific static-site script path supplied by Vercel. It
   should have the form `/<unique-path>/script.js`.
4. Set that exact path as the content of the
   `meta[name="vercel-analytics-script"]` element in `web/index.html`.
   Keep it same-origin; do not guess a generic path.
5. Deploy to production, visit ORVIKA, and verify requests to the configured
   script path and Vercel page-view endpoint in the browser Network panel.
6. Confirm page-view data appears in the Vercel project's Analytics view.

The repository cannot enable the dashboard feature or retrieve the
project-specific path. Those steps require the project owner's Vercel access.

## Instrumentation

- Vercel page views provide baseline website traffic metrics.
- `module_opened` is emitted when a visitor opens one of the seven allowlisted
  ORVIKA modules. Its only property is the fixed module label.
- ORVIKA does not send lesson identifiers, playbook choices, submitted
  content, security-analysis results, threat classifications or user IDs.

Vercel currently documents custom events as available on Pro and Enterprise
plans. Page views are available on all plans. If the project is on a plan
without custom-event support, the module events will not be available in the
dashboard; confirm plan entitlement before relying on them.

## Data minimisation

- Never send user-entered URLs, message text, decoded QR content, credentials,
  personal identifiers or security-analysis findings.
- The Dart API accepts only fixed event methods and allowlisted module labels.
- The browser bridge independently validates the event name and module.
- The Vercel `beforeSend` hook strips query strings and URL fragments from
  page-view URLs.
- The integration is separate from ORVIKA's on-device analysis and local
  learning-progress storage.
- ORVIKA adds no cookies, local tracking identifiers, fingerprinting code or
  custom user IDs.

Vercel describes Web Analytics as cookie-free and based on an anonymized
visitor hash that expires after 24 hours. See
[Vercel's privacy documentation](https://vercel.com/docs/analytics/privacy-policy).

## Validation

Repository CI runs Flutter analysis, tests and a Web release build. The
Android build workflow is not part of this feature's validation. A successful
CI run does not prove that the Vercel dashboard is enabled or that production
analytics data is arriving; verify those separately after configuring the
project-specific script path.
