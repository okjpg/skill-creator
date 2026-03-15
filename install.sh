#!/usr/bin/env bash
set -e

REPO="https://raw.githubusercontent.com/okjpg/skill-creator/main"
SKILL_NAME="criar-skill"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
err()  { echo -e "${RED}✗${NC} $1"; }

echo ""
echo "skill-creator — instalador"
echo "github.com/okjpg/skill-creator"
echo "────────────────────────────────"
echo ""

# ── Funções de download ─────────────────────────────────────────────────────

download() {
  local url="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  if command -v curl &>/dev/null; then
    curl -fsSL "$url" -o "$dest"
  elif command -v wget &>/dev/null; then
    wget -q "$url" -O "$dest"
  else
    err "curl e wget não encontrados. Instale um deles e tente novamente."
    exit 1
  fi
}

install_files() {
  local base_dir="$1"
  download "$REPO/SKILL.md"                        "$base_dir/SKILL.md"
  download "$REPO/references/skill-anatomy.md"     "$base_dir/references/skill-anatomy.md"
  download "$REPO/references/guia-refinamento.md"  "$base_dir/references/guia-refinamento.md"
  download "$REPO/evals/evals.json"                "$base_dir/evals/evals.json"
}

# ── Claude Code ─────────────────────────────────────────────────────────────

install_claude_code() {
  local dest="$HOME/.claude/skills/$SKILL_NAME"

  if [ -d "$dest" ]; then
    warn "Skill já instalada em $dest"
    read -r -p "  Sobrescrever? (s/N): " confirm < /dev/tty
    [[ "$confirm" =~ ^[sS]$ ]] || { warn "Pulando Claude Code."; return; }
  fi

  echo "  Instalando em $dest ..."
  install_files "$dest"
  ok "Claude Code — skill-creator instalada em ~/.claude/skills/$SKILL_NAME/"
  echo "     Use /criar-skill no Claude Code para começar."
}

# ── OpenClaw ─────────────────────────────────────────────────────────────────

find_openclaw_workspace() {
  # Tenta detectar automaticamente
  local base="/root/.openclaw"
  [ ! -d "$base" ] && base="$HOME/.openclaw"
  [ ! -d "$base" ] && return 1

  # Lista workspaces disponíveis
  local workspaces=()
  while IFS= read -r dir; do
    workspaces+=("$(basename "$dir")")
  done < <(find "$base" -maxdepth 1 -type d -name "workspace-*" 2>/dev/null)

  if [ ${#workspaces[@]} -eq 0 ]; then
    return 1
  elif [ ${#workspaces[@]} -eq 1 ]; then
    echo "$base/${workspaces[0]}"
  else
    echo "  Workspaces encontrados:" >&2
    for i in "${!workspaces[@]}"; do
      echo "    [$i] ${workspaces[$i]}" >&2
    done
    read -r -p "  Qual usar? [0]: " idx
    idx=${idx:-0}
    echo "$base/${workspaces[$idx]}"
  fi
}

install_openclaw() {
  local workspace
  workspace=$(find_openclaw_workspace 2>/dev/null || true)

  if [ -z "$workspace" ]; then
    warn "OpenClaw não encontrado — pulando."
    return
  fi

  local skills_dir="$workspace/skills/produtividade"
  local dest="$skills_dir/$SKILL_NAME.md"
  local index="$workspace/_index.md"
  local changelog="$workspace/_changelog.md"
  local today
  today=$(date +%Y-%m-%d)

  echo "  Workspace: $workspace"
  echo "  Instalando skill em $skills_dir ..."

  mkdir -p "$skills_dir"

  # Baixa o SKILL.md como arquivo único (formato OpenClaw é o mesmo conteúdo)
  download "$REPO/SKILL.md" "$dest"

  # Atualiza _index.md se existir
  if [ -f "$index" ]; then
    echo "| $SKILL_NAME | produtividade | $today | DRAFT |" >> "$index"
    ok "OpenClaw — _index.md atualizado"
  fi

  # Atualiza _changelog.md se existir
  if [ -f "$changelog" ]; then
    echo "" >> "$changelog"
    echo "## $today — $SKILL_NAME: DRAFT instalado via install.sh" >> "$changelog"
    ok "OpenClaw — _changelog.md atualizado"
  fi

  ok "OpenClaw — skill-creator instalada em $skills_dir/$SKILL_NAME.md"
  echo "     Use /criar-skill no seu agente OpenClaw para começar."
}

# ── Detecção de ambientes ────────────────────────────────────────────────────

CLAUDE_CODE=false
OPENCLAW=false

# Claude Code: ~/.claude/skills/ existe ou claude está instalado
if [ -d "$HOME/.claude" ] || command -v claude &>/dev/null; then
  CLAUDE_CODE=true
fi

# OpenClaw: diretório .openclaw existe
if [ -d "/root/.openclaw" ] || [ -d "$HOME/.openclaw" ]; then
  OPENCLAW=true
fi

# ── Instalação ───────────────────────────────────────────────────────────────

if [ "$CLAUDE_CODE" = false ] && [ "$OPENCLAW" = false ]; then
  err "Nenhum ambiente detectado (Claude Code ou OpenClaw)."
  echo ""
  echo "  Para Claude Code: instale em claude.ai/code e rode novamente."
  echo "  Para OpenClaw: verifique se ~/.openclaw/ existe."
  exit 1
fi

if [ "$CLAUDE_CODE" = true ]; then
  echo "Claude Code detectado"
  install_claude_code
  echo ""
fi

if [ "$OPENCLAW" = true ]; then
  echo "OpenClaw detectado"
  install_openclaw
  echo ""
fi

# ── Concluído ────────────────────────────────────────────────────────────────

echo "────────────────────────────────"
ok "Instalação concluída."
echo ""
echo "  Próximo passo: abra seu agente e digite /criar-skill"
echo "  Documentação: https://github.com/okjpg/skill-creator"
echo ""
