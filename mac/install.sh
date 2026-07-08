#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# OpenCode-oppsett for Mac
#
# Installerer Homebrew (hvis det mangler) og deretter de samme verktoyene som
# Windows-scriptet: Node.js, Git, GitHub CLI, Azure CLI, OpenCode og skills.
#
# Kjor med en enkelt kommando i Terminal:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/trondstromlie/onboarding-opencode/main/mac/install.sh)"
# ─────────────────────────────────────────────────────────────────────────────

set -u

README_URL="https://github.com/trondstromlie/onboarding-opencode#steg-4--start-opencode"

# ── farger ──────────────────────────────────────────────────────────────────
if [ -t 1 ]; then
    CYAN="\033[36m"; GREEN="\033[32m"; YELLOW="\033[33m"; RED="\033[31m"; GRAY="\033[90m"; RESET="\033[0m"
else
    CYAN=""; GREEN=""; YELLOW=""; RED=""; GRAY=""; RESET=""
fi

step() { printf "\n${CYAN}  --> %s${RESET}\n" "$1"; }
ok()   { printf "${GREEN}      Ferdig: %s${RESET}\n" "$1"; }
warn() { printf "${YELLOW}  %s${RESET}\n" "$1"; }
fail() {
    printf "\n${RED}  FEIL: %s${RESET}\n" "$1"
    printf "${YELLOW}  Prov a kjore kommandoen en gang til -- det som allerede er${RESET}\n"
    printf "${YELLOW}  installert hoppes over. Funker det ikke: %s${RESET}\n" "$README_URL"
    exit 1
}

# ── intro ───────────────────────────────────────────────────────────────────
clear 2>/dev/null || true
printf "\n"
printf "${GREEN}  Gjor meg klar til a installere pakker for deg...${RESET}\n"
printf "${GRAY}  -------------------------------------------------------${RESET}\n\n"
warn "NB: Dette kan ta flere minutter -- spesielt Azure CLI er stor."
warn "La vinduet sta apent og vent. Blir du bedt om passordet ditt,"
warn "er det Mac-passordet du bruker for a logge inn. Hvis noe feiler:"
warn "kjor kommandoen en gang til -- det som er installert hoppes over."
printf "\n"
sleep 2

# ── [1/3] Homebrew ──────────────────────────────────────────────────────────
if command -v brew >/dev/null 2>&1; then
    step "Homebrew er allerede installert -- hopper over"
else
    step "Installerer Homebrew (pakkeverktoyet for Mac)..."
    warn "Du kan bli bedt om Mac-passordet ditt underveis."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
        || fail "Klarte ikke installere Homebrew. Sjekk internett og prov igjen."
    ok "Homebrew er installert"
fi

# Sorg for at brew er tilgjengelig i denne okten (Apple Silicon + Intel).
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

command -v brew >/dev/null 2>&1 || fail "Finner ikke brew etter installasjon. Lukk Terminal, apne pa nytt og prov igjen."

# Legg brew i zsh-profilen sa den er der neste gang ogsa.
BREW_PREFIX="$(brew --prefix)"
SHELLENV_LINE="eval \"\$(${BREW_PREFIX}/bin/brew shellenv)\""
if [ -n "${HOME:-}" ] && ! grep -qF "$SHELLENV_LINE" "$HOME/.zprofile" 2>/dev/null; then
    printf '%s\n' "$SHELLENV_LINE" >> "$HOME/.zprofile"
fi

# ── [2/3] Verktoy via Homebrew ──────────────────────────────────────────────
step "Installerer verktoy: Node.js, Git, GitHub CLI, Azure CLI, OpenCode..."
warn "Dette kan ta noen minutter. La vinduet sta apent."
for pkg in node git gh azure-cli opencode; do
    if brew list --formula "$pkg" >/dev/null 2>&1; then
        printf "${GRAY}      %s er allerede installert -- hopper over${RESET}\n" "$pkg"
    else
        printf "${GRAY}      Installerer %s...${RESET}\n" "$pkg"
        brew install "$pkg" || fail "Klarte ikke installere $pkg."
    fi
done
ok "Alle verktoy er installert"

# ── [3/3] OpenCode skills ───────────────────────────────────────────────────
step "Installerer OpenCode skills..."
if npx --yes opencode-setup; then
    ok "Skills er installert"
else
    warn "NB: Klarte ikke installere skills automatisk."
    warn "    Du kan installere dem senere ved a kjore: npx opencode-setup"
fi

# ── ferdig ──────────────────────────────────────────────────────────────────
printf "\n"
printf "${GRAY}  -------------------------------------------------------${RESET}\n"
printf "${GREEN}  Alt er klart! Installerte verktoy:${RESET}\n"
printf "${GREEN}    - Node.js${RESET}\n"
printf "${GREEN}    - Git${RESET}\n"
printf "${GREEN}    - GitHub CLI${RESET}\n"
printf "${GREEN}    - Azure CLI${RESET}\n"
printf "${GREEN}    - OpenCode${RESET}\n"
printf "${GREEN}    - OpenCode skills${RESET}\n"
printf "${GRAY}  -------------------------------------------------------${RESET}\n\n"
printf "${GREEN}  Installasjonen er fullfort som planlagt!${RESET}\n"
printf "${GREEN}  Du kan na fortsette fra Steg 4 i oppskriften (Start OpenCode).${RESET}\n\n"
printf "${GREEN}  Apner Steg 4 i oppskriften...${RESET}\n\n"
sleep 2
open "$README_URL" 2>/dev/null || true
