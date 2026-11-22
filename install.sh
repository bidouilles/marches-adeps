#!/bin/sh
# Installe marches-adeps : la commande dans ~/.local/bin et le skill pour
# Claude Code (~/.claude/skills) et/ou Hermes (~/.hermes/skills/leisure).
# Usage : sh install.sh ["adresse par défaut"]
set -eu
REPO="$(cd -P "$(dirname "$0")" && pwd)"
BIN="$HOME/.local/bin"

chmod +x "$REPO/marches-adeps"
mkdir -p "$BIN"
ln -sfn "$REPO/marches-adeps" "$BIN/marches-adeps"
echo "commande : $BIN/marches-adeps -> $REPO/marches-adeps"

lier_skill() { # $1 = dossier cible
  mkdir -p "$(dirname "$1")"
  if [ -e "$1" ] && [ ! -L "$1" ]; then
    echo "ignoré : $1 existe déjà et n'est pas un lien" >&2
    return
  fi
  ln -sfn "$REPO/skill" "$1"
  echo "skill    : $1 -> $REPO/skill"
}
[ -d "$HOME/.claude" ] && lier_skill "$HOME/.claude/skills/marches-adeps"
[ -d "$HOME/.hermes/skills" ] && lier_skill "$HOME/.hermes/skills/leisure/marches-adeps"

if [ $# -ge 1 ] && [ -n "$1" ]; then
  "$REPO/marches-adeps" --enregistrer --adresse "$1"
fi

case ":$PATH:" in
  *":$BIN:"*) ;;
  *) echo "attention : $BIN n'est pas dans le PATH" >&2 ;;
esac
