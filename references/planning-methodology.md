# Planning Methodology — Vertical Slicing + Story Splitting + Estimation + Branching

Load this file during **Phase 3: DECOMPOSE** and **Phase 4: PLAN**.

---

## Table of Contents
1. [Six-Phase Planning Workflow](#planning-workflow)
2. [Vertical Slicing Deep Dive](#vertical-slicing)
3. [Story Splitting Techniques](#story-splitting)
4. [Estimation Framework](#estimation)
5. [Branching Strategy Selection](#branching-strategy)
6. [Definition of Done Template](#definition-of-done)
7. [Risk Assessment](#risk-assessment)
8. [Dependency Mapping](#dependency-mapping)

---

## Six-Phase Planning Workflow

### Phase A: Requirements Analysis (30 minutes)
1. Read ALL documentation (ticket, designs, conversations, related tickets)
2. List explicit requirements as checkable statements
3. List implicit requirements (error handling, loading states, edge cases)
4. List assumptions — each one must be confirmed or eliminated
5. List open questions — each one must be answered before implementation

### Phase B: Technical Investigation (1-2 hours)
1. Review existing codebase for related features
2. Identify all systems/services affected by this change
3. Find the closest existing analog (the Pattern Template)
4. Execute time-boxed spikes for unknowns (≤2 hours max per spike)
5. Document findings: what exists, what's missing, what's risky

### Phase C: Architecture Review (30 minutes)
1. Draft lightweight architecture proposal
2. Evaluate trade-offs using quality attribute matrix:
   - List quality attributes at stake (ISO 25010)
   - List constraints (cost, timeline, team skill, compliance)
   - Score options against attributes (1-5 scale)
3. Write ADR for key choices (Y-statement format)
4. Peer review the proposal before proceeding

### Phase D: Task Breakdown (1 hour)
1. Create user story map (backbone = user activities, walking skeleton = first row)
2. Apply vertical slicing (see section below)
3. Each slice = one deliverable unit of work
4. Verify each slice satisfies INVEST criteria

### Phase E: Estimation (30 minutes)
1. Compare each slice to known reference stories
2. Assign story points using Planning Poker scale (1, 2, 3, 5, 8, 13)
3. Stories >13 points MUST be split further
4. Total effort = sum of slices (with uncertainty buffer)

### Phase F: Sequencing (30 minutes)
1. Map dependencies between slices
2. Identify critical path (longest chain of dependent slices)
3. Order slices: Walking Skeleton first, then by dependency order, then by risk
4. Highest-risk slices as early as possible (fail fast)

---

## Vertical Slicing Deep Dive

### What is a Vertical Slice?
A slice that cuts through ALL application layers to deliver end-to-end functionality:

```
HORIZONTAL (❌ Anti-pattern):
Sprint 1: Build all database tables
Sprint 2: Build all API endpoints
Sprint 3: Build all UI components
Sprint 4: "Integration" (a.k.a. pain)

VERTICAL (✅ Correct):
Slice 1: User can register (form → API → DB → confirmation)
Slice 2: User can login (form → API → auth → session)
Slice 3: User can view profile (page → API → DB → display)
Slice 4: User can edit profile (form → API → validate → DB → confirmation)
```

### The Walking Skeleton
The FIRST slice is always the thinnest possible end-to-end path:
- Proves the architecture works
- Deployed to a real environment
- May do almost nothing useful — that's fine
- Example: Login form → hits API → returns hardcoded response → displays "Welcome"
- Every subsequent slice builds on this working skeleton

### Why Vertical > Horizontal
1. **Integration risk discovered early** — Not at the end when it's expensive
2. **Deployable after every slice** — Business value delivered incrementally
3. **Feedback loops shorter** — Users can test partial features sooner
4. **Scope can be adjusted** — Cut low-priority slices without losing partial work
5. **Estimation accuracy higher** — Small end-to-end slices are easier to estimate

---

## Story Splitting Techniques

### Technique 1: Split by Workflow Steps
```
Original: "As a user, I can purchase a product"
Split:
  1. User can add item to cart
  2. User can view cart contents
  3. User can enter shipping address
  4. User can enter payment details
  5. User can confirm and submit order
  6. User receives order confirmation
```

### Technique 2: Split by Business Rules
```
Original: "As a user, I can apply discount codes"
Split:
  1. User can apply a percentage discount code
  2. User can apply a fixed-amount discount code
  3. System prevents applying expired codes
  4. System prevents stacking multiple codes
  5. System shows original and discounted price
```

### Technique 3: Split by Happy/Unhappy Path
```
Original: "As a user, I can upload a profile photo"
Split:
  1. User can upload valid JPEG/PNG (happy path)
  2. System rejects files >5MB with clear error
  3. System rejects non-image files with clear error
  4. System handles upload network timeout gracefully
  5. User can replace existing photo
```

### Technique 4: Split by Input Variations
```
Original: "As a user, I can search for providers"
Split:
  1. Search by provider name (text input)
  2. Filter by treatment type (dropdown)
  3. Filter by price range (slider)
  4. Filter by location/distance (geolocation)
  5. Combine multiple filters
```

### Technique 5: Split by Interface
```
Original: "As a user, I can manage appointments"
Split:
  1. View appointments in list view
  2. View appointments in calendar view
  3. Create appointment (basic form)
  4. Edit existing appointment
  5. Cancel appointment with confirmation
```

### Technique 6: Split by Quality Level
```
Original: "As a user, I can see a dashboard"
Split:
  1. Dashboard with static data display (basic)
  2. Dashboard with real-time data refresh
  3. Dashboard with interactive charts
  4. Dashboard with export functionality
  5. Dashboard with customizable widgets
```

### INVEST Validation (EVERY story must pass)
| Criterion | Test |
|---|---|
| **Independent** | Can be completed without waiting on other stories? |
| **Negotiable** | Implementation details flexible? Not a contract? |
| **Valuable** | Delivers value to user or business? Not just technical? |
| **Estimable** | Team can estimate effort? No complete unknowns? |
| **Small** | Completable in 1-2 days (max 3)? |
| **Testable** | Clear pass/fail acceptance criteria? |

---

## Estimation Framework

### Story Point Reference Scale
| Points | Meaning | Example |
|---|---|---|
| **1** | Trivial, confident, <2 hours | Fix a typo, update a constant |
| **2** | Simple, well-understood, <half day | Add a new field to an existing form |
| **3** | Small feature, clear approach, ~1 day | Add a new API endpoint (CRUD pattern exists) |
| **5** | Medium feature, some unknowns, ~2 days | New filter system with UI + API + DB |
| **8** | Large feature, significant complexity, ~3-4 days | New authentication flow |
| **13** | Very large, many unknowns, ~1 week | Major refactoring or new subsystem |
| **>13** | **TOO BIG — MUST SPLIT** | — |

### Estimation Rules
1. **Compare, don't calculate.** "Is this bigger or smaller than [reference story]?"
2. **Include everything:** coding + testing + review + documentation
3. **Uncertainty buffer:** Add 20-30% for stories with unknowns
4. **Spike first:** If you can't estimate, do a time-boxed spike (≤4 hours)
5. **Track actuals:** Compare estimates to reality. Calibrate over time.

---

## Branching Strategy Selection

### Decision Framework
| Condition | Strategy | Why |
|---|---|---|
| Team <15 devs + mature CI/CD | **Trunk-Based Development** | DORA elite: 182× more frequent deploys |
| Team without mature CI/CD | **GitHub Flow** | Simple, one main branch + feature branches |
| Installed software, multiple prod versions | **GitFlow** | Release branches for each version |
| Open source with external contributors | **GitHub Flow + Forking** | Fork-based PRs, clean main branch |

### Trunk-Based Development Rules
- Feature branches live **<24 hours** (max 2-3 days)
- Feature flags for incomplete features (merge to main even if not ready for users)
- CI runs on every push to main — tests MUST pass
- No long-lived branches. No "develop" branch.
- Branch naming: `feat/short-description`, `fix/short-description`, `refactor/short-description`

### GitHub Flow Rules
- One main branch (`main`)
- Feature branches from `main`, merged via PR back to `main`
- PR must be reviewed + CI must pass before merge
- Deploy from `main` (or tag releases)
- Delete branch after merge

### Feature Flag Patterns
```javascript
// Simple boolean flag
if (featureFlags.isEnabled('new-search-ui')) {
  return <NewSearchPage />;
}
return <OldSearchPage />;

// Gradual rollout (percentage)
if (featureFlags.isEnabledForUser('new-pricing', user.id, 25)) { // 25% of users
  return calculateNewPrice(order);
}

// Environment-based
if (featureFlags.isEnabled('experimental-api', { env: 'staging' })) {
  enableExperimentalEndpoints();
}
```

---

## Definition of Done Template

A task is DONE when ALL of these are true:

### Code Quality
- [ ] Code reviewed and approved by at least one peer
- [ ] All linter/formatting rules pass (zero warnings)
- [ ] No new SonarQube/CodeClimate issues
- [ ] Static analysis quality gate passed
- [ ] Cyclomatic complexity ≤10, cognitive ≤15 per function

### Testing
- [ ] Unit tests written and passing
- [ ] Integration tests written and passing (if applicable)
- [ ] Branch coverage ≥80% on new code
- [ ] Edge cases tested (null, empty, boundary, error paths)
- [ ] No flaky tests introduced

### Security
- [ ] SAST scan clean (no new critical/high findings)
- [ ] SCA scan clean (no new vulnerable dependencies)
- [ ] Secrets detection clean
- [ ] Input validation present for all new user inputs
- [ ] Authorization checked for all new endpoints

### Accessibility (UI changes only)
- [ ] Contrast ratios verified (≥4.5:1 text, ≥3:1 UI components)
- [ ] Keyboard navigation works for all new interactive elements
- [ ] Screen reader tested (ARIA labels, roles, live regions)
- [ ] Focus indicators visible and not obscured
- [ ] Touch targets ≥44×44px

### Operations
- [ ] Deployed to staging and smoke-tested
- [ ] No performance regression (monitored metrics stable)
- [ ] API documentation updated (if applicable)
- [ ] Configuration changes documented (env vars, feature flags)
- [ ] Monitoring/logging configured for new functionality
- [ ] Rollback plan documented for non-trivial changes

### Approval
- [ ] Demonstrated to Product Owner / stakeholder
- [ ] Acceptance criteria from ticket verified
- [ ] Tech debt documented as follow-up tickets (not mental notes)

---

## Risk Assessment

### Risk Matrix for Planning
| Risk Level | Probability × Impact | Action |
|---|---|---|
| **Critical** | High prob × High impact | Mitigate immediately. Spike first. Fallback plan. |
| **High** | High×Med or Med×High | Address in first sprint. Monitor closely. |
| **Medium** | Med×Med | Plan mitigation. Schedule in backlog. |
| **Low** | Low×anything | Accept. Document. Monitor. |

### Common Technical Risks
1. **Third-party API instability** — Mitigation: Circuit breaker, fallback, retry with backoff
2. **Data migration complexity** — Mitigation: Dry run on staging, rollback script ready
3. **Performance under load** — Mitigation: Load test before release, performance budget
4. **Unfamiliar technology** — Mitigation: Spike, prototype, pair programming
5. **Cross-team dependency** — Mitigation: Contract-first development, stub/mock boundaries
6. **Regulatory/compliance** — Mitigation: Legal review early, document decisions

---

## Dependency Mapping

### How to Map Dependencies
```
For each slice:
  1. List: What must be DONE before this slice can START?
     (predecessor slices, external APIs, infrastructure, approvals)
  2. List: What does this slice PRODUCE that other slices need?
     (schemas, contracts, shared utilities, configurations)
  3. List: What EXTERNAL factors could block this slice?
     (third-party API access, design approval, data access, credentials)
```

### Critical Path Identification
1. Draw dependency graph (slices as nodes, dependencies as directed edges)
2. Find the longest path from first slice to last slice = critical path
3. Any delay on the critical path delays the entire feature
4. Non-critical-path slices have float (can be delayed without affecting total)
5. **Schedule critical path slices FIRST. Parallelize non-critical slices.**

### Unblocking Strategies
- **Mock the dependency:** Build against a contract/interface, connect real impl later
- **Spike the unknown:** Time-boxed investigation before committing to a plan
- **Contract-first:** Agree on API shape before either side implements
- **Walking skeleton:** Prove the end-to-end path works before fleshing out details
- **Feature flags:** Ship incomplete work behind flags, unblock dependent work
