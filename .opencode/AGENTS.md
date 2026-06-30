# Prosjektinstrukser

## Oppdatere skills

Når brukeren ber deg "oppdatere skills" betyr det alltid dette:

1. Oppdater skillsene i dette repoet (`skills/`) med innholdet fra de lokale skillsene (`~/.agents/skills/`, `~/.claude/skills/`, `~/.config/opencode/skills/`)
2. Sjekk diff mellom repo og lokale filer for å finne hva som har endret seg
3. Skriv endringene til riktige filer under `skills/` i dette repoet
4. Be brukeren pushe til GitHub og publisere til npm:
   ```
   git add -A && git commit -m "chore: oppdater skills" && git push
   npm version patch && npm publish
   ```
5. Verifiser at skillsene er oppdatert ved å kjøre `npx opencode-setup@latest --dry-run` eller tilsvarende

Skills som hører til dette repoet (ikke kopier andre):
- `github-setup`
- `install-mcp`
- `piwik-analytics`
