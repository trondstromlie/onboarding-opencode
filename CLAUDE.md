# Prosjektinstrukser

Prosjektinstruksene for dette repoet ligger i **`.opencode/AGENTS.md`** — les og følg den filen.

Kort oppsummert: `opencode-setup` hjelper ikke-utviklere med å sette opp OpenCode og gjøre maskinen klar for agentisk koding — GitHub-tilgang, installasjon, skills og MCP-servere. `README.md` er selve brukerguiden gjennom hele oppsettet; npm-CLI-en i `bin/cli.js` dekker skills-steget og installerer skillsene fra `skills/`.

De viktigste reglene (se AGENTS.md for detaljer):
- Push aldri direkte til main — lag alltid branch og PR, squash-merge.
- Versjonsbump skjer på egen branch, aldri blandet med feature-endringer.
- Hvis `windows/script.ps1` eller `windows/install.bat` endres: bygg ny zip og lag ny GitHub Release etter merge — det er dette brukerne laster ned.
