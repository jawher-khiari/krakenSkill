#!/bin/bash
set -e
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo -e "${BLUE}🦑 Kraken v8.2 Installer${NC}"
echo "========================"

# Skill
SKILLS="$HOME/.claude/skills"
mkdir -p "$SKILLS/kraken"
cp "$SCRIPT_DIR/kraken/SKILL.md" "$SKILLS/kraken/SKILL.md"
echo -e "${GREEN}✓${NC} Kraken skill installed"

# Knowledge
mkdir -p "$SKILLS/kraken/knowledge"
cp "$SCRIPT_DIR/knowledge/"*.md "$SKILLS/kraken/knowledge/" 2>/dev/null && \
  echo -e "${GREEN}✓${NC} Knowledge files installed" || true

# Checks
echo ""
echo -e "${YELLOW}Prerequisite checks:${NC}"
command -v lean-ctx &>/dev/null && echo -e "  ${GREEN}✓${NC} lean-ctx: $(lean-ctx --version 2>/dev/null || echo installed)" || echo -e "  ${YELLOW}⚠${NC} lean-ctx: not found — install from leanctx.com"
echo ""
echo -e "${YELLOW}MCP servers (install manually in Claude Code):${NC}"
echo "  claude mcp add ruflo -- npx ruflo@latest"
echo "  claude mcp add cognee -- npx cognee-mcp@latest"
echo "  claude mcp add playwright -- npx @anthropic/mcp-playwright"
echo "  claude mcp add git-server -- npx @anthropic/mcp-git"
echo "  claude mcp add browser -- npx @anthropic/mcp-puppeteer"
echo "  claude mcp add magic-ui -- npx @anthropic/mcp-magic"
echo "  claude mcp add aws -- npx @aws/mcp@latest"
echo "  claude mcp add genai-toolbox -- npx genai-toolbox@latest"
echo ""
echo -e "${YELLOW}For medium+ tasks, install spec-kit:${NC}"
echo "  uvx --from git+https://github.com/github/spec-kit.git specify init ."
echo ""
echo -e "${GREEN}Done. Restart Claude Code.${NC}"
