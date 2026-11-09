# Security Policy

## Supported versions

Security fixes are currently developed against the latest code on the `main` branch. ORVIKA is a prototype; no long-term support or response-time SLA is offered.

## Reporting a vulnerability

Please do not disclose suspected vulnerabilities, exploit steps, credentials, personal data or proof-of-concept payloads in a public issue or discussion.

Use the **Report a vulnerability** / private vulnerability reporting option in this repository's GitHub Security tab when it is enabled. If that option is unavailable, contact the repository owner through the GitHub profile and request a private reporting channel before sending technical details.

Include, where safe:
- affected commit, version, platform and browser/OS;
- concise impact and preconditions;
- reproducible steps or a minimal proof of concept;
- logs with secrets, tokens, personal data and real user content removed.

## Scope and handling

Do not access, modify, delete or exfiltrate another person's data. Do not perform denial-of-service testing or test against third-party services without their permission. Stop testing if you encounter real user data.

The project is maintained on a best-effort basis. Please allow reasonable time for triage and coordinated remediation before public disclosure. Acknowledgement, severity classification and a fix timeline are not guaranteed.

## Secrets

Never include credentials, access tokens, signing keys, private certificates or production data in issues, pull requests, commits or screenshots. If a secret is exposed, revoke or rotate it immediately; removing it from the latest commit does not remove it from Git history.
