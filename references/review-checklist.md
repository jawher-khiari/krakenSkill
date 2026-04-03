# Code Review Checklist — 50-Point Protocol + Complexity Thresholds

Load this file during **Phase 8: REVIEW**.

---

## Table of Contents
1. [Pre-Review Automated Gates](#pre-review-automated-gates)
2. [The 50-Point Human Review Protocol](#50-point-protocol)
3. [Complexity Thresholds](#complexity-thresholds)
4. [SOLID Verification Checklist](#solid-verification)
5. [Code Smell Detection](#code-smells)
6. [Review Anti-Patterns to Avoid](#review-anti-patterns)

---

## Pre-Review Automated Gates

Before ANY human review, verify these automated checks pass:

- [ ] Build compiles without errors
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] Linter: zero warnings (ESLint, Pylint, StyleCop, etc.)
- [ ] Static analysis quality gate passed (SonarQube/CodeClimate)
- [ ] SAST scan: no new critical findings (Semgrep/CodeQL)
- [ ] SCA: no new vulnerable dependencies (Snyk/Dependabot)
- [ ] Secrets detection: clean (Gitleaks/GitGuardian)
- [ ] Code coverage: meets threshold (≥80% new code)
- [ ] PR size: ≤400 lines changed (defect detection drops dramatically beyond this)

---

## 50-Point Human Review Protocol

### Design & Architecture (Points 1-8)

1. [ ] **Architecture fit** — Change fits the system's architectural pattern
2. [ ] **Abstraction level** — Not too abstract (gold plating) or too concrete (hardcoded)
3. [ ] **SOLID compliance** — Passes all 5 SOLID checks (see section below)
4. [ ] **No circular dependencies** — Dependency graph remains acyclic
5. [ ] **Backward compatible** — Existing API contracts preserved or versioned
6. [ ] **Single responsibility** — Each changed class/module has ONE reason to change
7. [ ] **Dependency direction** — Dependencies point inward toward domain/core
8. [ ] **Interface boundaries** — Public API surface is minimal and intentional

### Functionality & Logic (Points 9-18)

9. [ ] **Requirements match** — Code does exactly what the ticket/requirement specifies
10. [ ] **Edge case: null/undefined** — All nullable values handled explicitly
11. [ ] **Edge case: empty collections** — Empty arrays/lists don't cause errors
12. [ ] **Edge case: boundary values** — Min/max/zero/negative handled correctly
13. [ ] **Edge case: concurrent access** — Race conditions prevented (locks, transactions, optimistic concurrency)
14. [ ] **Off-by-one errors** — Loop bounds, array indices, pagination offsets verified
15. [ ] **Error paths** — Every operation that can fail HAS error handling
16. [ ] **Failure mode** — System fails CLOSED (denies access) not OPEN (allows access)
17. [ ] **Type safety** — Types match across boundaries (API ↔ Service ↔ DB)
18. [ ] **State transitions** — Invalid state transitions impossible (state machine correctness)

### Readability (Points 19-26)

19. [ ] **Self-documenting** — Code understandable without PR description or author explanation
20. [ ] **Function length** — Every function ≤20 lines (25 max with justification)
21. [ ] **File length** — Every file ≤200 lines (300 max with justification)
22. [ ] **Nesting depth** — Maximum 3 levels. Use early returns to flatten.
23. [ ] **No magic numbers/strings** — Every literal is a named constant or enum
24. [ ] **Comments explain WHY** — Not what. Code explains what. Comments explain intent.
25. [ ] **Dead code removed** — No commented-out code. No unreachable branches.
26. [ ] **Naming reveals intent** — Can determine function purpose from name alone

### Testing (Points 27-34)

27. [ ] **Happy path tested** — Primary use case has test coverage
28. [ ] **Error path tested** — Error/exception scenarios have dedicated tests
29. [ ] **Edge cases tested** — Null, empty, boundary, concurrent — each has a test
30. [ ] **Tests independent** — No test depends on another test's execution or ordering
31. [ ] **No over-mocking** — Mock ONLY external boundaries (DB, HTTP, filesystem). Test real logic.
32. [ ] **Assertions meaningful** — Tests assert specific expected values, not just `assertTrue(result != null)`
33. [ ] **Test naming clear** — `should_[expected]_when_[condition]` or project convention
34. [ ] **No flaky tests** — Fixed clocks, seeded randomness, deterministic data

### Performance (Points 35-40)

35. [ ] **No N+1 queries** — Verify with query logging. Use eager loading or DataLoader.
36. [ ] **No allocations in loops** — Objects, strings, collections created outside loops
37. [ ] **Indexes exist** — New queries have supporting database indexes
38. [ ] **Pagination present** — No unbounded result sets. Cursor for >100K rows.
39. [ ] **Caching appropriate** — Read-heavy data cached. Cache invalidation correct.
40. [ ] **Async/await correct** — No blocking calls on async paths. No fire-and-forget without error handling.

### Security (Points 41-46)

41. [ ] **Input validated** — All user input validated at the boundary (type, length, range, format)
42. [ ] **Queries parameterized** — No string interpolation in any database query
43. [ ] **No hardcoded secrets** — No API keys, passwords, tokens, connection strings in code
44. [ ] **Auth enforced** — Every endpoint has authentication check
45. [ ] **Authz enforced** — Every data access verifies the requesting user's permission
46. [ ] **Output encoded** — HTML/JS/URL/CSS context-appropriate encoding for all output

### Documentation & Operations (Points 47-50)

47. [ ] **PR description clear** — Reviewer can understand the change without reading code first
48. [ ] **API docs updated** — New/changed endpoints documented (OpenAPI/Swagger)
49. [ ] **Config changes documented** — New env vars, feature flags, settings listed
50. [ ] **Rollback plan exists** — For non-trivial changes, documented reversal procedure

---

## Complexity Thresholds

### Cyclomatic Complexity (paths through code — measures testability)
| Level | Threshold | Action |
|---|---|---|
| Ideal (new code) | ≤5 | Ship it |
| Acceptable | 6-10 | Ship with review |
| Warning | 11-20 | Refactor recommended |
| **MANDATORY REFACTOR** | >20 | **Block merge. Refactor before proceeding.** |

### Cognitive Complexity (human comprehension — SonarQube metric)
| Level | Threshold | Action |
|---|---|---|
| Ideal (new code) | ≤10 | Ship it |
| Acceptable | 11-15 | Ship with review |
| **MANDATORY REFACTOR** | >15 | **Block merge. Refactor before proceeding.** |

**Key difference:** Nesting increases cognitive complexity but not cyclomatic.
A switch with 5 cases: cyclomatic=5, cognitive=1.
A 3-level nested if/else: cyclomatic=3, cognitive≥6.

### How to reduce complexity
1. **Extract Function** — Group and name code fragments
2. **Guard Clauses** — Replace nested if/else with early returns
3. **Lookup Maps** — Replace switch/if chains with object/dictionary lookup
4. **Polymorphism** — Replace type-checking conditionals with subtypes
5. **Decompose Conditional** — Extract complex booleans into named functions
6. **Parameter Object** — Collapse 3+ parameters into a single typed object

---

## SOLID Verification Checklist

### S — Single Responsibility
- [ ] Class describable without "and" or "or"
- [ ] Class has ONE reason to change
- [ ] ≤200 lines per class
- [ ] All methods relate to the same domain concept

### O — Open/Closed
- [ ] New behavior added via new classes, not modifying existing ones
- [ ] Extension points use interfaces or abstract classes
- [ ] No cascading if/else or switch for adding new types

### L — Liskov Substitution
- [ ] Subtypes can replace parent types without breaking behavior
- [ ] No `instanceof` / `is` checks for type-specific behavior
- [ ] No `NotImplementedException` or empty override methods

### I — Interface Segregation
- [ ] Interfaces have ≤5 methods
- [ ] No class forced to implement methods it doesn't use
- [ ] Interfaces are role-based (IReadable, IWritable) not entity-based (IUserEverything)

### D — Dependency Inversion
- [ ] Constructor injection for all dependencies
- [ ] No `new` for services inside business logic
- [ ] All dependencies are mockable through interfaces
- [ ] High-level modules don't depend on low-level modules — both depend on abstractions

---

## Code Smells

| Smell | Detection | Remedy |
|---|---|---|
| **Long Method** | >20 lines | Extract Function |
| **Large Class** | >200 lines | Extract Class, Split by responsibility |
| **Primitive Obsession** | Strings/ints used instead of types | Replace Data Value with Object |
| **Long Parameter List** | >3 parameters | Introduce Parameter Object |
| **Feature Envy** | Method uses another class's data more than its own | Move Method |
| **Shotgun Surgery** | One change requires editing many classes | Move Method, Inline Class |
| **Divergent Change** | One class changed for multiple unrelated reasons | Extract Class |
| **Data Clumps** | Same group of variables appears together repeatedly | Extract Class |
| **Dead Code** | Unreachable code, unused variables, commented-out code | Delete it. Git is your backup. |
| **Speculative Generality** | Abstractions for hypothetical future needs | Remove until actually needed (YAGNI) |
| **Message Chains** | `a.getB().getC().getD()` | Hide Delegate, extract method |
| **God Class** | Class that knows/does too much | Extract multiple focused classes |

---

## Review Anti-Patterns to Avoid

1. **Rubber Stamping** — Approving without reading. Never. Every line gets eyes.
2. **Nit-Picking Gatekeeping** — Blocking on style while ignoring logic bugs. Prioritize correctness.
3. **Massive PR Review** — >400 lines = cognitive overload. Request split. Don't pretend to review 1000 lines.
4. **Review Fatigue** — After 60-90 minutes, take a break. Quality drops with time.
5. **Style Over Substance** — Automated linters handle style. Humans verify logic and design.
6. **Assumption of Correctness** — Don't trust that it works because it looks right. Trace the logic.
7. **Ignoring Tests** — Tests are as important as production code. Review them with equal rigor.
