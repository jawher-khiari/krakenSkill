# Kraken Prompt Engineering & Reasoning Reference

> Absorbed from [dair-ai/prompt-engineering-guide](https://github.com/dair-ai/prompt-engineering-guide), [ckelsoe/claude-skill-prompt-architect](https://github.com/ckelsoe/claude-skill-prompt-architect).

## Reasoning Techniques (use in P1-P4 for complex decisions)

### Chain of Thought (CoT)
Break complex reasoning into explicit steps. Use "Let's think step by step" or show worked examples.
- **When:** Any multi-step reasoning, math, logic, debugging
- **How:** Force intermediate reasoning steps before conclusion

### Tree of Thought (ToT)
Explore multiple reasoning paths, evaluate each, backtrack from dead ends.
- **When:** Decisions with 3+ viable approaches (Phase 2 BRAINSTORM)
- **How:** Generate 3 candidate solutions → evaluate each → select best → verify

### ReAct (Reason + Act)
Interleave reasoning with tool use: Think → Act → Observe → Think → Act.
- **When:** Tool-heavy phases (P6-P10)
- **How:** Explicit reasoning before every tool call, observation after

### Step-Back Prompting
Abstract to a higher-level principle before solving the specific problem.
- **When:** Stuck on implementation details (P4, P6)
- **How:** "What general principle applies here?" → then apply to specific case

### Self-Consistency
Generate multiple independent solutions, then pick the most common answer.
- **When:** Critical decisions where confidence matters (P4 security annotations, P7 threat levels)

## Prompt Quality Dimensions

Evaluate every prompt/instruction across 5 axes:
1. **Clarity** — Unambiguous, single interpretation
2. **Specificity** — Concrete enough to act on
3. **Context** — Sufficient background provided
4. **Completeness** — All necessary information included
5. **Structure** — Well-organized, scannable

## Prompt Frameworks (for different intent types)

| Intent | Framework | Pattern |
|---|---|---|
| Analysis/Research | CO-STAR | Context → Objective → Style → Tone → Audience → Response |
| Multi-step Process | RISEN | Role → Instructions → Steps → End goal → Narrowing |
| Simple Expert Task | RACE | Role → Action → Context → Expectation |
| Decision Making | Tree of Thought | Explore → Evaluate → Backtrack → Select |
| Tool-Use Tasks | ReAct | Reason → Act → Observe → Repeat |
| Transformation | BAB | Before → After → Bridge |

## Anti-Patterns in Prompting

- **Vague instructions:** "Make it better" → "Reduce cyclomatic complexity below 10 by extracting guard clauses"
- **Missing context:** Asking to review code without providing the code or its purpose
- **Implicit expectations:** Assuming the agent knows your conventions without stating them
- **Overloaded prompts:** Asking for 5 unrelated things in one prompt → context confusion
- **Negative-only framing:** "Don't use X" without saying what TO use instead

## Kraken Application

| Phase | Technique | Purpose |
|---|---|---|
| P1: RECEIVE | CO-STAR | Structure requirement gathering |
| P2: BRAINSTORM | Tree of Thought | Explore 3 approaches systematically |
| P3: DECOMPOSE | Chain of Thought | Trace dependencies step by step |
| P4: PLAN | Step-Back | Abstract to patterns before specifics |
| P6: IMPLEMENT | ReAct | Reason before every code action |
| P7: SECURITY | Self-Consistency | Multiple independent threat assessments |
| P8: REVIEW | Chain of Thought | Structured per-pass reasoning |
| P9: OPTIMIZE | Step-Back | "What principle drives this optimization?" |
