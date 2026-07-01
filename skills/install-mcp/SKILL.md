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

> Jeg trenger et GitHub-token fra deg. Slik henter du det:
>
> 1. Gå til: https://github.com/settings/tokens
> 2. Klikk **"Generate new token"** → **"Generate new token (classic)"**  
>    ⚠️ Velg **classic** — ikke "Fine-grained tokens"
> 3. Gi det et navn — f.eks. `opencode`
> 4. Sett gyldighet til **90 days**
> 5. Huk av for:
>    - **`repo`** — lesetilgang til kode, issues og pull requests
>    - **`workflow`** — tilgang til å se og trigge GitHub Actions
>    - **`read:packages`** — tilgang til å laste ned npm-pakker fra GitHub (trengs hvis du også installerer Gjensidige-pakker via npm)
> 6. Klikk **Generate token** og kopier tokenet (starter med `ghp_`)
> 7. Klikk **"Configure SSO"** → **"Authorize"** ved siden av **Gjensidige**
>
> Lim tokenet inn her, så ordner jeg resten.

**macOS/Linux** — lagre i shell-miljøet:
```bash
echo 'export GITHUB_TOKEN="ghp_TOKENET_HER"' >> ~/.zshrc && source ~/.zshrc
```

**Windows** — tokenet legges direkte inn i konfigen i Steg 3.

---

### Jira-token og innstillinger

Sjekk først konfig-filen for en eksisterende Jira MCP-blokk. Hvis brukeren allerede har Jira koblet til med en annen pakke, anbefal å bytte til `@aashari/mcp-server-atlassian-jira` og gjenbruk eksisterende token/e-post.

Hvis ikke fra før — be brukeren om tre ting:

**1. Jira API-token:**
> 1. Gå til: https://id.atlassian.com/manage-profile/security/api-tokens
> 2. Klikk **"Opprett API-token"**, gi det navn `opencode`, varighet **1 år**
> 3. Kopier tokenet

**2. E-postadresse** (samme som jobbinnlogging):
> Finn den i Jira ved å klikke profilbildet øverst til høyre.

**3. Jira-domenenavn:**
> Se på nettleseradressen — det er det som står før `.atlassian.net`

**macOS/Linux** — lagre i shell-miljøet:
```bash
echo 'export ATLASSIAN_API_TOKEN="TOKEN_HER"' >> ~/.zshrc
echo 'export ATLASSIAN_USER_EMAIL="EPOST_HER"' >> ~/.zshrc
echo 'export ATLASSIAN_SITE_NAME="SITENAVN_HER"' >> ~/.zshrc
source ~/.zshrc
```

**Windows** — verdiene legges direkte inn i konfigen i Steg 3.

---

### Figma-token

> 1. Gå til https://www.figma.com → klikk navn øverst til venstre → **Settings** → **Security**
> 2. Klikk **"Lag ny API-nøkkel"**, gi den navn `opencode`, minst lesetilgang til filer
> 3. Kopier nøkkelen (starter med `figd_`) — vises bare én gang

**macOS/Linux:**
```bash
echo 'export FIGMA_API_KEY="figd_TOKEN_HER"' >> ~/.zshrc && source ~/.zshrc
```

**Windows** — tokenet legges direkte inn i konfigen i Steg 3.

---

### Piwik Pro-token

> 1. Logg inn på https://gjensidige.piwik.pro
> 2. Klikk brukernavnet øverst til høyre → **My Profile** → **API Credentials**
> 3. Klikk **"Add credentials"**, gi det navn `opencode`
> 4. Kopier **Client ID** og **Client Secret** — vises bare én gang!

**macOS/Linux:**
```bash
echo 'export PIWIK_PRO_CLIENT_ID="CLIENT_ID_HER"' >> ~/.zshrc
echo 'export PIWIK_PRO_CLIENT_SECRET="CLIENT_SECRET_HER"' >> ~/.zshrc
source ~/.zshrc
```

**Windows** — verdiene legges direkte inn i konfigen i Steg 3.

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
**GitHub** — Windows (bytt ut `TOKEN_HER`):
```json
"github": {
  "type": "local",
  "command": ["npx", "-y", "--prefer-offline", "@modelcontextprotocol/server-github"],
  "environment": { "GITHUB_PERSONAL_ACCESS_TOKEN": "TOKEN_HER" },
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
**Jira** — Windows (bytt ut verdiene):
```json
"atlassian-jira": {
  "type": "local",
  "command": ["npx", "-y", "--prefer-offline", "@aashari/mcp-server-atlassian-jira"],
  "environment": {
    "ATLASSIAN_SITE_NAME": "SITENAVN_HER",
    "ATLASSIAN_USER_EMAIL": "EPOST_HER",
    "ATLASSIAN_API_TOKEN": "TOKEN_HER"
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
**Figma** — Windows (bytt ut `TOKEN_HER`):
```json
"figma": {
  "type": "local",
  "command": ["npx", "-y", "--prefer-offline", "figma-developer-mcp", "--stdio"],
  "environment": { "FIGMA_API_KEY": "TOKEN_HER" },
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
**Piwik Pro** — Windows (finn brukernavn med `$env:USERNAME`, bytt ut verdiene):
```json
"piwik-pro": {
  "type": "local",
  "command": ["C:\\Users\\<brukernavn>\\.local\\bin\\uvx.exe", "piwik-pro-mcp"],
  "environment": {
    "PIWIK_PRO_HOST": "gjensidige.piwik.pro",
    "PIWIK_PRO_CLIENT_ID": "CLIENT_ID_HER",
    "PIWIK_PRO_CLIENT_SECRET": "CLIENT_SECRET_HER"
  },
  "enabled": true
}
```

---

## Steg 4 — Restart

**macOS/Linux:** Brukeren må restarte terminalen (for at miljøvariabler skal bli tilgjengelige) og deretter restarte OpenCode.

**Windows:** Bare restart OpenCode — tokens ligger allerede i konfigen.

---

## Steg 5 — Test at det virker

Bruk disse testene etter restart:

| Tjeneste | Test |
|----------|------|
| GitHub | Spør: "Hva heter GitHub-brukeren min?" |
| Jira | Spør: "Vis meg mine åpne Jira-tickets" |
| Figma | Lim inn en Figma-URL og spør om innholdet |
| Piwik Pro | Spør: "Vis meg en liste over nettsteder i Piwik Pro" |

**Vanlige feil:**
- `Unauthorized` → tokenet er feil eller SSO-autorisering mangler (GitHub). Generer nytt token og oppdater konfigen.
- `MCP server not found` → OpenCode er ikke restartet.
- macOS/Linux: tomt svar på `echo $TOKEN` → terminalen er ikke restartet, eller verdien ble ikke lagret i `~/.zshrc`.
- `uvx not found` → `uv` er ikke installert. Se instruksjoner i Steg 2 (Piwik).

---

## Om tokensikkerhet

**macOS/Linux:** Tokens lagres i `~/.zshrc` — tilgjengelig bare for maskinens eier. Konfigen refererer til dem via `{env:VARIABELNAVN}`.

**Windows:** Tokens lagres direkte i konfig-filen. Pass på at denne ikke deles eller sjekkes inn i versjonskontroll.
