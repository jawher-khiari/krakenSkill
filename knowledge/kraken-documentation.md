# Kraken Documentation & ADR Reference

> Absorbed from [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) — documentation-and-adrs skill.

## Architecture Decision Records (ADRs)

### When to Write an ADR
- Choosing between technologies, frameworks, or libraries
- Defining data models, API shapes, or module boundaries
- Making trade-offs that aren't obvious from the code
- Any decision a future engineer would ask "why?"

### ADR Template
```markdown
# ADR-[NNN]: [Title]

## Status
[Proposed | Accepted | Deprecated | Superseded by ADR-NNN]

## Context
[What is the problem? What forces are at play?]

## Decision
[What did we decide? Be specific.]

## Alternatives Considered
- [Option A]: [pros/cons]
- [Option B]: [pros/cons]

## Consequences
- [Positive consequence]
- [Negative consequence / trade-off]
- [Risks accepted]
```

### ADR Rules
- Document the WHY, not the WHAT (code shows what)
- Include alternatives that were rejected and why
- ADRs are immutable — supersede, don't edit
- Store in `docs/adr/` or `docs/decisions/`

## Documentation Standards

### Comments
- Comment on WHY, never on WHAT
- `// Retry 3 times because the payment gateway has transient 503s` ✅
- `// Loop through the array` ❌
- No commented-out code — delete it, git has history
- No TODO comments older than one sprint

### README Requirements
- How to install and run the project
- Key architecture decisions
- Available commands (dev, test, build, deploy)
- Environment setup requirements

### API Documentation
- Every public function: parameters, return type, exceptions
- Every endpoint: request/response schema, status codes, examples
- Inline examples for non-obvious usage

## Red Flags
- Architectural decisions with no written rationale
- Public APIs with no documentation or types
- README that doesn't explain how to run the project
- Commented-out code instead of deletion
- TODO comments that have been there for weeks
- Documentation that restates the code instead of explaining intent
