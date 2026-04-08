# Kraken Context Engineering Reference

> Absorbed from [muratcankoylan/agent-skills-for-context-engineering](https://github.com/muratcankoylan/agent-skills-for-context-engineering) — context-degradation, context-compression, memory-systems skills.

## Context Degradation Patterns

### 1. Lost-in-Middle
Critical information in the middle of long context gets 10-40% reduced recall accuracy (U-shaped attention curve).
- **Mitigation:** Place critical info at beginning and end. Add summary headers. Prepend key findings, append conclusions.
- **Detection:** Model ignores correct information that exists in context; responses contradict provided data.

### 2. Context Poisoning
Hallucination, tool error, or incorrect fact enters context and compounds through self-reference.
- **Mitigation:** Validate all external inputs before context entry. Track claim provenance.
- **Recovery:** Truncate to before poisoning point. Do NOT layer corrections — remove the poison.
- **Detection:** Degraded quality on previously-successful tasks, persistent hallucinations despite correction.

### 3. Context Distraction
Even ONE irrelevant document triggers measurable performance degradation (step function, not linear).
- **Mitigation:** Filter aggressively before loading. Move "might need" info behind tool calls. Prefer retrieval over pre-loading.

### 4. Context Confusion
Model applies wrong-context constraints when multiple task types coexist in one context.
- **Mitigation:** Segment different tasks into separate context windows. Use explicit "context reset" markers.
- **Detection:** Tool calls appropriate for a different task; outputs mixing requirements from multiple sources.

### 5. Context Clash
Multiple correct-but-contradictory sources (version conflicts, perspective differences).
- **Mitigation:** Establish source priority rules BEFORE conflicts arise. Filter outdated versions. Mark contradictions explicitly.

## Context Compression Strategies

### Optimize for Tokens-Per-Task, Not Tokens-Per-Request
Total tokens from task start to completion matters, not per-request savings. Aggressive compression that drops file paths, error messages, or decisions forces costly re-exploration.

### Anchored Iterative Summarization (Preferred)
For long sessions: maintain structured, persistent summaries with mandatory sections. When compression triggers, summarize only newly-truncated span and MERGE with existing summary.

### Mandatory Summary Sections
```
## Session Intent — what the user is trying to accomplish
## Files Modified — full paths + what changed (function names, not just files)
## Decisions Made — architectural/design choices with rationale
## Current State — what works, what's broken, numbers
## Next Steps — ordered list
```

### Artifact Trail Problem
Artifact trail integrity scores only 2.2-2.5/5.0 across all compression methods. Explicitly preserve:
- Files created (full paths)
- Files modified + what changed (function names)
- Files read but not changed
- Specific identifiers: function names, variable names, error messages, error codes

## Memory Architecture Layers

| Layer | Persistence | Use When |
|---|---|---|
| Working | Context window only | Always — scratchpad in system prompt |
| Short-term | Session-scoped | Intermediate tool results, conversation state |
| Long-term | Cross-session | User preferences, domain knowledge |
| Entity | Cross-session | Identity consistency across conversations |
| Temporal KG | Cross-session + history | Facts that change over time |

**Rule:** Pick the shallowest layer that satisfies the need. Each deeper layer adds complexity.

## Kraken Application

- **Phase 1-2:** Apply lost-in-middle mitigation when presenting requirement cards and approaches
- **Phase 6:** Use artifact trail preservation in every receipt
- **Phase 8-9:** Watch for context confusion when review crosses multiple domains
- **Error Recovery:** Use anchored iterative summarization for session continuity
- **Receipt System:** Already implements context compression — receipts ARE the anchored summaries
