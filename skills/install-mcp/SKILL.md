---
name: install-mcp
description: Hjelper brukeren med å installere MCP-servere i OpenCode. Bruk når noen spør om å installere GitHub MCP, Jira MCP, Figma MCP, Piwik MCP, eller kombinasjoner. Trigger på ord som "installer mcp", "jeg vil ha jira mcp", "legg til github mcp", "koble til jira", "koble til github", "koble til figma", "sett opp mcp", "figma mcp", "koble til piwik", "piwik mcp", "sett opp piwik". Miro MCP og Grafana MCP er ikke tilgjengelig for organisasjonen — si fra om det hvis noen spør.
---

# Installer MCP-servere i OpenCode

Følg denne flyten nøyaktig. Still ett spørsmål om gangen. Vent på svar før du går videre.

---

## Sjekk først — ikke installer det som allerede er på plass

Før du gjør noe annet: les `~/.config/opencode/opencode.jsonc` og sjekk hvilke MCP-blokker som allerede finnes under `mcp`.

Lag en liste over hva som er installert og hva som mangler:

| Tjeneste | Nøkkel i konfig | Status |
|---|---|---|
| GitHub | `github` | installert / mangler |
| Jira | `atlassian-jira` | installert / mangler |
| Figma | `figma` | installert / mangler |
| Piwik Pro | `piwik-pro` | installert / mangler |

Hvis brukeren ba om å installere noe som allerede er der, si fra:

> Det ser ut som [tjeneste] allerede er koblet til. Vil du teste at det virker, eller er det noe som ikke fungerer som det skal?

Ikke gå videre med installasjon for tjenester som allerede er satt opp. Hopp direkte til de som mangler.

---

## Steg 0 — Finn ut hvilket OS brukeren har

Før du gjør noe annet, sjekk hvilket operativsystem brukeren kjører. Spør hvis du ikke vet:

> Kjører du **macOS/Linux** eller **Windows**?

**Konfig-sti per OS:**
- macOS/Linux: `~/.config/opencode/opencode.jsonc`
- Windows: `%APPDATA%\opencode\opencode.jsonc` (typisk `C:\Users\<brukernavn>\AppData\Roaming\opencode\opencode.jsonc`)

**Viktig for Windows-brukere:** Windows-brukere har typisk ikke administratortilgang. Tokens lagres derfor **direkte i OpenCode-konfigen** som strenger under `environment`, i stedet for via `{env:VARIABELNAVN}`. Dette er trygt så lenge konfig-filen ikke deles eller sjekkes inn i versjonskontroll.

---

## Tokens skal aldri limes inn i chatten

Et token er som et passord. Det skal ikke stå i chatten — der kan det bli lagret og vist igjen senere. Derfor ber du **aldri** brukeren lime inn et token her. Du henter det selv fra utklippstavlen.

Slik sier du det til brukeren når de skal kopiere et token:

> Trykk på kopier-knappen ved siden av tokenet.
>
> **Ikke lim det inn her i chatten.** Jeg henter det rett fra utklippstavlen din — det er tryggere.
>
> Si «kopiert» når du har gjort det.

Når brukeren sier «kopiert»:

1. **Sjekk at det ligger noe der — uten å vise det.** Skriv aldri ut selve verdien.

   macOS/Linux:
   ```bash
   pbpaste | tr -d '[:space:]' | grep -qE '^PREFIKS' && echo "TOKEN_FUNNET" || echo "IKKE_FUNNET"
   ```
   Windows:
   ```powershell
   if ((Get-Clipboard -Raw).Trim() -match '^PREFIKS') { "TOKEN_FUNNET" } else { "IKKE_FUNNET" }
   ```
   Bytt `PREFIKS` med starten på tokenet (står ved hver tjeneste under). Har tokenet ingen fast start, bruk `.{20,}` — det sjekker bare at det er langt nok.

2. **Fortell brukeren hva du ser:**
   - `TOKEN_FUNNET`: «Jeg ser tokenet på utklippstavlen din. Jeg lagrer det nå — uten å vise det her.»
   - `IKKE_FUNNET`: «Jeg finner ikke tokenet på utklippstavlen. Kan du trykke på kopier-knappen én gang til?» Ikke be dem lime det inn.

