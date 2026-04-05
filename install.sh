#!/usr/bin/env bash
set -euo pipefail

# Kraken v5 — Cross-platform skill installer
# Supports: OpenCode, Claude Code, Codex, and any .agents-compatible tool

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="$SCRIPT_DIR/kraken/SKILL.md"
KNOWLEDGE_SRC="$SCRIPT_DIR/knowledge"

if [ ! -f "$SKILL_SRC" ]; then
    echo "❌ SKILL.md not found at $SKILL_SRC"
    echo "   Run this script from the krakenSkill repo root."
    exit 1
fi

echo "🦑 Kraken v5 — Skill Installer"
echo ""

# Detect platform
install_global() {
    local target="$1"
    mkdir -p "$(dirname "$target")"
    cp "$SKILL_SRC" "$target"
    echo "  ✅ Installed to $target"
}

install_knowledge() {
    local target_dir="$1"
    mkdir -p "$target_dir"
    cp "$KNOWLEDGE_SRC"/*.md "$target_dir/"
    echo "  ✅ Knowledge base copied to $target_dir"
}

echo "Select installation targets:"
echo ""
echo "  [1] Global — All platforms (OpenCode + Claude Code + Codex)"
echo "  [2] OpenCode only"
echo "  [3] Claude Code only"
echo "  [4] Project-local (current directory)"
echo "  [5] All of the above"
echo ""
read -rp "Choice [1-5]: " choice

case "$choice" in
    1|5)
        echo ""
        echo "Installing globally..."
        # OpenCode
        install_global "$HOME/.config/opencode/skills/kraken/SKILL.md"
        # Claude Code
        install_global "$HOME/.claude/skills/kraken/SKILL.md"
        # Agents (Codex + others)
        install_global "$HOME/.agents/skills/kraken/SKILL.md"
        ;;
    2)
        echo ""
        echo "Installing for OpenCode..."
        install_global "$HOME/.config/opencode/skills/kraken/SKILL.md"
        ;;
    3)
        echo ""
        echo "Installing for Claude Code..."
        install_global "$HOME/.claude/skills/kraken/SKILL.md"
        ;;
    4)
        echo ""
        echo "Installing to current project..."
        ;;
esac

if [ "$choice" = "4" ] || [ "$choice" = "5" ]; then
    echo ""
    echo "Installing project-local skills..."
    PROJECT_DIR="$(pwd)"
    # OpenCode project
    install_global "$PROJECT_DIR/.opencode/skills/kraken/SKILL.md"
    # Claude Code project
    install_global "$PROJECT_DIR/.claude/skills/kraken/SKILL.md"
    # Agents project
    install_global "$PROJECT_DIR/.agents/skills/kraken/SKILL.md"
fi

echo ""
echo "📚 Knowledge base (for ultrarag)..."
echo "   Knowledge files are in: $KNOWLEDGE_SRC"
echo "   Ingest these into your ultrarag instance for on-demand retrieval."
echo "   See README.md for ultrarag setup instructions."

echo ""
echo "🦑 Kraken v5 installed successfully!"
echo ""
echo "Test it:"
echo "  OpenCode:    opencode → type 'kraken build a health check endpoint'"
echo "  Claude Code: claude → type 'kraken build a health check endpoint'"
echo ""
