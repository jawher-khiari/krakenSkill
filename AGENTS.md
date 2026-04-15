# Kraken v8.3 — Subagent Specifications

## How Agents Work

Kraken uses Claude Code's `Task()` subagent system for real context isolation.
Each subagent runs in its own context window — it cannot see other agents' work
unless explicitly passed as input.

## Brainstorm Subagents (P2)

| Agent | Spawned Via | Receives | Output |
|-------|-----------|----------|--------|
| 🔍 Scanner | `Task("Scanner")` | P1 Receipt + project path | Codebase Profile + Pattern Guide |
| 🌐 Researcher | `Task("Researcher")` | P1 Receipt + detected stack name | Research Brief |
| 🎯 Critic | `Task("Critic")` | Scanner output + Researcher output + P1 Receipt | 3 Approaches + Recommendation |

**Flow:** Scanner + Researcher (parallel via Task) → Critic (sequential, needs both outputs)

## Implementation Subagents (P6)

| Agent | Spawned Via | Receives | Reports To |
|-------|-----------|----------|-----------|
| ✏️ Editor | `Task("Editor")` | Pattern Guide + P4 plan + P5 design | Guards |
| 🔄 Consistency Guard | `Task("ConsistencyGuard")` | Editor's code + existing codebase | Supervisor |
| 📏 Rules Guard | `Task("RulesGuard")` | Editor's code + Constitution rules | Supervisor |
| 👑 Supervisor | Main orchestrator (inline) | Both guard reports | User |

**Flow:** Editor → [ConsistencyGuard + RulesGuard] (parallel) → Supervisor → PASS/Fix loop

**Key rules:**
- Guards run in parallel with NO contact between them
- Rules Guard > Consistency Guard on conflicts
- New code follows Constitution even if old code doesn't
- Max 5 loop iterations before escalating to user

## Scaling

| Complexity | P2 Agents | P6 Agents |
|-----------|-----------|-----------|
| One-line fix | Skip (inline grep) | Editor only |
| Bug fix | Read analog (inline) | Editor + RulesGuard |
| Small+ | All 3 via Task() | All 4 via Task() |
