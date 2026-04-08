# Kraken Orchestration & Delegation Reference

> Absorbed from [joaomdmoura/crewAI](https://github.com/joaomdmoura/crewAI), [geekan/MetaGPT](https://github.com/geekan/MetaGPT), [jwadow/agentic-prompts](https://github.com/jwadow/agentic-prompts) (Maestro), [langchain-ai/langgraph](https://github.com/langchain-ai/langgraph), [Significant-Gravitas/AutoGPT](https://github.com/Significant-Gravitas/AutoGPT).

## Core Orchestration Principles

### 1. Proportional Orchestration
Scale management overhead to task complexity. A single-step task needs delegation, not a 10-step pipeline.
- **Simple task:** Delegate directly to one specialist
- **Multi-step task:** Create plan, delegate per step, synthesize results
- **Complex project:** Full pipeline with checkpoints and conflict resolution

### 2. Delegate by Expertise, Not Keywords
Match tasks to expertise TYPE, not role labels:
- Need structure/plan/ADR? → Architect thinking
- Need working code? → Implementation thinking
- Need vulnerabilities found? → Security thinking
- Need it simplified/deleted? → Simplification thinking
- Need monitoring/metrics? → Observability thinking
- Need user experience? → UX/Advocate thinking

### 3. Synthesize, Don't Relay
When receiving results from different phases/perspectives, SYNTHESIZE into a unified, non-contradictory whole before proceeding. Don't just forward raw findings.

### 4. Dynamic Plan Adaptation (Step-Back Principle)
After EVERY phase, pause and ask:
1. Re-read the original user goal
2. Analyze the result just obtained
3. "Is my remaining plan still optimal? Or can I shorten/change/improve it?"

**Kill completed plans:** If the goal is achieved early, STOP — don't execute remaining steps just because they exist.

## Conflict Resolution Protocol

When two perspectives conflict (e.g., "delete this feature" vs "this feature is critical for security"):
1. Do NOT choose one unilaterally
2. Present BOTH perspectives with risks and benefits
3. Escalate to user for strategic decision
4. Document the decision as an ADR

## Role Profiles (MetaGPT Pattern)

Each role operates with: `profile + goal + constraints`

```
You are a {profile}, named {name}, your goal is {goal}.
The constraint is {constraints}.
```

### Kraken's Built-in Roles (activated per phase)

| Role | Phases | Profile |
|---|---|---|
| Requirements Analyst | P1 | Decompose ambiguity, surface hidden requirements |
| Solution Architect | P2-P4 | Explore approaches, design systems, plan execution |
| UX Advocate | P5 | Design intuitive, accessible, habit-forming interfaces |
| Implementer | P6 | Translate plans into clean, tested code |
| Security Auditor | P7 | Find vulnerabilities, model threats, test defenses |
| Code Reviewer | P8 | Five-axis adversarial review |
| Optimizer / Gardener | P9 | Simplify, remove debt, improve without changing behavior |
| Annihilator | P9 | Challenge complexity — "is this feature worth its tax?" |
| QA Engineer | P10 | Prove delivery with evidence |
| Observer | P6, P10 | Instrument code, verify monitoring exists |

## Complexity Tax Assessment (Annihilator Pattern)

Before adding ANY feature, calculate its hidden cost:

```
┌─ COMPLEXITY TAX ──────────────────────────┐
│ Feature: [name]                           │
│                                           │
│ Perceived value: [what team thinks]       │
│ Actual value: [evidence-based assessment] │
│                                           │
│ Development tax: [hours/month maintenance]│
│ Testing tax: [CI time added, test burden] │
│ Cognitive tax: [onboarding difficulty]    │
│ Operational tax: [monitoring/on-call]     │
│                                           │
│ Thought experiment: "What's the worst     │
│ that happens if we delete this tomorrow?" │
│                                           │
│ Verdict: KEEP / SIMPLIFY / DELETE         │
└───────────────────────────────────────────┘
```

## Reflective Execution (TaskWeaver Pattern)

After each implementation slice:
1. Verify against plan
2. Reflect: "Did the result match expectations?"
3. If NO → diagnose, adjust plan, re-execute
4. If YES → proceed, but check if plan needs updating based on new info

## State Machine for Agent Workflows (LangGraph Pattern)

Model complex workflows as state machines with:
- **Nodes:** Processing steps (each phase is a node)
- **Edges:** Transitions with conditions (approval gates)
- **State:** Accumulated context (receipts)
- **Cycles:** Error recovery loops back to earlier phases

Kraken's pipeline IS a state machine: `P1 → P2 → ... → P10` with gates and rollback capability.

## Experience Learning (TaskWeaver Pattern)

After completing a task, extract reusable experience:
- What worked well? → Add to conventions
- What failed? → Add to anti-rationalization
- What was unexpected? → Add to risk catalog
- What pattern emerged? → Codify for future use
