# Kraken Skill Repository

This repository contains the Kraken v5 development skill — a 10-phase pipeline for structured software development with MCP tool integration and ultrarag knowledge retrieval.

## Project Structure

- `kraken/SKILL.md` — The main skill definition (source of truth)
- `knowledge/` — 7 knowledge base documents for ultrarag ingestion
- `install.sh` — Cross-platform installer (OpenCode, Claude Code, Codex)

## Development Guidelines

When modifying this skill:
- The `name` field in SKILL.md frontmatter MUST match the directory name (`kraken`)
- The `name` must be lowercase alphanumeric with hyphens only
- The `description` must be ≤1024 characters
- Knowledge files in `knowledge/` are designed for chunked retrieval — keep sections self-contained
- Test any changes by running the skill against a sample task before committing

## Skill Format Compatibility

This skill is compatible with:
- **OpenCode** — `.opencode/skills/kraken/SKILL.md`
- **Claude Code** — `.claude/skills/kraken/SKILL.md`
- **Codex** — `.agents/skills/kraken/SKILL.md`

The SKILL.md uses the shared frontmatter format (name, description, license, compatibility, metadata).
