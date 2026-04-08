# Kraken API & Interface Design Reference

> Absorbed from [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) — api-and-interface-design skill.

## Core Principles

### 1. Contract-First Design
Define the API contract (types, schemas, OpenAPI spec) BEFORE writing implementation. The contract is the source of truth.

### 2. Hyrum's Law
> "With a sufficient number of users of an API, all observable behaviors of your system will be depended on by somebody."

Every public behavior is a commitment. If it's observable, treat it as part of the API — even if undocumented.

### 3. One-Version Rule
Maintain a single version whenever possible. Multiple versions multiply maintenance cost and create diamond dependency problems. Prefer backward-compatible evolution over versioning.

### 4. Boundary Validation (Three-Tier System)
- **Tier 1 (Boundary):** Validate ALL input at system entry points. Parse, don't validate.
- **Tier 2 (Internal):** Trust validated data within the system. No redundant checks.
- **Tier 3 (External):** Re-validate when crossing system boundaries (calling external APIs, writing to DB).

## API Design Checklist

### Endpoints
- RESTful nouns, not verbs: `/api/tasks` not `/api/createTask`
- Consistent naming conventions across all endpoints
- Every endpoint has typed input and output schemas
- List endpoints support pagination from day one
- New fields are additive and optional (backward compatible)

### Error Handling
- Single consistent error format across all endpoints
- Structured errors: `{ code, message, details? }`
- HTTP status codes used correctly (400 vs 401 vs 403 vs 404 vs 422)
- No stack traces or internal details exposed to clients

### Response Design
- Consistent response envelope (or no envelope — pick one)
- Timestamps in ISO 8601 UTC
- IDs as strings (not numbers) for future-proofing
- Nullable fields explicit in schema
- No different shapes depending on conditions

## Red Flags
- Endpoints returning different shapes conditionally
- Inconsistent error formats across endpoints
- Validation scattered through internal code instead of boundaries
- Breaking changes to existing fields (type changes, removals)
- List endpoints without pagination
- Verbs in REST URLs
- Third-party API responses used without validation