3. **Lagre det rett fra utklippstavlen** med kommandoen som står ved hver tjeneste. Tokenet går fra utklippstavlen og rett inn i fila — det havner aldri i chatten.

4. **Tøm utklippstavlen etterpå**, og si fra: «Jeg har tømt utklippstavlen, så tokenet ikke blir liggende der.»
   - macOS/Linux: `pbcopy < /dev/null`
   - Windows: `Set-Clipboard -Value $null`

**Hvis brukeren likevel limer et token inn i chatten:** Ikke gjenta det. Si vennlig at det er best å lage et nytt token, siden dette nå står i chatten — og led dem gjennom å lage et nytt og kopiere det.

**Leser eller sjekker du filer med tokens i** (`~/.zshrc`, `~/.npmrc`, konfigen): skriv aldri ut verdien. Sjekk bare at den finnes, f.eks. med `grep -c`.

### Windows: slik havner tokenet i konfigen

På Windows står tokenet direkte i konfigen. Skriv konfigen med en tydelig plassholder (f.eks. `FIGMA_TOKEN_HER`) slik du ellers ville gjort. Bytt så plassholderen med tokenet fra utklippstavlen — i PowerShell, så du aldri ser verdien:

```powershell
$p = "$env:APPDATA\opencode\opencode.jsonc"
$t = (Get-Clipboard -Raw).Trim()
$innhold = [IO.File]::ReadAllText($p).Replace("FIGMA_TOKEN_HER", $t)
[IO.File]::WriteAllText($p, $innhold, (New-Object Text.UTF8Encoding $false))
```

Bytt `FIGMA_TOKEN_HER` med plassholderen for tjenesten. Har tjenesten to hemmeligheter (Piwik), gjør du én om gangen: kopier, bytt, kopier neste, bytt.

---

## Steg 1 — Spør hva de vil installere

> Hva vil du koble til?
> - **GitHub** — lar meg lese og opprette issues, PRs og kode på GitHub
> - **Jira** — lar meg lese og oppdatere Jira-tickets
> - **Figma** — lar meg lese design og hjelpe deg å implementere dem i kode
> - **Piwik Pro** — lar meg hente besøksstatistikk og analysere trafikk
> - Flere av disse, eller **alle**

**Miro og Grafana** er ikke tilgjengelig for organisasjonen enda — si fra hvis brukeren spør om disse.

---

## Steg 2 — Hent token(s)

Hent bare tokens for de tjenestene brukeren valgte.

### GitHub-token

GitHub CLI er allerede installert og autentisert. Da trenger brukeren ikke kopiere noe — du henter tokenet selv, rett inn i fila. Kjør aldri `gh auth token` alene, for da skrives tokenet ut i chatten.

**macOS/Linux:**
```bash
echo "export GITHUB_TOKEN=\"$(gh auth token)\"" >> ~/.zshrc && source ~/.zshrc
```

**Windows:** skriv GitHub-blokken i Steg 3 med plassholderen `GITHUB_TOKEN_HER`, og bytt den så rett fra `gh`:
```powershell
$p = "$env:APPDATA\opencode\opencode.jsonc"
$innhold = [IO.File]::ReadAllText($p).Replace("GITHUB_TOKEN_HER", (gh auth token).Trim())
[IO.File]::WriteAllText($p, $innhold, (New-Object Text.UTF8Encoding $false))
```

Sjekk først at brukeren er logget inn — uten å skrive ut tokenet:
```bash
gh auth status
```
Hvis brukeren ikke er logget inn, be dem kjøre dette i et eget terminalvindu:
```bash
gh auth login
```
Velg **GitHub.com** og følg instruksjonene, og sjekk `gh auth status` på nytt.

---

### Jira-token og innstillinger

Sjekk først konfig-filen for en eksisterende Jira MCP-blokk. Hvis brukeren allerede har Jira koblet til med en annen pakke, anbefal å bytte til `@aashari/mcp-server-atlassian-jira` og gjenbruk eksisterende token/e-post.

Hvis ikke fra før — be brukeren om tre ting:

**1. Jira API-token:**
> 1. Gå til: https://id.atlassian.com/manage-profile/security/api-tokens
> 2. Klikk **"Opprett API-token"**, gi det navn `opencode`, varighet **1 år**
> 3. Trykk **Kopier** — men ikke lim det inn i chatten. Si «kopiert», så henter jeg det fra utklippstavlen.

