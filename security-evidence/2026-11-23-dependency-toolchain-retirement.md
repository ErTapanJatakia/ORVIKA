# ORVIKA Dependency Toolchain Retirement — 23 November 2026

## Decision

Remove the Vercel CLI and Cloudflare Wrangler from the root npm development toolchain because their transitive dependency graphs introduce multiple vulnerable package families. The Flutter application and Android release path remain the product priorities; hosting convenience is not a reason to retain vulnerable tooling.

## Scope

- Remove `vercel` and `wrangler` from root `devDependencies`.
- Retire Vercel and Cloudflare Pages deployment/preview GitHub Actions workflows.
- Preserve Flutter analysis, tests, Web build, edge middleware source checks, source/security/privacy verification, npm audit evidence, and the manually gated Android validation workflow.
- Keep existing hosted resources untouched; this repository change does not delete a Vercel project, Cloudflare account, DNS record, or an already-published deployment.

## Lockfile and audit

The root lockfile was regenerated under the pinned Node 22/npm toolchain after removing the deployment CLIs. The committed lockfile is then validated by a clean `npm ci` in CI; no workflow token is granted write access to regenerate or push dependency changes. The full dependency tree, including optional packages, is subject to `npm audit --audit-level=low`.

## Product and release boundaries

No Flutter application source, security-analysis logic, app permissions, user-facing workflows, Android signing configuration, or store-release configuration is changed by this remediation. Android validation remains deferred until the dependency assurance batch is complete. No production deployment or store publication is performed.

## Completion criteria

1. Lockfile is synchronized with the reduced manifest and reviewed in full.
2. No affected vulnerable package versions remain in the resolved dependency graph.
3. Full npm audit is clean.
4. Edge regression tests, source/security/privacy checks, Flutter analysis/tests, and Web build pass.
5. Every supplied GitHub dependency alert is independently verified closed; no alert is dismissed merely to clear the dashboard.
