# Testing Strategy — TDD Workflow + Shapes + Anti-Patterns + Property-Based Testing

Load this file during **Phase 4: PLAN** and **Phase 6: IMPLEMENT**.

---

## Table of Contents
1. [Testing Shape Selection](#testing-shapes)
2. [TDD Workflow](#tdd-workflow)
3. [Test Writing Standards](#test-standards)
4. [Coverage Strategy](#coverage-strategy)
5. [Property-Based Testing](#property-based-testing)
6. [Testing Anti-Patterns (The 15 Deadly Sins)](#anti-patterns)
7. [Mocking Rules](#mocking-rules)
8. [E2E Testing Strategy](#e2e-testing)

---

## Testing Shape Selection

Choose the shape that matches your architecture:

### The Pyramid (70% Unit / 20% Integration / 10% E2E)
**Best for:** Monoliths with heavy business logic, libraries, utilities
**Why:** Unit tests catch logic errors cheaply. Business rules live in pure functions.
```
        /\
       /E2E\        10% — Critical user journeys only
      /------\
     /Integra-\     20% — API + DB + Service interactions
    /  tion    \
   /------------\
  / Unit Tests   \  70% — Business logic, calculations, transforms
 /________________\
```

### The Trophy (Integration-Heavy)
**Best for:** Modern frontend (React, Vue, Angular), full-stack web apps
**Why:** Integration tests catch real user bugs. Kent C. Dodds: "Test the way users use it."
```
     /\
    /E2E\          Few — Smoke tests, critical flows
   /------\
  /Integra-\      BULK — Components + hooks + API calls together
 /  tion    \
 \----------/
  \ Unit   /      Some — Utility functions, complex calculations
   \------/
    Static         TypeScript, ESLint (free, always on)
```

### The Diamond / Honeycomb
**Best for:** Microservices, distributed systems
**Why:** Contract verification between services is critical.
```
      /\
     /E2E\         Few — Cross-service journeys
    /------\
   /Contract\     BULK — Consumer-driven contracts (Pact)
  / Testing  \
  \----------/
   \ Integr /     Medium — Service + DB + queue interactions
    \------/
     \Unit/        Some — Internal logic
      \--/
```

---

## TDD Workflow

### The Red-Green-Refactor Cycle (Kent Beck)

```
1. WRITE TEST LIST — All expected behaviors as bullet points
2. PICK ONE behavior from the list
3. RED — Write a failing test for that behavior
   - Test must fail for the RIGHT reason (not compile error)
   - Test name: should_[expected]_when_[condition]
4. GREEN — Write the SIMPLEST code to pass the test
   - Simplest means simplest. Hardcode if needed. You'll generalize later.
   - No extra logic. No anticipating future tests.
5. REFACTOR — Improve design, all tests stay green
   - Extract functions, remove duplication, improve names
   - Run tests after EVERY change
6. REPEAT — Pick next behavior from list
```

### The Three Laws of TDD (Uncle Bob)
1. Never write production code unless required by a failing test
2. Never write more test than needed to fail (including compile failure)
3. Never write more production code than needed to pass the failing test

### When TDD Shines
- Complex business logic (pricing rules, eligibility checks)
- Financial calculations (tax, interest, currency conversion)
- API contracts (request/response shapes, status codes)
- Data transformations (parsing, formatting, mapping)
- State machines (order lifecycle, workflow engines)
- Algorithms (sorting, searching, graph traversal)

### When TDD is Overkill
- Exploratory prototyping (throw-away code)
- UI layout and styling (visual testing better)
- Simple CRUD with no business rules
- One-off scripts and data migrations
- Third-party API wrapper (integration test better)

---

## Test Writing Standards

### Test Structure — Arrange / Act / Assert (AAA)
```
test('should calculate total with discount when order exceeds threshold', () => {
  // Arrange — Set up test data and dependencies
  const order = createOrder({ items: [...], total: 150 });
  const calculator = new PriceCalculator(discountRules);

  // Act — Execute the behavior under test (ONE action)
  const result = calculator.calculateTotal(order);

  // Assert — Verify the expected outcome
  expect(result.total).toBe(135);      // 10% discount applied
  expect(result.discount).toBe(15);
  expect(result.discountReason).toBe('ORDER_THRESHOLD');
});
```

### Test Naming Convention
```
Pattern: should_[expectedBehavior]_when_[condition]

Examples:
  should_return_user_when_valid_id_provided
  should_throw_not_found_when_user_does_not_exist
  should_apply_discount_when_order_exceeds_100
  should_reject_login_when_password_is_incorrect
  should_retry_three_times_when_external_service_fails
```

### Test Data
- Use **factory functions** (`createUser({ role: 'admin' })`) not raw object literals
- Use **builders** for complex objects (`UserBuilder().withRole('admin').withVerified(true).build()`)
- Fixed seeds for randomized data (`faker.seed(12345)`)
- Fixed dates/times (`jest.useFakeTimers()`, `clock.freeze()`)
- Each test creates its own data — NEVER share mutable state between tests

### Assertion Best Practices
```
// BAD — Weak assertions
expect(result).toBeTruthy();
expect(users.length).toBeGreaterThan(0);
expect(response.status).not.toBe(500);

// GOOD — Specific assertions
expect(result).toEqual({ id: '123', name: 'John', role: 'admin' });
expect(users).toHaveLength(3);
expect(response.status).toBe(201);
expect(response.body).toMatchObject({ id: expect.any(String), name: 'John' });
```

---

## Coverage Strategy

### Branch Coverage Targets
| Code Category | Target | Enforcement |
|---|---|---|
| New code (general) | ≥80% | CI gate (block merge) |
| Critical paths (auth, payments) | ≥90-95% | CI gate (strict) |
| Utility/helper functions | ≥90% | CI gate |
| UI components | ≥70% | Advisory |
| Generated code / config | Excluded | — |

### Coverage Ratcheting
Set CI to fail if coverage drops below the CURRENT baseline. Then gradually tighten.
```yaml
# Example CI config
coverage:
  threshold:
    global:
      branches: 80    # Never drop below this
    new_code:
      branches: 85    # New code held to higher standard
```

### Mutation Testing
Tests that execute code but don't verify behavior are useless. Mutation testing catches them.
- **Stryker** (JS/TS): Introduces code mutations, checks if tests catch them
- **PIT** (Java): Same concept for JVM
- **Infection** (PHP): PHP ecosystem

**Mutation score targets:**
| Score | Quality |
|---|---|
| ≥75% | Strong test suite |
| 60-75% | Acceptable, room for improvement |
| <60% | Tests execute code but don't verify behavior. Improve. |

---

## Property-Based Testing

Instead of testing specific examples, define PROPERTIES that must hold for ALL inputs.

### Key Property Patterns

**Round-trip:** `decode(encode(x)) === x`
```javascript
fc.assert(fc.property(fc.string(), (s) => {
  expect(decode(encode(s))).toBe(s);
}));
```

**Idempotent:** `f(f(x)) === f(x)`
```javascript
fc.assert(fc.property(fc.array(fc.integer()), (arr) => {
  expect(sort(sort(arr))).toEqual(sort(arr));
}));
```

**Invariant:** `output always satisfies constraint`
```javascript
fc.assert(fc.property(fc.integer(), fc.integer(), (a, b) => {
  const result = add(a, b);
  expect(result - a).toBe(b);  // Algebraic property
}));
```

**Oracle:** `compare against reference implementation`
```javascript
fc.assert(fc.property(fc.array(fc.integer()), (arr) => {
  expect(mySort(arr)).toEqual([...arr].sort((a, b) => a - b));
}));
```

### Tools
- **fast-check** (JS/TS): `npm install fast-check`
- **Hypothesis** (Python): `pip install hypothesis`
- **FsCheck** (C#): NuGet package
- **QuickCheck** (Haskell): The original

### When to Use
- Serialization/deserialization round-trips
- Mathematical functions and calculations
- Sorting, filtering, data transformation
- Parser/formatter pairs
- Any function with clear algebraic properties

---

## Testing Anti-Patterns (The 15 Deadly Sins)

1. **The Liar** — Test passes but asserts nothing meaningful. `expect(true).toBe(true)`
2. **Excessive Mocking** — Mock everything → test verifies mocks, not behavior
3. **Testing Implementation** — Test breaks when refactoring without behavior change
4. **The Giant** — One test that tests everything (100+ lines)
5. **The Mockery** — More mock setup code than actual test
6. **Chain Gang** — Tests depend on other tests' execution order
7. **The Silent Catcher** — `try { doThing() } catch { /* test passes */ }` — catches wrong errors
8. **The Inspector** — Tests private methods directly. Test public behavior instead.
9. **The Flickering Test** — Passes/fails randomly. Time-dependent, race conditions, shared state.
10. **The Slow Poke** — Unit test takes >1 second. Usually a sign of I/O or missing mocks at boundaries.
11. **The Nitpicker** — Tests irrelevant details (whitespace, property order)
12. **Second Class Citizen** — Test code with no standards (copy-paste, no refactoring)
13. **The Free Ride** — Adding assertions to existing tests instead of writing new ones
14. **Happy Path Addict** — Only tests the sunny day scenario. No errors, edges, nulls.
15. **The Local Hero** — Passes on your machine, fails in CI. Environment-dependent.

---

## Mocking Rules

### Mock ONLY External Boundaries
```
✅ MOCK: Database calls, HTTP requests, filesystem, external APIs, message queues,
         email services, payment gateways, clock/time, random number generators

❌ DON'T MOCK: Your own classes, domain logic, value objects, utility functions,
               data transformations, business rules
```

### The Mockist vs Classicist Spectrum
- **Classicist (London School):** Mock external boundaries only. Use real implementations for everything else.
  Preferred approach — tests verify actual behavior.
- **Mockist (Detroit School):** Mock all collaborators. Tests are isolated.
  Use sparingly — creates fragile tests coupled to implementation.

### Mock Verification Rules
- Verify interactions only when the SIDE EFFECT is the point (email sent, event published)
- For data queries, assert on RETURNED DATA not on "was this method called?"
- Never verify internal method calls between your own classes

---

## E2E Testing Strategy

### Scope — Test Critical User Journeys Only
- User registration → login → core action → logout
- Payment flow (add to cart → checkout → payment → confirmation)
- Admin: create → edit → delete cycle
- Error recovery: failed payment → retry → success

### E2E Test Rules
- ≤20 E2E tests for most applications (maintenance cost is high)
- Each test is independent — full setup and teardown
- Use stable selectors: `data-testid` attributes, not CSS classes or text
- Retry flaky network calls with reasonable timeout
- Run against a dedicated test environment, not production
- Seed database with known state before each test

### Tools
- **Playwright** (recommended): Cross-browser, auto-wait, trace viewer
- **Cypress**: Developer-friendly, time-travel debugging
- **Selenium**: Legacy, widest browser support
