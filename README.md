# 🦑 The Kraken v5 — Ultrarag Edition

A 10-phase development pipeline skill that works across **OpenCode**, **Claude Code**, and **Codex**. Uses MCP tools at every phase and retrieves domain knowledge on-demand through ultrarag, reducing context consumption by ~54%.

## Architecture

```
┌─────────────────────────────────────────────┐
│  Context Window (~3,300 tokens)             │
│  SKILL.md — Procedures + Receipts + MCP Map │
└──────────────────┬──────────────────────────┘
                   │ on-demand queries (~200 tokens each)
┌──────────────────▼──────────────────────────┐
│  UltraRAG (~7,100 tokens stored)            │
│  7 knowledge docs: security, design,        │
│  patterns, review, planning, testing, optim │
└─────────────────────────────────────────────┘
```

## The 10-Phase Pipeline

```
RECEIVE → BRAINSTORM → DECOMPOSE → PLAN → DESIGN-UI → IMPLEMENT → SECURITY-AUDIT → REVIEW → OPTIMIZE → VERIFY
```

Every phase:
- Uses designated MCP tools (13 tools mapped)
- Emits a structured receipt with verification hash
- Requires explicit user approval before advancing
- Scales depth to task complexity (one-line fix = 2 min, full feature = hours)

## MCP Tools Used

| Category | Tools | Phases |
|---|---|---|
| Reasoning | `sequential-thinking`, `cort` | P1-P4, P7-P8 |
| Codebase | `desktop-commander`, `git-mcp-server`, `gitmcp` | P2, P6, P10 |
| Design | `figma`, `shadcn-ui` | P5, P6 |
| API | `openspec`, `postman` | P4-P7, P10 |
| Testing | `playwright`, `browser-tools`, `chrome-devtools` | P5, P7-P10 |
| Knowledge | `ultrarag` | P2, P4-P9 |

## Installation

### Quick Install (All Platforms)

```bash
git clone https://github.com/jawher-khiari/krakenSkill.git
cd krakenSkill
git checkout kraken-v2
chmod +x install.sh
./install.sh
```

### Manual Install — OpenCode

```bash
mkdir -p ~/.config/opencode/skills/kraken
cp kraken/SKILL.md ~/.config/opencode/skills/kraken/SKILL.md
```

### Manual Install — Claude Code

```bash
mkdir -p ~/.claude/skills/kraken
cp kraken/SKILL.md ~/.claude/skills/kraken/SKILL.md
```

### Manual Install — Codex / Agents

```bash
mkdir -p ~/.agents/skills/kraken
cp kraken/SKILL.md ~/.agents/skills/kraken/SKILL.md
```

### Project-Local Install

```bash
# In your project root:
mkdir -p .opencode/skills/kraken .claude/skills/kraken .agents/skills/kraken
cp /path/to/krakenSkill/kraken/SKILL.md .opencode/skills/kraken/
cp /path/to/krakenSkill/kraken/SKILL.md .claude/skills/kraken/
cp /path/to/krakenSkill/kraken/SKILL.md .agents/skills/kraken/
```

## UltraRAG Setup (Optional but Recommended)

The `knowledge/` directory contains 7 documents designed for ultrarag ingestion. Without ultrarag, the skill uses built-in model knowledge as fallback.

### Setup Steps

1. Ensure your ultrarag Docker container is running
2. Ingest the knowledge files:
   - Create a collection named `kraken-knowledge`
   - Upload all 7 files from `knowledge/`
   - Recommended chunking: `chunk_size=500, chunk_overlap=50`
3. Verify: query `"OWASP injection prevention"` should return relevant content

### Knowledge Files

| File | Content | Used By |
|---|---|---|
| `kraken-security.md` | OWASP Top 10, 9 security passes, threat modeling, root cause analysis | Phase 7 |
| `kraken-design.md` | WCAG 2.2 AA, design principles, state matrix, API contracts | Phase 5 |
| `kraken-patterns.md` | Code quality rules, design patterns, naming, error handling | Phase 6 |
| `kraken-review.md` | SOLID assessment, code smells, 7-pass review, complexity thresholds | Phase 8 |
| `kraken-planning.md` | INVEST criteria, vertical slicing, estimation, scalability strategy | Phase 4 |
| `kraken-testing.md` | Testing pyramid, Arrange/Act/Assert, test grouping, coverage | Phase 6, 10 |
| `kraken-optimization.md` | Refactoring patterns, Rule of Three, breaking change detection | Phase 9 |

## Usage

```
kraken build user authentication system
kraken refactor the product catalog
kraken design the checkout flow
kraken implement OAuth integration
kraken optimize the search API
kraken fix the pagination bug
kraken secure the file upload endpoint
```

## Prompt Library Integration

This skill integrates patterns from [xixu-me/prompt-library](https://github.com/xixu-me/prompt-library/tree/main/development):

| Prompt | Pattern Integrated | Phase |
|---|---|---|
| `architecture-planner` | Structured requirements (functional/non-functional/constraints) | P1, P4 |
| `code-review` | Priority levels (Critical/High/Medium/Low), positive aspects | P8 |
| `bug-hunter` | Root cause analysis, fix, prevention | P7 |
| `refactoring-assistant` | SOLID assessment, code smell detection, breaking changes | P8, P9 |
| `test-case-generator` | Arrange/Act/Assert, test grouping by scenario type | P6 |
| `documentation-generator` | API doc standard (7 required fields), doc verification | P5, P10 |

## Version History

| Version | What Changed |
|---|---|
| v1 | Original 290-line philosophical guide |
| v2 | Structured output templates, exit gates |
| v3 | Receipt + Recall memory system, hash verification |
| v4 | 13 MCP tools mapped to all phases |
| v5 | Ultrarag knowledge externalization, prompt library integration, OpenCode compatibility |

## License

MIT License — see [LICENSE](LICENSE)
