# 🦑 Kraken v8.2

10-phase dev pipeline for Claude Code. 3 core dependencies. 49% smaller than v7.2.

## Dependencies

| Tool | Purpose | Required |
|------|---------|----------|
| **lean-ctx** | Transparent CLI token compression | Yes (must be running) |
| **cognee** | Knowledge graph memory across sessions | Yes |
| **ruflo** | Agent swarm orchestration | Yes |
| spec-kit | Spec-driven development | Medium+ tasks only |
| playwright, git, browser, magic-ui, aws, genai-toolbox | Phase-specific MCPs | Optional with fallbacks |

## Pipeline

```
RECEIVE → BRAINSTORM → DECOMPOSE → PLAN → DESIGN-UI → IMPLEMENT → SECURITY → REVIEW → OPTIMIZE → VERIFY
  P1        P2(3 agents)  P3        P4       P5        P6(5 agents)  P7       P8       P9       P10
```

## Key Decisions in v8.2

- **lean-ctx** replaces RTK — transparent, no command mapping needed
- **cognee** replaces claude-mem + vector-mcp-go — one memory system, graph+vector
- **ruflo** replaces praison + separate orchestration — single swarm coordinator
- **archon** removed — agent quality checks absorbed inline (3 lines)
- **Constitution** replaces hardcoded rules — loadable per project
- **spec-kit** conditional — only for medium+ complexity

## Install

```bash
git clone https://github.com/jawher-khiari/krakenSkill.git
cd krakenSkill && chmod +x install.sh && ./install.sh
```

## Token Budget

| Version | Context | Dependencies | Phase Detail |
|---------|---------|-------------|-------------|
| v7.2 | ~13,888 tokens | 13 MCP tools | Full |
| v8.1 | ~3,209 tokens | 7 deps | Over-compressed |
| **v8.2** | **~7,072 tokens** | **3 deps** | **Full (restored)** |

v8.2 is the sweet spot: half of v7.2's context, full phase detail, fewer failure points.
