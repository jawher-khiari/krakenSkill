# Kraken Code Simplification Reference

> Absorbed from [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) — code-simplification skill.

## Goal
Code that is easier to read, understand, modify, and debug. NOT fewer lines — faster comprehension.

## Five Principles

### 1. Preserve Behavior Exactly
Before every change ask:
- Same output for every input?
- Same error behavior?
- Same side effects and ordering?
- All existing tests pass WITHOUT modification?

### 2. Follow Project Conventions
Simplification means making code more consistent with the codebase, not imposing preferences.
- Read CLAUDE.md / project conventions first
- Study neighboring code patterns
- Breaking project consistency is churn, not simplification

### 3. Clarity Over Cleverness
Explicit > compact when compact requires a mental pause.
- Readable mapping > dense ternary chains
- Named intermediate steps > chained reduces with inline logic
- 5-line if/else > 1-line nested ternary

### 4. Chesterton's Fence
Before removing something: understand WHY it exists. Check git blame. If it has a reason, respect it. If it's residue of iteration under pressure, remove it.

### 5. Maintain Balance (Avoid Over-Simplification)
- Don't inline helpers that give concepts names
- Don't combine unrelated logic into one function
- Don't remove abstractions that exist for extensibility/testability
- Don't optimize for line count — optimize for comprehension

## Rule of 500
- Functions: ≤500 lines (ideally ≤50)
- Files: ≤500 lines (ideally ≤300)
- Classes: ≤500 lines
- If exceeding, split by responsibility

## Simplification Process
1. **Scope:** Define what you're simplifying and why
2. **Understand:** Read the code, run tests, check git history
3. **Simplify:** One change at a time, tests pass after each
4. **Verify:** All tests green, no behavior change, cleaner diff

## Red Flags
- Simplification that requires modifying tests (you changed behavior)
- "Simplified" code that is longer and harder to follow
- Renaming to match YOUR preferences rather than project conventions
- Removing error handling because "it makes the code cleaner"
- Simplifying code you don't fully understand
- Batching many simplifications into one large commit
- Refactoring outside the scope of the current task
