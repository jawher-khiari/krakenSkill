# Kraken Knowledge: Review Checklist

## SOLID Principles Assessment

For every review, check each principle:

### S — Single Responsibility
Each class/module has one reason to change. Red flags: class name contains "And", "Manager", "Handler" that does multiple unrelated things, file >200 lines with mixed concerns.

### O — Open/Closed
Open for extension, closed for modification. Red flags: switch/if-else that must be modified every time a new type is added, instead of polymorphism or strategy pattern.

### L — Liskov Substitution
Subtypes must be substitutable for their base types. Red flags: subclass that throws NotImplementedException, conditional logic checking concrete type.

### I — Interface Segregation
No client should depend on methods it doesn't use. Red flags: interface with 10+ methods where most implementors leave half empty, "fat" interfaces.

### D — Dependency Inversion
Depend on abstractions, not concretions. Red flags: `new ConcreteService()` inside business logic, direct database calls in controllers.

## Code Smell Catalog

| Smell | Detection | Fix |
|---|---|---|
| Long Method | Function >20 lines | Extract Method |
| God Class | Class >200 lines, >5 responsibilities | Extract Class by responsibility |
| Feature Envy | Method uses another class's data more than its own | Move Method to the data's class |
| Data Clumps | Same 3+ params travel together | Introduce Parameter Object |
| Primitive Obsession | Using strings/ints for domain concepts | Create value objects (Email, Money) |
| Shotgun Surgery | One change requires editing 5+ files | Consolidate related logic |
| Divergent Change | One class changed for unrelated reasons | Split by reason for change |
| Dead Code | Unused functions, unreachable branches | Delete. Git remembers. |
| Comment Deodorant | Comment explains confusing code | Rewrite the code to be self-documenting |

## Positive Aspects — What to Look For

Every review MUST note strengths:
- Good naming that reveals intent without comments
- Clean separation of concerns between modules
- Effective use of design patterns that simplify the code
- Thorough error handling with specific error types
- Tests that document expected behavior clearly
- Consistent adherence to project conventions

## Seven Review Passes

### Pass 1: Architecture
- Does the implementation match the approved design approach?
- Does it follow existing project patterns and conventions?
- Are dependencies pointing in the correct direction (no circular)?
- Is the abstraction level consistent within each layer?
- Are cross-cutting concerns (logging, auth, error handling) handled consistently?

### Pass 2: Logic
- Does every function do exactly one thing (Single Responsibility)?
- Are all edge cases handled? (null, empty, boundary values, overflow)
- Are all error paths covered with specific error types?
- Are race conditions possible? Is concurrent access handled?
- Is business logic free of I/O (pure functions where possible)?

### Pass 3: Readability
- Can a new team member understand this code without asking questions?
- Are all names self-documenting (no abbreviations, no single letters except loop vars)?
- Is the code structure linear (no jumping between files to understand one flow)?
- Are complex conditionals extracted to named functions?
- Is there zero dead code, zero commented-out code?

### Pass 4: Testing
- Do tests exist for happy path, error path, AND edge cases?
- Are tests independent (no shared mutable state, no test order dependency)?
- Do test names describe the scenario, not the function? ("should reject expired tokens" not "testValidate")
- Are test fixtures/mocks minimal (test only what matters)?
- Do tests run fast (no real I/O in unit tests)?

### Pass 5: Performance
- No N+1 query patterns (eager load or batch where needed)?
- No unbounded loops or collections (always paginate, always limit)?
- No synchronous blocking in async context?
- Is pagination present for all list endpoints?
- Are expensive operations cached where appropriate?
- Are database queries indexed for the access patterns used?

### Pass 6: Security Cross-Check
- All Phase 7 (security audit) findings have been addressed?
- Have any new security concerns been introduced during implementation?
- Are all inputs validated at the system boundary?
- Is sensitive data masked in logs?
- Are API responses filtered to exclude internal fields?

### Pass 7: Documentation
- Are all public APIs documented (parameters, returns, errors, examples)?
- Are complex business rules explained with comments explaining WHY not WHAT?
- Is the README updated with new features, env vars, or setup steps?
- Are breaking changes documented in CHANGELOG?

## Complexity Thresholds

### Cyclomatic Complexity
- ≤5: Ideal — simple, easy to test
- 6-10: Acceptable — manageable complexity
- 11-15: Warning — consider refactoring
- 16-20: High risk — refactor recommended
- >20: MANDATORY REFACTOR — too many paths to test reliably

### Cognitive Complexity
- ≤10: Ideal — easy to understand at a glance
- 11-15: Acceptable — requires some focus
- >15: MANDATORY REFACTOR — too hard to reason about

### Measuring Complexity
- Each `if`, `else if`, `else`, `switch case`: +1 cyclomatic
- Each `&&`, `||` in a condition: +1 cyclomatic
- Nested conditions: +1 cognitive per nesting level
- Recursive calls: +1 cognitive
- Break in linear flow (goto, continue, break except in switch): +1 cognitive
