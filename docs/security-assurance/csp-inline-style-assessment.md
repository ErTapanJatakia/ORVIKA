# ORVIKA CSP inline-style assessment

**Status: Open — investigated; no policy change made in this batch.**

## Finding

The passive OWASP ZAP assessment reported the Content Security Policy directive
`style-src 'unsafe-inline'` as a Medium alert. The current policy permits inline
style elements and inline style attributes. This is broader than ideal and is
recorded as a hardening item, not as proof of an exploitable vulnerability.

## Compatibility analysis

ORVIKA is a Flutter Web application. The build uses Flutter's release Web
pipeline with `--csp`, and the application is validated through desktop and
mobile Chromium smoke checks. Flutter's rendered DOM can include dynamically
applied style attributes. A blanket removal of inline styles may therefore
break layout or rendering even when JavaScript continues to load.

CSP Level 3 separates style element and style attribute controls:

- `style-src-elem` controls style elements and stylesheet links.
- `style-src-attr` controls inline style attributes, including values applied
  through `setAttribute('style', ...)` or `cssText`.
- `style-src-attr` is widely supported in modern browsers, but older browsers
  may fall back to `style-src`.

References:
- https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Security-Policy/style-src
- https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Security-Policy/style-src-attr
- https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Security-Policy/style-src-elem
- https://docs.flutter.dev/platform-integration/web

## Decision

Do not remove `'unsafe-inline'` or replace it with a nonce/hash policy until
the actual Flutter output and supported browser matrix have been tested. A
nonce authorizes matching style elements; it does not automatically authorize
arbitrary dynamic style attributes. Hashes are suitable only when the inline
content is stable and known.

A candidate split policy may reduce permission for inline style elements while
retaining the style attributes required by the Flutter renderer. It must first
be tested against the built app in an isolated Cloudflare preview, with desktop
and mobile browser smoke checks and a visual/accessibility review. Firefox
coverage should be added before declaring cross-browser compatibility.

## Acceptance criteria

1. No production or signed Android release changes during experimentation.
2. Flutter app bootstraps and renders without browser runtime errors.
3. Desktop and mobile layouts retain expected rendering and no horizontal overflow.
4. Keyboard and screen-reader interactions remain functional.
5. ZAP output is reviewed after the policy change; a lower alert count alone is
   not sufficient evidence of correctness.
6. Any residual inline-style allowance is explicitly documented with its
   compatibility rationale and review trigger.

**Risk disposition:** Open pending isolated preview validation. No risk acceptance
or claim of full CSP remediation is made by this document.
