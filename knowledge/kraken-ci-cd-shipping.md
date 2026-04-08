# Kraken CI/CD, Shipping & Launch Reference

> Absorbed from [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) — ci-cd-and-automation, shipping-and-launch, git-workflow-and-versioning skills.

## CI/CD Principles

### Shift Left
Catch issues as early as possible. The cost of fixing a bug increases 10x at each stage (code → build → test → staging → production).

### Faster is Safer
Frequent small deploys are safer than infrequent large ones. Each deploy carries less risk and is easier to debug.

### Quality Gate Pipeline
Every PR must pass: lint → types → unit tests → build → integration tests → security audit.

## Git Workflow

### Trunk-Based Development
- Short-lived feature branches (1-3 days max)
- Merge to main frequently
- Feature flags for incomplete work
- No long-lived branches diverging from main

### Atomic Commits
- One logical change per commit
- Tests pass at every commit
- Message format: `type(scope): description` (conventional commits)
- Message explains WHY, not just WHAT
- No formatting changes mixed with behavior changes

### Commit Sizing (~100 lines)
- PRs should be ~100 lines of meaningful change
- Larger changes split into stacked PRs or sequential commits
- Each commit is independently reviewable and revertable

## Pre-Launch Checklist

### Before Deploy
- [ ] All quality gates pass (lint, types, tests, build, audit)
- [ ] Feature flag configured with kill switch
- [ ] Rollback plan documented and tested
- [ ] Monitoring dashboards set up
- [ ] Error reporting configured
- [ ] Team notified of deployment

### After Deploy
- [ ] Health check returns 200
- [ ] Key metrics stable (error rate, latency, throughput)
- [ ] Feature flag enabled for canary percentage
- [ ] Monitor for first hour minimum
- [ ] Staged rollout: 1% → 10% → 50% → 100%

### Feature Flag Lifecycle
1. Create flag (disabled by default)
2. Deploy code behind flag
3. Enable for canary users
4. Gradual rollout
5. Full rollout + remove flag code
6. Every flag must have an owner and expiration date

## Rollback Strategy
- Every deploy must have a one-command rollback
- Database migrations must be backward-compatible
- Config changes separate from code deploys
- If in doubt, roll back first, investigate second

## Red Flags
- No CI pipeline in the project
- CI failures ignored or silenced
- Tests disabled to make pipeline pass
- Production deploys without staging verification
- Deploying without rollback mechanism
- Secrets in code or CI config (not secrets manager)
- "It's Friday afternoon, let's ship it"
- No monitoring or error reporting in production
- Feature flags with no expiration or owner
