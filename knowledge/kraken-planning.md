# Kraken Knowledge: Planning Methodology

## Vertical Slicing — INVEST Criteria

Every slice must satisfy:
- **I**ndependent: Can be developed and deployed without other slices
- **N**egotiable: Implementation details are flexible, outcome is fixed
- **V**aluable: Delivers user-visible value or removes technical risk
- **E**stimable: Small enough to estimate with confidence
- **S**mall: Completable in 1-3 days maximum
- **T**estable: Has a clear test that proves it works

## Slicing Strategy

### First Slice: Walking Skeleton
The thinnest possible end-to-end path that proves the architecture works. For a CRUD feature: one entity, one endpoint, one UI screen, one test. No edge cases, no validation, no error handling — just the happy path through all layers.

### Subsequent Slices
Slice by business rule, not by layer. Bad: "build all models, then all services, then all controllers." Good: "Slice 1: create user (happy path). Slice 2: add email validation. Slice 3: add duplicate detection."

### Decomposition Order
1. Data layer first — define the shape of truth
2. Validation and security rules second — establish boundaries
3. Business logic third — implement the rules
4. API/interface layer fourth — expose the functionality
5. UI layer last — consume the API

## Plan Completeness Checklist

A plan is complete when it contains:
- [ ] Every file to create or modify, with exact paths
- [ ] Every function signature with types, purpose, and error cases
- [ ] Every new dependency with version and justification
- [ ] Test cases written BEFORE implementation (TDD)
- [ ] Security annotation per slice (even "Low risk: internal read-only")
- [ ] UI state list per component (if frontend)
- [ ] Performance notes for data-intensive operations
- [ ] Execution order with dependency arrows
- [ ] Effort estimate per slice

## Estimation Guidelines

| Size | Lines of Code | Complexity | Time |
|---|---|---|---|
| S (Small) | <50 lines | Single function/component | 1-2 hours |
| M (Medium) | 50-200 lines | Multiple functions, one module | 2-8 hours |
| L (Large) | 200-500 lines | Multiple modules, integration | 1-3 days |
| XL (X-Large) | >500 lines | Multiple systems, breaking change | 3-5 days — consider splitting |

## Structured Requirements Template (from architecture-planner pattern)

When requirements are complex, gather:

### Functional Requirements
- Core features and capabilities needed
- User interactions and workflows
- Data processing requirements
- Integration points with existing systems

### Non-Functional Requirements
- **Scale:** Expected users, data volume, transaction volume
- **Performance:** Response time targets, throughput requirements
- **Availability:** Uptime target (99.9%?), disaster recovery needs
- **Security:** Auth method, data protection level, compliance

### Constraints
- **Tech:** Required stack, existing systems to integrate with, team familiarity
- **Timeline:** Hard deadlines, phasing requirements
- **Budget:** Infrastructure cost limits, licensing constraints
- **Compliance:** GDPR, HIPAA, SOC2, PCI-DSS, or industry standards

### Scalability Strategy (from architecture-planner pattern)

For features that may need to scale, plan in phases:

**Phase 1 — Make it work:** Simple implementation, single instance, prove the concept.
**Phase 2 — Make it right:** Extract services, add caching, optimize queries, handle errors.
**Phase 3 — Make it fast:** Horizontal scaling, database optimization, CDN, multi-region if needed.

Never build Phase 3 complexity in Phase 1. Let actual load data drive scaling decisions.
