# Kraken Tech Debt & Code Gardening Reference

> Absorbed from [jwadow/agentic-prompts](https://github.com/jwadow/agentic-prompts) (Gardener persona), [Significant-Gravitas/AutoGPT](https://github.com/Significant-Gravitas/AutoGPT), [stitionai/devika](https://github.com/stitionai/devika).

## The Gardener's Oath: Do No Harm

Refactoring MUST preserve external behavior. The cycle is unbreakable:
1. Verify existing tests pass
2. Make ONE small, atomic change
3. Verify tests still pass
4. Commit
5. Repeat

**If tests need modification, you changed behavior — that's not refactoring.**

## Dependency Hygiene Protocol

### Update One at a Time
Never `npm update` or `pip install --upgrade` everything at once. Per dependency:
1. Read the changelog for breaking changes
2. Update the single dependency
3. Run full test suite
4. If green → commit. If red → fix or revert.

### Dependency Audit Checklist
- [ ] `npm audit` / `pip-audit` / `dotnet list package --vulnerable` — zero critical/high
- [ ] No typosquatting in package names (verify against official registry)
- [ ] License compatibility verified
- [ ] No unmaintained libraries (last commit > 2 years)
- [ ] Unused dependencies removed (`depcheck` / `pip-autoremove`)
- [ ] Lock file committed and up to date

### Supply Chain Security
- Verify packages come from official registries only
- Pin exact versions in production (no `^` or `~`)
- Enable Dependabot/Renovate for automated security updates
- Review transitive dependencies, not just direct ones

## TODO Audit Protocol

1. `grep -r "TODO\|FIXME\|HACK\|XXX" src/` → list all debt markers
2. Per marker:
   - **Stale (>1 sprint old)?** → Delete or create ticket
   - **Quick fix (<10 min)?** → Fix it now
   - **Complex?** → Create formal issue with description
3. Zero tolerance for undated, unowned TODOs

## Dead Code Removal

### Detection
- Static analysis tools (`ts-prune`, `vulture`, coverage reports)
- Coverage reports showing 0% branches
- `git log --diff-filter=D` for recently deleted files that may have orphaned references

### Safety Protocol
1. Confirm zero references via static analysis
2. Check for dynamic/reflection-based calls
3. Delete code (not comment out — git has history)
4. Run full test suite
5. Commit with message: `chore: remove dead code — [function/module] unused since [date/commit]`

## Atomic Improvement Patterns

### The Boy Scout Rule
"Always leave code cleaner than you found it" — but within scope:
- ONE rename per commit
- ONE extraction per commit
- ONE simplification per commit
- NEVER mix refactoring with feature work

### Progressive Debt Reduction
Don't schedule "refactoring sprints." Instead:
- 20% rule: dedicate ~20% of every feature's effort to cleaning surrounding code
- Touch-and-improve: when you open a file for a feature, clean one thing
- Track debt-down metrics: lines removed, complexity reduced, TODOs resolved

## Code Freshness Indicators

| Indicator | Healthy | Warning | Critical |
|---|---|---|---|
| Avg file age | <6 months | 6-12 months | >1 year untouched |
| Dependency age | Latest minor | 1 major behind | 2+ majors behind |
| TODO count | <10 | 10-30 | >30 |
| Dead code % | <2% | 2-5% | >5% |
| Test coverage | >80% | 60-80% | <60% |
| Lint warnings | 0 | <20 | >20 |

## Kraken Application

| Phase | Gardening Action |
|---|---|
| P2: BRAINSTORM | Assess codebase health during recon |
| P6: IMPLEMENT | Apply Boy Scout Rule per slice |
| P8: REVIEW | Detect code smells, flag debt |
| P9: OPTIMIZE | Remove dead code, simplify, audit deps |
| P10: VERIFY | Confirm zero new debt introduced |
