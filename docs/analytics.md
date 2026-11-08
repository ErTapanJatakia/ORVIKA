# ORVIKA Web Analytics

## Architecture

ORVIKA is a Flutter Web single-page application hosted on Vercel. The
integration uses Vercel's documented framework-independent static HTML snippet
in `web/index.html`. It does not use the Next.js `<Analytics />` component
or install a JavaScript package into the Flutter project.

The script queue is initialized using Vercel's documented snippet. The script
is loaded only when the exact project-specific static-site path is configured
in the `vercel-analytics-script` meta element. Do not guess or substitute a
generic path.

## Enablement and configuration

1. Web Analytics has been enabled for the ORVIKA Vercel project.
2. Vercel adds its analytics routes after the next deployment.
3. Copy the exact static-site script path shown for this project. It has the
   form `/<unique-path>/script.js`.
4. Set that exact path as the content of the
   `meta[name="vercel-analytics-script"]` element in `web/index.html`.
5. Deploy through the normal approved workflow, visit the production site,
   and verify a Fetch/XHR request to the configured script path and the
   corresponding `/<unique-path>/view` endpoint in the browser Network panel.
6. Confirm page-view data appears in the Vercel project's Analytics view.

The repository cannot retrieve the project-specific path from the Vercel
dashboard. The script remains disabled until the exact path is configured.

## Hobby-plan scope

The project uses Vercel Hobby. The current Web Analytics pricing documentation
includes 50,000 events per month on Hobby, with a one-month reporting window.
Custom events are not included on Hobby; they require Pro or Enterprise.
Accordingly, ORVIKA deliberately implements baseline page-view analytics only.
There is no `module_opened` custom event or claim of feature-level usage
measurement in this release.

Hobby collection is paused if the included event allowance is exceeded; it
does not incur paid event overages. Check the Vercel Usage dashboard for
account-wide event consumption.

## Data minimisation

- Do not send user-entered URLs, message text, decoded QR content, credentials,
  personal identifiers or security-analysis findings.
- The integration is separate from ORVIKA's on-device security analysis and
  local learning-progress storage.
- The static HTML snippet does not add an ORVIKA-specific user ID, cookie,
  local tracking identifier or fingerprinting code.
- Vercel documents page dimensions without query parameters. Do not append
  user-provided content or sensitive values to analytics events.

Vercel describes Web Analytics as cookie-free and uses a visitor hash that
expires after 24 hours. See
[Vercel's privacy documentation](https://vercel.com/docs/analytics/privacy-policy).

## SPA navigation limitation

The static HTML integration automatically tracks the initial page view but
does not provide framework route support. ORVIKA's internal Flutter navigation
therefore must not be represented as independently tracked page views in this
Hobby implementation. We intentionally avoid undocumented manual event calls.

## Validation

Repository CI runs Flutter analysis, tests and a Web release build. Android
build checks are not part of this feature's validation. A successful CI run
does not prove production telemetry is arriving; verify the configured script
request and dashboard data after the exact Vercel path has been added and
deployed.