Følg «Tokens skal aldri limes inn i chatten» over. Jira-tokens starter med `ATATT`.

**2. E-postadresse** (samme som jobbinnlogging):
> Finn den i Jira ved å klikke profilbildet øverst til høyre.

**3. Jira-domenenavn:**
> Se på nettleseradressen — det er det som står før `.atlassian.net`

**macOS/Linux** — lagre i shell-miljøet (tokenet hentes rett fra utklippstavlen):
```bash
printf 'export ATLASSIAN_API_TOKEN="%s"\n' "$(pbpaste | tr -d '[:space:]')" >> ~/.zshrc
echo 'export ATLASSIAN_USER_EMAIL="EPOST_HER"' >> ~/.zshrc
echo 'export ATLASSIAN_SITE_NAME="SITENAVN_HER"' >> ~/.zshrc
source ~/.zshrc
```

**Windows** — verdiene legges direkte inn i konfigen i Steg 3. Tokenet byttes inn fra utklippstavlen (plassholder `JIRA_TOKEN_HER`).

---

### Figma-token

> 1. Gå til https://www.figma.com → klikk navn øverst til venstre → **Settings** → **Security**
> 2. Klikk **"Lag ny API-nøkkel"**, gi den navn `opencode`, minst lesetilgang til filer
> 3. Kopier nøkkelen — den vises bare én gang. Ikke lim den inn i chatten. Si «kopiert», så henter jeg den fra utklippstavlen.

Følg «Tokens skal aldri limes inn i chatten» over. Figma-nøkler starter med `figd_`.

**macOS/Linux:**
```bash
printf 'export FIGMA_API_KEY="%s"\n' "$(pbpaste | tr -d '[:space:]')" >> ~/.zshrc && source ~/.zshrc
```

**Windows** — tokenet byttes inn i konfigen i Steg 3 fra utklippstavlen (plassholder `FIGMA_TOKEN_HER`).

---

### Piwik Pro-token

> 1. Logg inn på https://gjensidige.piwik.pro
> 2. Klikk brukernavnet øverst til høyre → **My Profile** → **API Credentials**
> 3. Klikk **"Add credentials"**, gi det navn `opencode`
> 4. La siden stå åpen — **Client Secret** vises bare én gang.

Ta én verdi om gangen via utklippstavlen (se «Tokens skal aldri limes inn i chatten» over). Ingen av dem har fast start, så sjekk med `.{20,}`.

> Kopier **Client ID** først. Ikke lim den inn her — si «kopiert».

**macOS/Linux:**
```bash
printf 'export PIWIK_PRO_CLIENT_ID="%s"\n' "$(pbpaste | tr -d '[:space:]')" >> ~/.zshrc
```

> Kopier så **Client Secret**. Si «kopiert» igjen.

```bash
printf 'export PIWIK_PRO_CLIENT_SECRET="%s"\n' "$(pbpaste | tr -d '[:space:]')" >> ~/.zshrc
source ~/.zshrc
```

**Windows** — verdiene byttes inn i konfigen i Steg 3 fra utklippstavlen, én om gangen (plassholdere `PIWIK_ID_HER` og `PIWIK_SECRET_HER`).

Sjekk også om `uv` er installert (Piwik bruker `uvx`, ikke `npx`):
```bash
uv --version
```

Hvis ikke installert:
- **macOS/Linux:** `curl -LsSf https://astral.sh/uv/install.sh | sh`
- **Windows:** `powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"`

---

## Steg 3 — Oppdater OpenCode-konfigen

Les konfig-filen og legg til de nye MCP-blokkene under `"mcp": {}`. Behold eventuelle eksisterende blokker.

