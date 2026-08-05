# Prosjektinstrukser

Prosjektinstruksene for dette repoet ligger i **`.opencode/AGENTS.md`** — les og følg den filen.

Kort oppsummert: `opencode-setup` er et npm-verktøy som installerer OpenCode-skills for ikke-utviklere. CLI-en ligger i `bin/cli.js`, skillsene i `skills/`, og brukerguiden i `README.md`.

De viktigste reglene (se AGENTS.md for detaljer):
- Push aldri direkte til main — lag alltid branch og PR, squash-merge.
- Versjonsbump skjer på egen branch, aldri blandet med feature-endringer.
- Hvis `windows/script.ps1` eller `windows/install.bat` endres: bygg ny zip og lag ny GitHub Release etter merge — det er dette brukerne laster ned.
