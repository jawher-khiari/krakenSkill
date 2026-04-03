# 🐙 Kraken — Ultimate Claude Code Development Skill

> **2 hours thinking beats 2 hours debugging. Always.**

The Kraken is a 10-phase self-driving development pipeline for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) that replicates the behavior of a 20-year senior developer with security engineering background and UI/UX design expertise.

It enforces a mandatory pipeline — scaled to complexity but never skipped — that guarantees production-quality code on every task.

---

## 🔥 What Makes Kraken Different

| Feature | Typical AI Coding | Kraken |
|---|---|---|
| **Planning** | Jumps straight to code | 4 phases before any code is written |
| **Security** | Afterthought | 9-pass hostile audit based on OWASP Top 10:2025 |
| **Design** | Generic UI | WCAG 2.2 AA, design tokens, component state matrix |
| **Testing** | "I'll add tests later" | TDD workflow, coverage ratcheting, property-based testing |
| **Code Quality** | Works ≠ done | 50-point review protocol, complexity gates, refactoring catalog |
| **Architecture** | Whatever works | Pattern detection, ADRs, vertical slicing, SOLID verification |

---

## 📋 The 10-Phase Pipeline

```
RECEIVE → BRAINSTORM → DECOMPOSE → PLAN → DESIGN-UI
    ↓                                          ↓
VERIFY ← OPTIMIZE ← REVIEW ← SECURITY-AUDIT ← IMPLEMENT
```

| Phase | Purpose | Reference File Loaded |
|---|---|---|
| 1. **RECEIVE** | Understand the real need, not just the stated request | — |
| 2. **BRAINSTORM** | Scan codebase, find patterns, generate 2-3 approaches | `patterns-catalog.md` |
| 3. **DECOMPOSE** | Vertical slices, walking skeleton, INVEST validation | `planning-methodology.md` |
| 4. **PLAN** | File-by-file roadmap, test cases FIRST, security annotations | `testing-strategy.md` |
| 5. **DESIGN-UI** | Visual hierarchy, accessibility, tokens, state matrix | `design-checklist.md` |
| 6. **IMPLEMENT** | Pattern-matched, TDD, early returns, commit discipline | `testing-strategy.md` |
| 7. **SECURITY-AUDIT** | OWASP Top 10:2025, STRIDE/DREAD, 9 hostile passes | `security-checklist.md` |
| 8. **REVIEW** | Google-grade 7-phase review, 50-point protocol | `review-checklist.md` |
| 9. **OPTIMIZE** | Fowler refactoring catalog, Rule of Three, profiling | `optimization-patterns.md` |
| 10. **VERIFY** | Definition of Done, ship gate, rollback plan | — |

---

## 📦 Installation

### Option A: Install as `.skill` package
```bash
claude install-skill kraken.skill
```

### Option B: Manual installation
```bash
# Copy to your Claude Code user skills directory
cp -r kraken/ ~/.claude/skills/user/kraken/

# Or project-local:
cp -r kraken/ .claude/skills/user/kraken/
```

### Option C: Clone this repo
```bash
git clone https://github.com/YOUR_USERNAME/kraken-skill.git
cp -r kraken-skill/ ~/.claude/skills/user/kraken/
```

---

## 🗂 File Structure

```
kraken/
├── SKILL.md                              # Main skill (640 lines) — always in context
└── references/                           # Loaded on-demand at specific phases
    ├── security-checklist.md             # OWASP Top 10:2025 + STRIDE/DREAD
    ├── review-checklist.md               # 50-point review protocol + complexity gates
    ├── design-checklist.md               # WCAG 2.2 + design tokens + animation timing
    ├── optimization-patterns.md          # Refactoring catalog + performance budgets
    ├── patterns-catalog.md               # Design pattern selection + SOLID + code smells
    ├── testing-strategy.md               # TDD + testing shapes + anti-patterns
    └── planning-methodology.md           # Vertical slicing + estimation + branching
```

**Total: 2,568 lines across 8 files (121KB)**

---

## 🔌 Skill Delegation

The Kraken orchestrates other Claude Code skills when detected:

| Condition | Delegated Skill | At Phase |
|---|---|---|
| Express + React codebase | `express-react-vault-mapper` | Phase 2 |
| .NET + Angular codebase | `dotnet-angular-vault-mapper` | Phase 2 |
| UI implementation needed | `frontend-design` | Phase 5 + 6 |

---

## 🎯 Trigger Keywords

The Kraken activates on: `build`, `implement`, `add feature`, `refactor`, `plan`, `design`,
`architect`, `fix`, `debug`, `optimize`, `review`, `secure`, `improve`, `create`, `scaffold`,
`setup`, `configure`, `deploy`, `migrate`, `code`, `develop`, `prototype`, `MVP`, `API`,
`endpoint`, `component`, `page`, `module`, `service`, `model`, `schema`, `database`,
`frontend`, `backend`, `fullstack`, `map this project`, `generate code`, `UI`, `UX`,
`responsive`, `accessible`, `performance`, `security audit`, `threat model`, `OWASP`,
`code smell`, `tech debt`, `clean up`, `test`, `TDD`, `coverage`, and more.

---

## 📐 Key Standards Enforced

- **Code:** Functions ≤20 lines, files ≤200 lines, nesting ≤3 levels, no magic numbers
- **Complexity:** Cyclomatic ≤10, Cognitive ≤15 (mandatory refactor above thresholds)
- **Security:** OWASP Top 10:2025, parameterized queries, no hardcoded secrets, STRIDE threat modeling
- **Accessibility:** WCAG 2.2 AA, contrast ≥4.5:1, focus ≥2px, targets ≥44×44px
- **Performance:** LCP ≤2.5s, INP ≤200ms, CLS ≤0.1, bundle ≤170KB gzipped
- **Testing:** ≥80% branch coverage, coverage ratcheting, TDD for complex logic
- **Design:** 8px grid, 3-tier design tokens, component state matrix for every component

---

## 🧠 Research Foundation

Built from industry-leading sources:
- Google Engineering Practices (code review hierarchy)
- OWASP Top 10:2025 (security controls)
- Martin Fowler's Refactoring Catalog (complexity reduction)
- WCAG 2.2 (accessibility standards)
- Kent Beck's TDD (testing discipline)
- Michael Nygard's ADR format (architecture decisions)
- Core Web Vitals 2025 (performance budgets)
- STRIDE/DREAD (threat modeling)
- HikariCP pool sizing (backend optimization)

---

## 📜 License

MIT — Use it, fork it, make it yours.