**Konfig-struktur:**
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4.6",
  "mcp": {
    // legg inn blokkene under her
  }
}
```

### MCP-blokker per tjeneste

**GitHub** — macOS/Linux:
```json
"github": {
  "type": "local",
  "command": ["npx", "-y", "--prefer-offline", "@modelcontextprotocol/server-github"],
  "environment": { "GITHUB_PERSONAL_ACCESS_TOKEN": "{env:GITHUB_TOKEN}" },
  "enabled": true
}
```
**GitHub** — Windows (plassholderen byttes fra `gh`, se Steg 2):
```json
"github": {
  "type": "local",
  "command": ["npx", "-y", "--prefer-offline", "@modelcontextprotocol/server-github"],
  "environment": { "GITHUB_PERSONAL_ACCESS_TOKEN": "GITHUB_TOKEN_HER" },
  "enabled": true
}
```

---

**Jira** — macOS/Linux:
```json
"atlassian-jira": {
  "type": "local",
  "command": ["npx", "-y", "--prefer-offline", "@aashari/mcp-server-atlassian-jira"],
  "environment": {
    "ATLASSIAN_SITE_NAME": "{env:ATLASSIAN_SITE_NAME}",
    "ATLASSIAN_USER_EMAIL": "{env:ATLASSIAN_USER_EMAIL}",
    "ATLASSIAN_API_TOKEN": "{env:ATLASSIAN_API_TOKEN}"
  },
  "enabled": true
}
```
**Jira** — Windows (bytt ut site og e-post; tokenet byttes fra utklippstavlen):
```json
"atlassian-jira": {
  "type": "local",
  "command": ["npx", "-y", "--prefer-offline", "@aashari/mcp-server-atlassian-jira"],
  "environment": {
    "ATLASSIAN_SITE_NAME": "SITENAVN_HER",
    "ATLASSIAN_USER_EMAIL": "EPOST_HER",
    "ATLASSIAN_API_TOKEN": "JIRA_TOKEN_HER"
  },
  "enabled": true
}
```

---

**Figma** — macOS/Linux:
```json
"figma": {
  "type": "local",
  "command": ["npx", "-y", "--prefer-offline", "figma-developer-mcp", "--stdio"],
  "environment": { "FIGMA_API_KEY": "{env:FIGMA_API_KEY}" },
  "enabled": true
}
```
**Figma** — Windows (plassholderen byttes fra utklippstavlen):
```json
"figma": {
  "type": "local",
  "command": ["npx", "-y", "--prefer-offline", "figma-developer-mcp", "--stdio"],
  "environment": { "FIGMA_API_KEY": "FIGMA_TOKEN_HER" },
  "enabled": true
}
```

---

**Piwik Pro** — macOS/Linux:
```json
"piwik-pro": {
  "type": "local",
  "command": ["uvx", "piwik-pro-mcp"],
  "environment": {
    "PIWIK_PRO_HOST": "gjensidige.piwik.pro",
    "PIWIK_PRO_CLIENT_ID": "{env:PIWIK_PRO_CLIENT_ID}",
    "PIWIK_PRO_CLIENT_SECRET": "{env:PIWIK_PRO_CLIENT_SECRET}"
  },
  "enabled": true
}
```
**Piwik Pro** — Windows (finn brukernavn med `$env:USERNAME`; ID og secret byttes fra utklippstavlen):
```json
"piwik-pro": {
  "type": "local",
  "command": ["C:\\Users\\<brukernavn>\\.local\\bin\\uvx.exe", "piwik-pro-mcp"],
  "environment": {
    "PIWIK_PRO_HOST": "gjensidige.piwik.pro",
    "PIWIK_PRO_CLIENT_ID": "PIWIK_ID_HER",
    "PIWIK_PRO_CLIENT_SECRET": "PIWIK_SECRET_HER"
  },
  "enabled": true
}
```

---

## Steg 4 — Restart

**macOS/Linux:** Brukeren må restarte terminalen (for at miljøvariabler skal bli tilgjengelige) og deretter restarte OpenCode.

**Windows:** Bare restart OpenCode — tokens ligger allerede i konfigen.

---

## Steg 5 — Test og feilsøk til det virker

Ikke gå videre før hver tjeneste faktisk fungerer. Test én og én.

| Tjeneste | Test |
|----------|------|
| GitHub | Spør: "Hva heter GitHub-brukeren min?" |
| Jira | Spør: "Vis meg mine åpne Jira-tickets" |
| Figma | Lim inn en Figma-URL og spør om innholdet |
| Piwik Pro | Spør: "Vis meg en liste over nettsteder i Piwik Pro" |

**Viktig: hvis noe ikke fungerer, gi ikke opp — gå gjennom feilsøkingssteget under og prøv igjen.**

---

## Steg 6 — Feilsøking (gjør dette hvis noe ikke virker)

Jobb deg gjennom disse punktene i rekkefølge. Gjør ett tiltak om gangen, test på nytt, og fortsett til det virker.

### "MCP server not found" eller ingen respons

1. **Har du restartet OpenCode?** OpenCode må restartes for at endringer i konfigen skal tre i kraft.
   - Lukk OpenCode helt og åpne den på nytt
   - Test på nytt

2. **Er konfigen skrevet riktig?** Les `~/.config/opencode/opencode.jsonc` og sjekk:
   - Finnes MCP-blokken under `"mcp": {}`?
   - Er JSON-en gyldig (ingen manglende kommaer, feil parenteser)?
   - Er `"enabled": true` satt?
   - Fiks eventuelle feil og restart OpenCode på nytt

### "Unauthorized" eller "403 Forbidden"

**GitHub:**
1. Er `gh` fortsatt autentisert? Kjør `gh auth status` — hvis ikke, kjør `gh auth login` på nytt
2. Hent et ferskt token slik som i Steg 2 — rett inn i fila, aldri skrevet ut i chatten
3. Restart OpenCode

**Jira:**
1. Er e-postadressen riktig? Sjekk i Jira ved å klikke profilbildet øverst til høyre
2. Er API-tokenet gyldig? Gå til https://id.atlassian.com/manage-profile/security/api-tokens og generer et nytt
3. Er domenenavnet riktig? Det skal bare være det som står før `.atlassian.net` (f.eks. `gjensidige`, ikke `gjensidige.atlassian.net`)
4. Oppdater konfigen via utklippstavlen (ikke chatten) og restart

**Figma:**
1. Er tokenet utløpt eller slettet? Gå til https://www.figma.com → Settings → Security og generer et nytt
2. Oppdater konfigen via utklippstavlen (ikke chatten) og restart

**Piwik:**
1. Er Client ID og Client Secret korrekte? De vises bare én gang — gå til https://gjensidige.piwik.pro → My Profile → API Credentials og lag nye
2. Oppdater konfigen via utklippstavlen (ikke chatten) og restart

### macOS/Linux: token er ikke tilgjengelig i OpenCode

Sjekk om tokenet er lagret i shell-miljøet — uten å skrive det ut:
```bash
[ -n "$GITHUB_TOKEN" ] && echo "SATT" || echo "TOMT"
```
Hvis det er tomt:
1. Sjekk at `~/.zshrc` inneholder `export GITHUB_TOKEN="..."` — åpne filen og se etter
2. Kjør `source ~/.zshrc` i terminalen
3. Restart terminalen helt (lukk og åpne nytt vindu)
4. Restart OpenCode

Bruk **bash** hvis du bruker bash i stedet for zsh:
```bash
echo $SHELL   # sjekk hvilken shell du bruker
```
Hvis outputen er `/bin/bash`, lagre i `~/.bashrc` i stedet for `~/.zshrc`.

### "uvx not found" (Piwik)

`uv` er ikke installert. Installer det:
- **macOS/Linux:** `curl -LsSf https://astral.sh/uv/install.sh | sh` — restart terminalen etterpå
- **Windows:** `powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"` — restart PowerShell etterpå

Verifiser at det fungerte:
```bash
uvx --version
```

Restart OpenCode og test på nytt.

### Windows: finner ikke uvx-stien

Finn riktig sti:
```powershell
where.exe uvx
```
Kopier stien som vises og bruk den i konfigen i stedet for `C:\Users\<brukernavn>\.local\bin\uvx.exe`.

### Fortsatt ikke løst?

Kopier feilmeldingen du ser og lim den inn her — så feilsøker vi videre sammen. Ikke gi opp; de fleste problemer har en enkel løsning.

---

## Om tokensikkerhet

**macOS/Linux:** Tokens lagres i `~/.zshrc` — tilgjengelig bare for maskinens eier. Konfigen refererer til dem via `{env:VARIABELNAVN}`.

**Windows:** Tokens lagres direkte i konfig-filen. Pass på at denne ikke deles eller sjekkes inn i versjonskontroll.
