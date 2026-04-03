# Patterns Catalog — Design Pattern Selection + SOLID + Code Smells + Reusability

Load this file during **Phase 2: BRAINSTORM** when identifying patterns and evaluating approaches.

---

## Table of Contents
1. [Design Pattern Selection Guide](#pattern-selection)
2. [Pattern Implementation Cheat Sheet](#pattern-implementations)
3. [Anti-Patterns to Detect and Eliminate](#anti-patterns)
4. [Reusability Decision Framework](#reusability-framework)
5. [Component Composition Patterns](#component-composition)
6. [API Contract Design](#api-contract-design)
7. [Error Handling Pattern Selection](#error-handling-patterns)

---

## Design Pattern Selection Guide

**Choose patterns based on the FRICTION you're experiencing, not because they're cool.**

| Friction You Feel | Pattern | Use When | Avoid When |
|---|---|---|---|
| Object creation is complex/varies | **Factory** | Polymorphic creation needed, decouple `new` from business logic | Simple creation, single implementation |
| Many conditionals choosing behavior | **Strategy** | Multiple algorithms for same task, behavior switching at runtime | Only one algorithm, unlikely to change |
| Multiple components react to state | **Observer** | Loose coupling needed, event-driven architecture | Ordering matters, few known subscribers |
| Need undo/redo or job queues | **Command** | Delayed execution, audit trails, reversible operations | Simple function calls suffice |
| Incompatible third-party interface | **Adapter** | Integrating legacy code, wrapping external APIs | You control both interfaces |
| Adding cross-cutting behavior | **Decorator** | Logging, caching, validation per instance | Too many layers obscure core behavior |
| Abstracting data access | **Repository** | Decouple domain from storage, testable data layer | Simple CRUD with no domain logic |
| Complex object construction | **Builder** | Many optional params, step-by-step assembly | Object has <5 params, no optional fields |
| Single shared resource | **Singleton** | Config, connection pool, logger | Testing difficulties, hidden dependencies |
| Simplifying complex subsystem | **Facade** | Providing simple API over complex internals | Internal details needed by consumers |
| Ensuring consistent state changes | **State Machine** | Entity with defined states and transitions | Simple boolean flags suffice |
| Processing a chain of handlers | **Chain of Responsibility** | Middleware, validation chains, event handlers | Single handler, no fallback needed |

### Decision Flowchart
```
Problem involves creating objects? ──→ Factory (polymorphic) or Builder (complex assembly)
Problem involves choosing behavior? ──→ Strategy (runtime swap) or Template Method (fixed skeleton)
Problem involves reacting to changes? ──→ Observer (many listeners) or Mediator (coordinated)
Problem involves traversing structures? ──→ Iterator (sequential) or Visitor (operations on nodes)
Problem involves managing state? ──→ State Machine (transitions) or Memento (snapshots)
Problem involves adapting interfaces? ──→ Adapter (existing) or Bridge (planned variation)
Problem involves adding behavior? ──→ Decorator (runtime) or Proxy (access control/lazy)
```

---

## Pattern Implementation Cheat Sheet

### Repository Pattern
```
Interface: IUserRepository
  findById(id): User | null
  findAll(filter): User[]
  save(user): User
  delete(id): void

Implementation: UserRepository implements IUserRepository
  - Encapsulates ALL database access for User entity
  - Service layer NEVER talks to DB directly
  - Returns domain objects, NOT database entities
  - Query building internal to repository
```

### Strategy Pattern
```
Interface: IPricingStrategy
  calculatePrice(order): Money

Implementations:
  RegularPricing implements IPricingStrategy
  PremiumPricing implements IPricingStrategy
  WholesalePricing implements IPricingStrategy

Usage: OrderService(pricingStrategy: IPricingStrategy)
  - Strategy injected, not hard-coded
  - New pricing = new class, no existing code modified
```

### Factory Pattern
```
NotificationFactory.create(type: NotificationType): INotification
  - 'email' → new EmailNotification()
  - 'sms' → new SmsNotification()
  - 'push' → new PushNotification()

Usage: Consumer calls factory, doesn't know concrete types
  - New notification channel = new class + factory entry
  - No switch/if in consumer code
```

### Observer Pattern
```
Interface: IEventHandler<T>
  handle(event: T): void

EventBus:
  subscribe(eventType, handler)
  publish(event)

Usage: OrderService publishes OrderCreated event
  - InventoryHandler reacts: reserve stock
  - NotificationHandler reacts: send confirmation
  - AnalyticsHandler reacts: track conversion
  - Publishers and subscribers don't know about each other
```

---

## Anti-Patterns to Detect and Eliminate

### Structural Anti-Patterns
| Anti-Pattern | Symptom | Fix |
|---|---|---|
| **God Class** | Class >500 lines doing everything | Extract into focused classes by responsibility |
| **Spaghetti Code** | No clear structure, goto-like flow | Introduce layers, extract functions |
| **Lava Flow** | Dead code everyone's afraid to touch | Delete it. Tests catch regressions. Git has history. |
| **Golden Hammer** | Using same tool/pattern for everything | Choose tool by problem, not familiarity |
| **Premature Optimization** | Optimizing without profiling | Measure first. Profile identifies the real bottleneck. |
| **Copy-Paste Programming** | Duplicated blocks with minor variations | Extract shared logic (after Rule of Three) |
| **Inner-Platform Effect** | Rebuilding the framework inside the framework | Use the framework as intended |

### Architecture Anti-Patterns
| Anti-Pattern | Symptom | Fix |
|---|---|---|
| **Distributed Monolith** | Microservices that must deploy together | Identify coupling, establish clear boundaries |
| **Anemic Domain Model** | Entities with only getters/setters, all logic in services | Move behavior into domain objects |
| **Big Ball of Mud** | No discernible architecture | Incremental strangler fig pattern |
| **Circular Dependencies** | A depends on B depends on A | Extract shared interface, invert dependency |
| **Leaky Abstraction** | Implementation details bleed through interface | Redesign interface to hide internals |

---

## Reusability Decision Framework

### The Rule of Three + DRY Flowchart
```
See duplicate code
  └─→ Is it the same KNOWLEDGE (business rule, algorithm)?
      ├─→ NO (just syntactic similarity) → Keep duplicating.
      │   Different concepts evolve independently.
      └─→ YES (same knowledge)
          └─→ How many instances exist?
              ├─→ TWO → Wait. Monitor. Don't abstract yet.
              └─→ THREE or more
                  └─→ Can you NAME the abstraction clearly?
                      ├─→ NO → Keep duplicating until pattern clarifies.
                      └─→ YES
                          └─→ Would abstracting COUPLE things that should be independent?
                              ├─→ YES → Independence trumps DRY. Keep separate.
                              └─→ NO → ✅ Extract the abstraction.
```

### Abstraction Quality Checklist
Before extracting shared code, verify:
- [ ] The abstraction has a clear, specific name (not `utils`, `helpers`, `common`)
- [ ] All consumers use ≥80% of the abstracted functionality
- [ ] The abstraction doesn't require type-checking or branching for different consumers
- [ ] Changing one consumer's needs won't force changes for other consumers
- [ ] The abstraction is simpler than the duplicated code it replaces

### Shared Library Design Rules
1. Minimize public API surface — expose only what consumers need
2. Provide sensible defaults for all optional parameters
3. Follow Semantic Versioning 2.0.0 strictly:
   - MAJOR: breaking changes
   - MINOR: backward-compatible features
   - PATCH: bug fixes only
4. Support N-1 major versions during transitions (6-12 month deprecation)
5. Automated backward-compatibility tests in CI

---

## Component Composition Patterns

### React
**Compound Components** — Components that work together sharing implicit state:
```jsx
<Card>
  <Card.Header>Title</Card.Header>
  <Card.Body>Content</Card.Body>
  <Card.Footer>Actions</Card.Footer>
</Card>
```

**Custom Hooks** — Extract stateful logic for reuse across components:
```jsx
function useDebounce(value, delay) { ... }
function usePagination(fetchFn, pageSize) { ... }
function useLocalStorage(key, initial) { ... }
```

**Render Props / Children as Function** — Delegate rendering to consumer:
```jsx
<DataFetcher url="/api/users">
  {({ data, loading, error }) => loading ? <Spinner /> : <UserList users={data} />}
</DataFetcher>
```

### Angular
**Content Projection** — Multi-slot with CSS selectors:
```html
<card>
  <div card-header>Title</div>
  <div card-body>Content</div>
</card>
```

**Composables (Composition API style)** — Via services + inject:
```typescript
@Injectable() class PaginationService { ... }
// Inject per component instance, not global singleton
```

### General Principles
- Prefer **slots/children** when component provides reusable HTML/CSS skeleton
- Prefer **props** when you need data-driven behavior
- Prefer **hooks/composables** when sharing stateful logic without UI
- Prefer **higher-order components/directives** for cross-cutting concerns

---

## API Contract Design

### REST Best Practices
- Contract-first: Write OpenAPI spec BEFORE implementation
- Resource naming: plural nouns (`/users`, not `/user` or `/getUsers`)
- HTTP verbs: GET (read), POST (create), PUT (full replace), PATCH (partial update), DELETE
- Status codes: 200 (OK), 201 (Created), 204 (No Content), 400 (Bad Request),
  401 (Unauthorized), 403 (Forbidden), 404 (Not Found), 409 (Conflict),
  422 (Validation Error), 429 (Rate Limited), 500 (Server Error)
- Error format: RFC 7807 Problem Details:
  ```json
  {
    "type": "https://api.example.com/errors/validation",
    "title": "Validation Error",
    "status": 422,
    "detail": "Email format is invalid",
    "instance": "/users/123",
    "errors": [{ "field": "email", "message": "Must be valid email" }]
  }
  ```
- Versioning: URI path (`/api/v1/`) for public APIs
- Pagination: include `{ data, meta: { page, perPage, total, totalPages } }` or cursor

### Response Envelope (consistent across all endpoints)
```json
{
  "data": { ... },          // or [...] for collections
  "meta": { ... },          // pagination, timing, request ID
  "errors": [ ... ]         // only present on errors
}
```

---

## Error Handling Pattern Selection

| Pattern | Use When | Stack |
|---|---|---|
| **Exceptions** | Unexpected failures, framework default | C#, Java, Python, JS |
| **Result<T, E>** | Expected failures, functional style | Rust, C# (custom), TS (custom) |
| **Error codes + message** | API responses, inter-service | REST APIs, gRPC |
| **Either/Option monad** | Composable pipelines, no side effects | FP languages, TS (fp-ts) |

### Exception Handling Rules
1. Catch at the boundary (controller/handler), not in business logic
2. Let exceptions bubble through business logic layers
3. Wrap and rethrow with context: `throw new OrderError('Failed to create', { cause: originalError })`
4. Never catch generic Exception and ignore it
5. Custom exception hierarchy: `AppError → DomainError → ValidationError / NotFoundError / AuthError`
6. Global error handler at application boundary: logs, formats response, returns generic message
