#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# OpenCode-oppsett for Mac
#
# Installerer de samme verktoyene som Windows-scriptet: Node.js, Git,
# GitHub CLI, Azure CLI, OpenCode og skills.
#
# Homebrew ma vaere installert forst. Det krever administratortilgang
# (hengelas-ikonet i oppgavelinjen), sa scriptet kan ikke gjore det for deg --
# mangler brew forklarer scriptet hvordan du installerer det.
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
BREW_INSTALL_CMD='/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

# Homebrew krever administratortilgang. Pa jobb-Macer har du den ikke fast --
# du ma be om den forst via hengelas-ikonet i oppgavelinjen (Privileges).
has_admin() {
    dsmemberutil checkmembership -U "$(id -un)" -G admin 2>/dev/null | grep -qi "is a member" && return 0
    id -Gn 2>/dev/null | tr ' ' '\n' | grep -qx admin
}

homebrew_manual_steps() {
    printf "\n${YELLOW}  Homebrew ma installeres for hand forst -- det krever administratortilgang.${RESET}\n\n"
    printf "${CYAN}  Gjor dette:${RESET}\n"
    printf "    1. Klikk pa ${CYAN}hengelas-ikonet${RESET} i oppgavelinjen (Privileges)\n"
    printf "       og be om administratortilgang.\n"
    printf "    2. Lim inn denne kommandoen i Terminal og trykk Enter:\n\n"
    printf "${GREEN}       %s${RESET}\n\n" "$BREW_INSTALL_CMD"
    printf "    3. Blir du bedt om passord, skriv ${CYAN}nokkelring-passordet${RESET} ditt\n"
    printf "       (det samme som du logger inn pa Macen med) og godkjenn.\n"
    printf "       Passordet vises ikke mens du skriver -- det er normalt.\n"
    printf "    4. Nar Homebrew er ferdig, kjor denne kommandoen en gang til:\n\n"
    printf "${GREEN}       /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/trondstromlie/onboarding-opencode/main/mac/install.sh)\"${RESET}\n\n"
    printf "${GRAY}  Mer hjelp: %s${RESET}\n\n" "$README_URL"
}

if command -v brew >/dev/null 2>&1; then
    step "Homebrew er allerede installert -- hopper over"
elif [ -x /opt/homebrew/bin/brew ] || [ -x /usr/local/bin/brew ]; then
    step "Homebrew er allerede installert -- hopper over"
elif has_admin; then
    step "Installerer Homebrew (pakkeverktoyet for Mac)..."
    warn "Du kan bli bedt om nokkelring-passordet ditt underveis (Mac-passordet)."
    if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        homebrew_manual_steps
        exit 1
    fi
    ok "Homebrew er installert"
else
    step "Homebrew mangler, og du har ikke administratortilgang akkurat na"
    homebrew_manual_steps
    exit 1
fi

# Sorg for at brew er tilgjengelig i denne okten (Apple Silicon + Intel).
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

if ! command -v brew >/dev/null 2>&1; then
    printf "\n${RED}  Finner ikke Homebrew (brew) i denne okten.${RESET}\n"
    homebrew_manual_steps
    exit 1
fi

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
