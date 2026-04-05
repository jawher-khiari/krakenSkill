# Kraken Knowledge: Security

## OWASP Top 10:2025

### A01 — Broken Access Control
Restrictions on authenticated users are not properly enforced. Attackers exploit flaws to access unauthorized functions or data. Mitigations: deny by default, enforce server-side ownership checks on every resource, disable directory listing, log access control failures, rate limit API access, invalidate JWT tokens on logout, enforce record-level permissions.

### A02 — Cryptographic Failures
Sensitive data exposed due to weak or missing encryption. Mitigations: classify data by sensitivity, don't store sensitive data unnecessarily, encrypt all data at rest and in transit (TLS 1.2+), use AES-256 for symmetric encryption, RSA ≥2048 or ECC for asymmetric, bcrypt (cost ≥12) or Argon2id for passwords, disable caching for sensitive responses, never use MD5 or SHA1 for passwords.

### A03 — Injection
User-supplied data is sent to an interpreter as part of a command/query. Mitigations: use parameterized queries (never string concatenation for SQL), use ORM properly, validate and sanitize all input, escape special characters for the specific interpreter context, use LIMIT and other SQL controls to prevent mass disclosure.

### A04 — Insecure Design
Missing or ineffective security controls baked into the architecture. Mitigations: establish secure development lifecycle, use threat modeling (STRIDE), define security requirements per feature, use reference architectures, unit and integration test all security flows, segregate tenant/user data at design level.

### A05 — Security Misconfiguration
Default configs, open cloud storage, unnecessary features enabled, verbose errors. Mitigations: repeatable hardening process, minimal platform (no unnecessary features), review and update configurations, use segmented application architecture, send security directives to clients (Security Headers), automated verification of configuration.

### A06 — Vulnerable and Outdated Components
Using components with known vulnerabilities. Mitigations: remove unused dependencies, continuously inventory component versions, monitor CVE databases (NVD), only obtain components from official sources, monitor for unmaintained libraries, use `npm audit`, `pip-audit`, `dotnet list package --vulnerable`.

### A07 — Identification and Authentication Failures
Weak authentication mechanisms. Mitigations: implement MFA, don't ship with default credentials, implement weak password checks against top 10000 list, align password length/complexity policies, harden registration/credential recovery/API paths equally, limit failed login attempts with progressive delays, use server-side session manager with high-entropy session IDs.

### A08 — Software and Data Integrity Failures
Code and infrastructure without integrity verification. Mitigations: use digital signatures to verify software/data from expected source, ensure npm/pip libraries are from trusted registries, use a software supply chain security tool (Dependabot, Snyk), review CI/CD pipeline for access control, ensure unsigned/unencrypted serialized data is not sent to untrusted clients.

### A09 — Security Logging and Monitoring Failures
Insufficient logging for detection and response. Mitigations: log all login, access control, and server-side input validation failures with sufficient context, format logs for easy consumption by log management solutions, ensure high-value transactions have audit trail with integrity controls, establish effective monitoring and alerting, never log sensitive data (passwords, tokens, PII).

### A10 — Server-Side Request Forgery (SSRF)
Application fetches remote resources without validating user-supplied URLs. Mitigations: sanitize and validate all client-supplied input data, enforce URL schema/port/destination with a positive allow list, disable HTTP redirections, don't deploy raw responses to clients, use network segmentation to limit SSRF impact.

## The Nine Security Passes

### Pass 1: Injection
Check every point where user input touches a query, command, or interpreter. Verify parameterized queries. Check for template injection, LDAP injection, OS command injection, XPath injection.

### Pass 2: Authentication
Verify all authentication paths: login, registration, password reset, token refresh, MFA, API keys. Check session management: secure cookie flags (HttpOnly, Secure, SameSite), session expiration, rotation on privilege change.

### Pass 3: Authorization (IDOR)
For every endpoint that accesses a resource: does the server verify the requesting user owns/has permission for that specific resource? Check: can user A access user B's data by changing an ID parameter? Are role checks server-side, not client-side?

### Pass 4: Data Exposure
Review every API response: does it include only the fields the client needs? Check for: full database objects in responses, stack traces in errors, internal IDs exposed, sensitive data in URLs/query params, sensitive data in client-side storage.

### Pass 5: Rate Limiting
Every public endpoint needs rate limiting. Auth endpoints need aggressive limits. Check: brute force login protection, API abuse prevention, file upload size limits, pagination limits, query complexity limits (GraphQL).

### Pass 6: Dependency Risk
Run dependency audit: `npm audit`, `pip-audit`, `dotnet list package --vulnerable`. Check license compatibility. Verify no dependency has known critical/high CVEs. Check for typosquatting in package names.

### Pass 7: State Manipulation
Identify all state machines (order status, user lifecycle, payment flow). Verify: can states be skipped? Can state transitions be replayed? Are race conditions possible? Is optimistic locking used where needed?

### Pass 8: Cryptographic
Verify: TLS 1.2+ for all transport, AES-256 for encryption at rest, RSA ≥2048 or ECC for asymmetric, bcrypt cost ≥12 or Argon2id for password hashing, CSPRNG for all random values (tokens, IDs), no hard-coded secrets, secrets in environment variables or vault.

### Pass 9: Logging & Monitoring
Verify: all auth events logged (login, logout, failed attempts), access control failures logged, no PII/passwords/tokens in logs, logs include timestamp + user ID + IP + action, log integrity protected (append-only or signed), alerts configured for anomalous patterns.

## Threat Classification

### Finding Priority Levels

| Priority | Definition | Action | SLA |
|---|---|---|---|
| 🔴 Critical | Exploitable now, data breach risk, auth bypass | Block ship. Fix immediately. | Before merge |
| 🟠 High | Exploitable with effort, privilege escalation | Fix before merge | Before merge |
| 🟡 Medium | Defense-in-depth gap, low exploitability | Fix this sprint | This sprint |
| 🟢 Low | Best practice deviation, hardening | Track and schedule | Backlog |

### Root Cause Analysis Pattern (for every ❌ FAIL finding)

When a security pass fails, analyze using this 3-step pattern:

**1. Root Cause:** WHY does this vulnerability exist?
- Is it a design flaw (wrong architecture choice)?
- Is it an implementation bug (forgot to validate)?
- Is it a configuration gap (default settings)?
- Is it a missing requirement (nobody asked for it)?

**2. Fix:** Concrete before/after code with explanation of why the fix resolves the root cause, not just the symptom.

**3. Prevention:** What practice prevents this CLASS of vulnerability in the future?
- Add to validation middleware? Add to code review checklist?
- Add an automated test? Add a linter rule?
- Change the default configuration? Update the template?

### Data Sensitivity Levels
- Public: marketing content, public APIs — LOW threat
- Internal: employee data, internal tools — MEDIUM threat
- Confidential: customer PII, financial data — HIGH threat
- Restricted: payment card data, health records, credentials — CRITICAL threat

### Threat Level Routing
- LOW: Run passes 1 (Injection), 4 (Data Exposure), 6 (Dependencies) only
- MEDIUM: Run all 9 passes at standard depth
- HIGH: All 9 passes with attack scenario narratives
- CRITICAL: All 9 passes with full penetration test methodology
