# Kraken Knowledge: Code Patterns & Quality

## Code Quality Thresholds — ENFORCED

| Rule | Threshold | Violation Response |
|---|---|---|
| Function length | ≤20 lines | Extract function immediately |
| File length | ≤200 lines | Split into modules |
| Nesting depth | ≤3 levels | Use early returns / guard clauses |
| Magic values | 0 allowed | Extract to named constants |
| Commented-out code | 0 allowed | Delete it. Git has history. |
| TODO without ticket | 0 allowed | Fix it now or create the ticket |
| Error handling | Every function | Must answer: "what happens when this fails?" |
| Naming | Intent-revealing | If you can't name it clearly, you don't understand it |
| Parameters per function | ≤4 | Use parameter object pattern |
| Return types | Always explicit | No implicit any/unknown |

## Design Patterns Reference

### Creational Patterns
- **Factory Method**: Use when object creation logic is complex or varies by type. Creates objects without specifying exact class. Return type is the interface, not the concrete class.
- **Builder**: Use for objects with many optional parameters. Avoids telescoping constructors. Chain methods for fluent API.
- **Singleton**: Use sparingly — only for true system-wide concerns (logger, config). Prefer dependency injection.

### Structural Patterns
- **Adapter**: Convert interface of existing class to match what client expects. Use when integrating third-party libraries.
- **Decorator**: Add behavior to objects dynamically without subclassing. Stack decorators for composable behavior (logging + caching + validation).
- **Repository**: Abstract data access behind a collection-like interface. Never let business logic know about the database.

### Behavioral Patterns
- **Strategy**: Encapsulate algorithms behind an interface, swap at runtime. Use when if/else chains select different behaviors.
- **Observer**: Decouple event producers from consumers. Use for cross-cutting concerns (audit, notification).
- **Command**: Encapsulate a request as an object. Use for undo/redo, queuing, logging actions.
- **Middleware/Pipeline**: Chain handlers that each process and pass along. Use for request processing, validation chains, data transformation.

### Architectural Patterns
- **Clean Architecture**: Dependencies point inward. Domain layer has zero external dependencies. Use cases orchestrate, don't implement.
- **CQRS**: Separate read models from write models when read/write patterns differ significantly. Don't use for simple CRUD.
- **Event Sourcing**: Store state changes as events, not current state. Use when audit trail is critical. High complexity cost — justify carefully.
- **Vertical Slice**: Organize by feature, not by layer. Each feature owns its entire stack from UI to data access.

## Naming Conventions

### Functions/Methods
- Verb + noun: `createUser`, `validateEmail`, `calculateTotal`
- Boolean returns: `isValid`, `hasPermission`, `canDelete`
- Async: same name, let the type system indicate async (no `Async` suffix)
- Event handlers: `onSubmit`, `handleClick`, `processPayment`
- Transformers: `toDTO`, `fromEntity`, `parseConfig`

### Variables
- Descriptive over short: `userEmail` not `ue`, `remainingAttempts` not `ra`
- Collections: plural noun: `users`, `orderItems`, `validationErrors`
- Booleans: `isActive`, `hasErrors`, `shouldRetry`
- Constants: SCREAMING_SNAKE_CASE: `MAX_RETRY_ATTEMPTS`, `DEFAULT_PAGE_SIZE`

### Files
- Match primary export: `UserService.ts` exports `UserService`
- One concept per file: don't put `UserService` and `OrderService` in the same file
- Test files: `UserService.test.ts` or `UserService.spec.ts`

## Error Handling Patterns

### Guard Clause Pattern
```
function processOrder(order) {
  if (!order) throw new InvalidArgumentError('Order is required');
  if (!order.items.length) throw new EmptyOrderError('Order has no items');
  if (order.status !== 'pending') throw new InvalidStateError('Order must be pending');
  // Happy path continues at indent level 0
  return calculateTotal(order.items);
}
```

### Result Pattern (instead of exceptions for expected failures)
```
type Result<T, E> = { ok: true; value: T } | { ok: false; error: E };
function parseEmail(input: string): Result<Email, ValidationError> { ... }
```

### Error Hierarchy
- ValidationError: Client can fix and retry (400)
- NotFoundError: Resource doesn't exist (404)
- AuthorizationError: Not permitted (403)
- ConflictError: State conflict (409)
- InternalError: Server fault, client cannot fix (500)

## Implementation Order (per slice)

1. Types/Models/Interfaces — define the shape of data
2. Data access layer — repository/DAL pattern
3. Validation schemas — input validation at boundary
4. Business logic — pure functions, no I/O
5. API/Controller layer — thin, delegates to business logic
6. Tests at EACH layer — unit tests alongside implementation
7. UI components — built last, consuming API layer
8. Integration/E2E tests — verify the full slice end-to-end
