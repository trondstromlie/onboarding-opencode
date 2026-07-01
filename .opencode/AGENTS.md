# Prosjektinstrukser

## Viktige regler

- **Push aldri direkte til main** — main har branch protection. Lag alltid en branch og PR.
- **npm publish** krever at versjonen er bumped (`npm version patch`) og at endringene er merget til main først.
- Etter merge: hent main lokalt (`git checkout main && git pull`) og publiser.

---

## Oppdatere skills

Når brukeren ber deg "oppdatere skills" betyr det alltid dette:

1. Oppdater skillsene i dette repoet (`skills/`) med innholdet fra de lokale skillsene (`~/.agents/skills/`, `~/.claude/skills/`, `~/.config/opencode/skills/`)
2. Sjekk diff mellom repo og lokale filer for å finne hva som har endret seg
3. Skriv endringene til riktige filer under `skills/` i dette repoet
4. Lag en branch og PR — ikke push direkte til main
5. Etter merge: hent main, bump versjon og publiser til npm

Skills som hører til dette repoet (ikke kopier andre):
- `github-setup`
- `install-mcp`
- `piwik-analytics`
- `figma-mcp`
- `onboarding`
