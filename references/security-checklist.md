# Security Checklist — OWASP Top 10:2025 + STRIDE/DREAD + Shift-Left

Load this file during **Phase 7: SECURITY-AUDIT**.

---

## Table of Contents
1. [OWASP Top 10:2025 Developer Controls](#owasp-top-102025)
2. [STRIDE Threat Modeling](#stride-threat-modeling)
3. [DREAD Risk Scoring](#dread-risk-scoring)
4. [Shift-Left Security Pipeline](#shift-left-pipeline)
5. [Security Headers Checklist](#security-headers)
6. [API Security Checklist](#api-security)
7. [Frontend Security Checklist](#frontend-security)
8. [Database Security Checklist](#database-security)

---

## OWASP Top 10:2025

### A01: Broken Access Control
- [ ] Deny by default — no resource accessible without explicit permission grant
- [ ] Validate permissions SERVER-SIDE on every request (never trust client)
- [ ] Check IDOR: Can user A access user B's data by changing IDs in URL/body?
- [ ] Enforce RBAC/ABAC at service layer, not controller
- [ ] Invalidate sessions completely on logout (server-side session destruction)
- [ ] Disable directory listing on web servers
- [ ] Rate-limit API requests to prevent mass enumeration
- [ ] JWT: Validate issuer, audience, expiration. Check signature algorithm (no `alg: none`)
- [ ] Log access control failures and alert on repeated violations

### A02: Security Misconfiguration
- [ ] Remove all default credentials from frameworks and libraries
- [ ] Disable debug mode, verbose errors, stack traces in production
- [ ] HTTP security headers configured (see Security Headers section)
- [ ] Review Infrastructure-as-Code templates for exposed ports/services
- [ ] Disable unnecessary HTTP methods (TRACE, OPTIONS if not needed)
- [ ] Remove unused features, components, documentation endpoints
- [ ] Automate configuration verification in CI/CD
- [ ] Cloud storage buckets are private by default

### A03: Supply Chain Failures (NEW in 2025 as standalone)
- [ ] Pin ALL dependency versions (exact version, not range)
- [ ] Verify package provenance (npm provenance, sigstore)
- [ ] Run SCA scan on every PR (Snyk, Dependabot, OSV-Scanner)
- [ ] Generate and maintain SBOM (Software Bill of Materials)
- [ ] Review new dependencies before adding: maintenance status, CVE history, download count
- [ ] Monitor for typosquatting and dependency confusion attacks
- [ ] Use lock files (package-lock.json, yarn.lock) and verify integrity hashes
- [ ] AI-SPECIFIC: Verify every AI-suggested package exists in official registry

### A04: Cryptographic Failures
- [ ] Symmetric encryption: AES-256-GCM only. NO AES-ECB, NO DES, NO 3DES
- [ ] Asymmetric: RSA ≥2048 bits or Ed25519. NO RSA-1024
- [ ] TLS 1.2+ enforced. TLS 1.0/1.1 disabled
- [ ] Passwords: bcrypt (cost ≥12) or Argon2id. NEVER MD5, SHA-1, SHA-256 alone
- [ ] Keys stored in KMS/Vault/environment, NEVER in source code
- [ ] Generate random values with CSPRNG (crypto.randomBytes, SecureRandom)
- [ ] Don't roll your own crypto. Use established libraries (libsodium, BouncyCastle)
- [ ] Data at rest encrypted for PII and sensitive data
- [ ] Certificate pinning for mobile apps communicating with backend

### A05: Injection
- [ ] Parameterized queries / prepared statements for ALL database operations
- [ ] ORM used correctly (no raw string interpolation in queries)
- [ ] Input validated: type, length, range, format — at the boundary
- [ ] Output encoded for context: HTML entities, JS escaping, URL encoding, CSS escaping
- [ ] OS command injection: avoid `exec()`, `system()`. If unavoidable, strict allowlist
- [ ] LDAP injection: escape special characters in LDAP queries
- [ ] Template injection: avoid user input in template expressions
- [ ] GraphQL: Limit query depth (≤7), complexity scoring, field-level authorization

### A06: Vulnerable and Outdated Components
- [ ] Maintain inventory of all components and their versions
- [ ] Monitor CVE databases continuously (NVD, GitHub Advisory Database)
- [ ] Remove unused dependencies
- [ ] Automated update PRs via Dependabot/Renovate with test verification
- [ ] Subscribe to security advisories for critical dependencies

### A07: Authentication Failures
- [ ] Enforce MFA for all privileged accounts
- [ ] Session tokens: ≥64 bits entropy, regenerate after login
- [ ] Cookie flags: `Secure; HttpOnly; SameSite=Strict`
- [ ] Password policy: minimum 8 chars, check against breached password databases (HaveIBeenPwned API)
- [ ] Account lockout after 5 failed attempts with exponential backoff
- [ ] Password reset: time-limited token (≤1 hour), single-use, notify user
- [ ] No credentials in URL parameters
- [ ] Implement proper logout (invalidate server-side session + clear client tokens)

### A08: Software and Data Integrity Failures
- [ ] Verify integrity of all downloaded code/data (checksums, signatures)
- [ ] CI/CD pipeline secured: signed commits, branch protection, approval requirements
- [ ] Deserialization: avoid deserializing untrusted data. If required, strict type checking
- [ ] Auto-update mechanisms verify signatures before applying updates

### A09: Logging and Monitoring Failures
- [ ] Log ALL authentication events: login, logout, failed attempts, password changes
- [ ] Log format: timestamp, user ID, action, resource, outcome (success/fail), source IP
- [ ] NEVER log: passwords, tokens, credit card numbers, SSNs, or other PII
- [ ] Log integrity: append-only, tamper-evident storage
- [ ] Alerts configured for: multiple failed logins, privilege escalation attempts,
      unusual access patterns, after-hours admin activity
- [ ] Log retention: ≥90 days online, ≥1 year archive (check compliance requirements)

### A10: Mishandling of Exceptional Conditions (NEW in 2025)
- [ ] Every catch block either: recovers, wraps+rethrows with context, or logs meaningfully
- [ ] No empty catch blocks. No `catch (e) {}`
- [ ] Error responses: generic message to user, detailed log server-side
- [ ] Timeouts configured for all external calls (HTTP, DB, queue)
- [ ] Circuit breaker pattern for cascading failure prevention
- [ ] Graceful degradation: system remains partially functional during component failures
- [ ] Resource cleanup in finally blocks (connections, file handles, locks)

---

## STRIDE Threat Modeling

Apply to EVERY element crossing a trust boundary in the data flow diagram.

| Threat | Question | Mitigations |
|---|---|---|
| **Spoofing** | Can an attacker pretend to be someone else? | Authentication, MFA, certificate validation |
| **Tampering** | Can data be modified in transit or at rest? | Integrity checks, HMAC, digital signatures, TLS |
| **Repudiation** | Can a user deny performing an action? | Audit logging, non-repudiation controls, timestamps |
| **Information Disclosure** | Can data leak to unauthorized parties? | Encryption, access controls, data minimization |
| **Denial of Service** | Can the system be overwhelmed? | Rate limiting, input validation, resource quotas |
| **Elevation of Privilege** | Can a user gain unauthorized capabilities? | Least privilege, input validation, sandboxing |

### How to Apply STRIDE
1. Draw the Data Flow Diagram (DFD) with: processes, data stores, external entities, data flows
2. Mark trust boundaries (user→server, server→database, service→service)
3. For EVERY element crossing a trust boundary, ask each STRIDE question
4. Document threats found and their mitigations

---

## DREAD Risk Scoring

Score each threat on 5 dimensions, 1-10 scale. Average = risk rating.

| Dimension | Score 1 (Low) | Score 10 (High) |
|---|---|---|
| **Damage** | Minor inconvenience | Complete system compromise |
| **Reproducibility** | Hard to reproduce, requires specific conditions | 100% reproducible every time |
| **Exploitability** | Requires deep expertise + custom tools | Script kiddie can exploit |
| **Affected Users** | Single user in rare scenario | All users affected |
| **Discoverability** | Buried deep, requires source code access | Visible in URL/public API |

**Risk ratings:**
- Average >7: **CRITICAL** — Fix before shipping. Block the release.
- Average 5-7: **HIGH** — Fix this sprint. Do not defer.
- Average 3-5: **MEDIUM** — Schedule for next sprint.
- Average <3: **LOW** — Add to backlog.

---

## Shift-Left Security Pipeline

| Development Phase | Security Activity | Tools |
|---|---|---|
| **Design** | Threat modeling (STRIDE) | Draw.io, Microsoft Threat Modeling Tool |
| **Coding (IDE)** | Real-time SAST | SonarLint, Semgrep (IDE plugin) |
| **Pre-commit** | Secrets detection | Gitleaks, git-secrets (pre-commit hook) |
| **Pull Request** | Full SAST + SCA + secrets | Semgrep/CodeQL + Snyk/Dependabot + GitGuardian |
| **Staging** | DAST | OWASP ZAP, Burp Suite, Nuclei |
| **Production** | WAF + RASP + monitoring | Cloudflare WAF, Datadog, Sentry |

**Minimum viable security toolchain:** SAST + SCA + Secrets Detection.
Add DAST for runtime coverage on staging/production.

---

## Security Headers

Every HTTP response MUST include:

```
Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self'; connect-src 'self' https://api.yourdomain.com; frame-ancestors 'none'; base-uri 'self'; form-action 'self'
Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=(), payment=()
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Resource-Policy: same-origin
```

---

## API Security Checklist

- [ ] Authentication required for all non-public endpoints
- [ ] Rate limiting on all endpoints (stricter on auth endpoints)
- [ ] Request size limits configured (body, headers, URL)
- [ ] Pagination enforced (never return unbounded result sets)
- [ ] Input validation at API boundary (type, length, range, format)
- [ ] Output filtering: only return fields the user is authorized to see
- [ ] CORS: allowlist specific origins, not `*` in production
- [ ] API versioning strategy implemented
- [ ] Request/response logging (without sensitive data)
- [ ] Idempotency keys for mutation endpoints (prevent double-submit)

---

## Frontend Security Checklist

- [ ] CSP headers prevent inline scripts (no `unsafe-eval`)
- [ ] All user-generated content HTML-escaped before rendering
- [ ] No `dangerouslySetInnerHTML` or `v-html` with user data
- [ ] Forms: CSRF tokens or SameSite cookies
- [ ] Sensitive data not stored in localStorage (use httpOnly cookies)
- [ ] Subresource Integrity (SRI) for CDN scripts
- [ ] No sensitive data in URL query parameters
- [ ] Client-side validation is UX only — server validates everything

---

## Database Security Checklist

- [ ] Parameterized queries only (no string interpolation)
- [ ] Database user has minimum required permissions (no root/admin)
- [ ] Connection strings use environment variables, never hardcoded
- [ ] Connection pool properly sized and connections released
- [ ] Sensitive columns encrypted at rest (PII, financial data)
- [ ] Database backups encrypted and access-controlled
- [ ] Migration scripts reviewed for data exposure risks
- [ ] Audit trail for data mutations on sensitive tables
