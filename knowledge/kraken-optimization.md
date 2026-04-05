# Kraken Knowledge: Optimization Patterns

## Refactoring Catalog

### Extract Function
When: A code block does a distinct subtask within a larger function.
Before: 30-line function with inline validation, transformation, and persistence.
After: Three 10-line functions: `validate()`, `transform()`, `persist()`.
Rule: If you need a comment to explain what a block does, extract it to a named function.

### Replace Nested Conditional with Guard Clauses
When: Deep nesting makes the happy path hard to find.
Before: `if (a) { if (b) { if (c) { doWork() } } }`
After: `if (!a) return; if (!b) return; if (!c) return; doWork();`
Rule: Each guard clause eliminates one nesting level.

### Replace Conditional with Polymorphism
When: A switch/if-else selects behavior based on type.
Before: `if (type === 'email') sendEmail(); else if (type === 'sms') sendSms();`
After: `notifier.send()` where `notifier` is a `EmailNotifier` or `SmsNotifier` instance.
Rule: Use when 3+ branches exist and the pattern appears in multiple places.

### Introduce Parameter Object
When: A function takes 4+ related parameters.
Before: `createUser(name, email, phone, address, city, country)`
After: `createUser(userData: CreateUserInput)`
Rule: Group parameters that always travel together.

### Decompose Conditional
When: A complex boolean expression is hard to read.
Before: `if (user.age >= 18 && user.verified && !user.banned && user.subscription !== 'expired')`
After: `if (isEligibleForPurchase(user))`
Rule: Extract to a named function that describes the business rule.

### Remove Dead Code
When: Code is unreachable, commented out, or behind always-false conditions.
Action: Delete it. Git history preserves everything. Dead code rots — it misleads readers and increases maintenance burden.
Rule: If `git log` can find it, you don't need it in the source.

### Replace Magic Number with Named Constant
When: A literal value appears without explanation.
Before: `if (retries > 3)` or `setTimeout(fn, 86400000)`
After: `if (retries > MAX_RETRY_ATTEMPTS)` or `setTimeout(fn, ONE_DAY_MS)`
Rule: Every literal except 0, 1, -1, true, false, empty string needs a name.

## Rule of Three

Do NOT extract a shared function until a pattern appears 3 times:
- 1st occurrence: Write it inline
- 2nd occurrence: Note the duplication, keep it inline
- 3rd occurrence: NOW extract to a shared function

Why: Premature abstraction creates the wrong abstraction. Two occurrences don't give enough signal about what the true shared pattern is. The third occurrence reveals the real shape.

## Compression Checklist

- [ ] Extract shared logic (only if Rule of Three is met)
- [ ] Flatten all nested conditionals to guard clauses
- [ ] Remove all dead code (unreachable, commented, unused imports)
- [ ] Reduce dependencies (remove unused, consolidate similar)
- [ ] Simplify types (remove unnecessary generics, flatten unions)
- [ ] Profile before optimizing performance (never guess bottlenecks)
- [ ] Verify behavior unchanged after each optimization (run tests)

## Performance Optimization Rules

1. **Measure first.** Never optimize without profiling data.
2. **Optimize the algorithm, not the code.** O(n²) → O(n log n) beats any micro-optimization.
3. **Cache expensive operations** — but invalidate correctly (hardest problem in CS).
4. **Lazy load** — don't compute/fetch until needed.
5. **Batch operations** — one query returning 100 rows beats 100 queries returning 1 row.
6. **Avoid premature optimization** — make it work, make it right, THEN make it fast.

## Breaking Change Detection

For every optimization, check these contract boundaries:

| Contract Type | Breaking If Changed | Check |
|---|---|---|
| Public API endpoint | URL, method, required params | Compare before/after OpenAPI spec |
| Response shape | Field names, types, nesting | Compare before/after response samples |
| Event names/payloads | Event name, payload structure | Search all event listeners |
| Config keys | Key names, expected types | Search all config consumers |
| Database schema | Column names, types, constraints | Check all queries and migrations |
| File/path conventions | Import paths, file locations | Search all import statements |

### If breaking change detected:

```
BREAKING: [what contract changed]
Impact: [who/what is affected — list consumers]
Migration steps:
  1. [step for consumers to adapt]
  2. [step to verify migration]
Backward compatibility option: [can old + new coexist temporarily? how?]
Deprecation period: [if applicable — how long old format supported]
```

### If no breaking change:
`Non-breaking: internal refactor only. All public contracts preserved.`

## Documentation Verification (Phase 10)

After optimization, verify documentation is updated:
- [ ] API docs reflect any signature changes (params, returns, errors, examples)
- [ ] README updated with new setup steps, env vars, config
- [ ] Complex logic changes have updated WHY-comments (not WHAT-comments)
- [ ] CHANGELOG updated if user-facing behavior changed
- [ ] Migration guide created if breaking changes exist
