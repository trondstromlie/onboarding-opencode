---
name: install-mcp
description: Hjelper brukeren med å installere MCP-servere i OpenCode. Bruk når noen spør om å installere GitHub MCP, Jira MCP, Figma MCP, Piwik MCP, eller kombinasjoner. Trigger på ord som "installer mcp", "jeg vil ha jira mcp", "legg til github mcp", "koble til jira", "koble til github", "koble til figma", "sett opp mcp", "figma mcp", "koble til piwik", "piwik mcp", "sett opp piwik". Miro MCP og Grafana MCP er ikke tilgjengelig for organisasjonen — si fra om det hvis noen spør.
---

# Installer MCP-servere i OpenCode

Følg denne flyten nøyaktig. Still ett spørsmål om gangen. Vent på svar før du går videre.

---

## Steg 0 — Finn ut hvilket OS brukeren har

Før du gjør noe annet, sjekk hvilket operativsystem brukeren kjører. Spør hvis du ikke vet:

> Kjører du **macOS/Linux** eller **Windows**?

Bruk svaret til å gi riktige kommandoer og filstier gjennom hele flyten. Instruksjonene under har egne seksjoner per OS der det er forskjell.

**Konfig-sti per OS:**
- macOS/Linux: `~/.config/opencode/opencode.jsonc`
- Windows: `%APPDATA%\opencode\opencode.jsonc` (typisk `C:\Users\<brukernavn>\AppData\Roaming\opencode\opencode.jsonc`)

**Viktig for Windows-brukere:** Windows-brukere har typisk ikke administratortilgang. Derfor lagres tokens **direkte i OpenCode-konfigen** i stedet for som systemmiljøvariabler. Verdiene legges inn som strenger direkte under `environment` i konfig-filen i stedet for `{env:VARIABELNAVN}`. Dette er trygt så lenge konfig-filen ikke deles eller sjekkes inn i versjonskontroll.

---

## Steg 1 — Spør hva de vil installere

Si dette til brukeren:

> Hva vil du koble til?
> - **GitHub** — lar meg lese og opprette issues, PRs og kode på GitHub
> - **Jira** — lar meg lese og oppdatere Jira-tickets
> - **Figma** — lar meg lese design og hjelpe deg å implementere dem i kode
> - **Piwik Pro** — lar meg hente besøksstatistikk og analysere trafikk
> - Flere av disse, eller **alle**

---

## Steg 2 — Hent token(s)

### GitHub-token

Si til brukeren:

> Jeg trenger et GitHub-token fra deg. Slik henter du det:
>
> 1. Gå til: https://github.com/settings/tokens
> 2. Klikk **"Generate new token"** og velg **"Generate new token (classic)"**
> 3. Gi det et navn — f.eks. `opencode`
> 4. Sett gyldighet til **90 days** (maks tillatt)
> 5. Huk av for: **`repo`** og **`workflow`**
> 6. Klikk **Generate token** nederst
> 7. Kopier det lange tokenet som vises (starter med `ghp_`)
> 8. Klikk **"Configure SSO"** ved siden av tokenet
> 9. Klikk **"Authorize"** ved siden av **Gjensidige** — uten dette får du ikke tilgang til Gjensidiges repoer
>
> Lim tokenet inn her, så ordner jeg resten.

Når brukeren limer inn tokenet — det ser slik ut: `ghp_xxxxxxxxxxxxxxxxxxxxxx` — lagre det:

**macOS/Linux:**
```bash
echo 'export GITHUB_TOKEN="TOKENET_HER"' >> ~/.zshrc && source ~/.zshrc
```

**Windows:** Tokenet legges direkte inn i konfigen under `environment` (se Steg 3). Ingen kommando nødvendig nå — noter tokenet og bruk det i konfig-steget.

---

### Jira-token og innstillinger

Sjekk først om brukeren allerede har en Jira MCP satt opp ved å lese konfig-filen (sti avhenger av OS, se Steg 0). Se etter en eksisterende `mcp`-blokk med Jira-konfig.

**Hvis brukeren allerede har en annen Jira MCP-pakke:**

Si til brukeren:

> Jeg ser at du allerede har Jira koblet til, men med en annen pakke. Jeg anbefaler å bytte til `@aashari/mcp-server-atlassian-jira` som fungerer bedre.
> E-postadressen og tokenet ditt er det samme — du trenger ikke hente noe nytt.
> Vil du bytte?

Hvis ja — hent eksisterende verdier fra `~/.zshrc` (macOS/Linux) eller `[System.Environment]::GetEnvironmentVariable` (Windows) og bruk dem direkte. Ikke spør om token eller epost på nytt.

---

**Hvis brukeren ikke har Jira fra før:**

Si til brukeren:

> Jeg trenger tre ting fra deg for Jira:
>
> **1. Jira API-token** — slik henter du det:
> 1. Gå til: https://id.atlassian.com/manage-profile/security/api-tokens
> 2. Klikk **"Opprett API-token"**
> 3. Gi det et navn — f.eks. `opencode`
> 4. Velg varighet: **1 år**
> 5. Klikk **Opprett** og kopier tokenet
>
> Lim det inn her.

Når du har fått tokenet, spør:

> **2. Hvilken e-postadresse bruker du til å logge inn på Jira?**
> Det er den samme e-postadressen du bruker til å logge på jobben.
> Slik finner du den:
> 1. Åpne Jira i nettleseren
> 2. Klikk på **profilbildet ditt** øverst til høyre
> 3. E-postadressen vises rett under navnet ditt

Når du har fått eposten, spør:

> **3. Hva heter Jira-domenet ditt?**
> Slik finner du det:
> 1. Åpne Jira i nettleseren
> 2. Se på adressen i nettleserens adressefelt — den ser slik ut:
>    `https://DITTDOMENE.atlassian.net/...`
> 3. Skriv inn bare den første delen — altså det som står før `.atlassian.net`

Når du har alle tre, lagre dem:

**macOS/Linux:**
```bash
echo 'export ATLASSIAN_API_TOKEN="TOKEN_HER"' >> ~/.zshrc
echo 'export ATLASSIAN_USER_EMAIL="EPOST_HER"' >> ~/.zshrc
echo 'export ATLASSIAN_SITE_NAME="SITENAVN_HER"' >> ~/.zshrc
source ~/.zshrc
```

**Windows:** Verdiene legges direkte inn i konfigen under `environment` (se Steg 3). Ingen kommando nødvendig nå — noter verdiene og bruk dem i konfig-steget.

---

### Figma-token

Si til brukeren:

> Jeg trenger et Figma API-token fra deg. Slik henter du det:
>
> 1. Gå til: https://www.figma.com
> 2. Klikk på **navnet ditt** øverst til venstre
> 3. Velg **"Settings"**
> 4. Klikk på **"Security"**
> 5. Scroll ned og klikk **"Lag ny API-nøkkel"**
> 6. Gi den et navn — f.eks. `opencode`
> 7. Velg tilganger — velg de tilgangene du trenger (minst lesetilgang til filer)
> 8. Kopier nøkkelen som vises — den vises bare én gang
>
> Lim den inn her, så ordner jeg resten.

Når brukeren limer inn tokenet — det starter med `figd_` — lagre det:

**macOS/Linux:**
```bash
echo 'export FIGMA_API_KEY="TOKEN_HER"' >> ~/.zshrc && source ~/.zshrc
```

**Windows:** Tokenet legges direkte inn i konfigen under `environment` (se Steg 3). Ingen kommando nødvendig nå — noter tokenet og bruk det i konfig-steget.

---

### Piwik Pro-token og innstillinger

Si til brukeren:

> Jeg trenger et Piwik Pro API-token. Slik henter du det:
>
> 1. Logg inn på Piwik Pro: https://gjensidige.piwik.pro
> 2. Klikk på **brukernavnet ditt** øverst til høyre
> 3. Velg **"My Profile"**
> 4. Klikk på **"API Credentials"**
> 5. Klikk **"Add credentials"**
> 6. Gi det et navn — f.eks. `opencode`
> 7. Kopier **Client ID** og **Client Secret** som vises — de vises bare én gang!
>
> Lim inn Client ID og Client Secret her.

Når brukeren har gitt deg begge verdiene, lagre dem:

**macOS/Linux:**
```bash
echo 'export PIWIK_PRO_CLIENT_ID="CLIENT_ID_HER"' >> ~/.zshrc
echo 'export PIWIK_PRO_CLIENT_SECRET="CLIENT_SECRET_HER"' >> ~/.zshrc
source ~/.zshrc
```

**Windows:** Verdiene legges direkte inn i konfigen under `environment` (se Steg 3). Ingen kommando nødvendig nå.

**Merk:** Piwik Pro MCP bruker `uvx` (Python-basert), ikke `npx`. Sjekk om `uv` er installert:

```bash
uv --version
```

Hvis ikke installert, instruer brukeren:

**macOS/Linux:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Windows (PowerShell):**
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

---

### Miro

**Miro MCP er ikke tilgjengelig for organisasjonen enda.** Hvis brukeren spør om Miro, si:

> Miro MCP er dessverre ikke tilgjengelig for organisasjonen vår enda. Vi kan ikke sette det opp foreløpig.

### Grafana

**Grafana MCP finnes, men er ikke tilgjengelig for organisasjonen enda.** Hvis brukeren spør om Grafana, si:

> Grafana MCP finnes, men vi har ikke tilgang for organisasjonen vår enda. Vi kan ikke sette det opp foreløpig.

---

## Steg 3 — Oppdater OpenCode-konfigen

Åpne og oppdater konfig-filen med riktig innhold basert på hva brukeren valgte.

- **macOS/Linux:** `~/.config/opencode/opencode.jsonc`
- **Windows:** `%APPDATA%\opencode\opencode.jsonc`

**macOS/Linux** bruker `{env:VARIABELNAVN}` — tokens leses fra shell-miljøet.
**Windows** legger tokens direkte inn som strenger i `environment`-blokken.

### Bare GitHub

**macOS/Linux:**
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4.6",
  "mcp": {
    "github": {
      "type": "local",
      "command": ["npx", "-y", "--prefer-offline", "@modelcontextprotocol/server-github"],
      "environment": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "{env:GITHUB_TOKEN}"
      },
      "enabled": true
    }
  }
}
```

**Windows** (erstatt `TOKEN_HER` med det faktiske tokenet):
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4.6",
  "mcp": {
    "github": {
      "type": "local",
      "command": ["npx", "-y", "--prefer-offline", "@modelcontextprotocol/server-github"],
      "environment": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "TOKEN_HER"
      },
      "enabled": true
    }
  }
}
```

### Bare Jira

**macOS/Linux:**
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4.6",
  "mcp": {
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
  }
}
```

**Windows** (erstatt verdiene med det brukeren ga deg):
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4.6",
  "mcp": {
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
  }
}
```

### Bare Figma

**macOS/Linux:**
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4.6",
  "mcp": {
    "figma": {
      "type": "local",
      "command": ["npx", "-y", "--prefer-offline", "figma-developer-mcp", "--stdio"],
      "environment": {
        "FIGMA_API_KEY": "{env:FIGMA_API_KEY}"
      },
      "enabled": true
    }
  }
}
```

**Windows** (erstatt `TOKEN_HER` med det faktiske tokenet):
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4.6",
  "mcp": {
    "figma": {
      "type": "local",
      "command": ["npx", "-y", "--prefer-offline", "figma-developer-mcp", "--stdio"],
      "environment": {
        "FIGMA_API_KEY": "TOKEN_HER"
      },
      "enabled": true
    }
  }
}
```

### Bare Piwik Pro

**macOS/Linux:**
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4.6",
  "mcp": {
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
  }
}
```

**Windows** (erstatt verdiene med det brukeren ga deg — finn `<brukernavn>` ved å kjøre `$env:USERNAME` i PowerShell):
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4.6",
  "mcp": {
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
  }
}
```

### Alle fire

**macOS/Linux:**
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4.6",
  "mcp": {
    "github": {
      "type": "local",
      "command": ["npx", "-y", "--prefer-offline", "@modelcontextprotocol/server-github"],
      "environment": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "{env:GITHUB_TOKEN}"
      },
      "enabled": true
    },
    "atlassian-jira": {
      "type": "local",
      "command": ["npx", "-y", "--prefer-offline", "@aashari/mcp-server-atlassian-jira"],
      "environment": {
        "ATLASSIAN_SITE_NAME": "{env:ATLASSIAN_SITE_NAME}",
        "ATLASSIAN_USER_EMAIL": "{env:ATLASSIAN_USER_EMAIL}",
        "ATLASSIAN_API_TOKEN": "{env:ATLASSIAN_API_TOKEN}"
      },
      "enabled": true
    },
    "figma": {
      "type": "local",
      "command": ["npx", "-y", "--prefer-offline", "figma-developer-mcp", "--stdio"],
      "environment": {
        "FIGMA_API_KEY": "{env:FIGMA_API_KEY}"
      },
      "enabled": true
    },
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
  }
}
```

**Windows** (erstatt alle verdier med det brukeren ga deg):
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4.6",
  "mcp": {
    "github": {
      "type": "local",
      "command": ["npx", "-y", "--prefer-offline", "@modelcontextprotocol/server-github"],
      "environment": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "TOKEN_HER"
      },
      "enabled": true
    },
    "atlassian-jira": {
      "type": "local",
      "command": ["npx", "-y", "--prefer-offline", "@aashari/mcp-server-atlassian-jira"],
      "environment": {
        "ATLASSIAN_SITE_NAME": "SITENAVN_HER",
        "ATLASSIAN_USER_EMAIL": "EPOST_HER",
        "ATLASSIAN_API_TOKEN": "TOKEN_HER"
      },
      "enabled": true
    },
    "figma": {
      "type": "local",
      "command": ["npx", "-y", "--prefer-offline", "figma-developer-mcp", "--stdio"],
      "environment": {
        "FIGMA_API_KEY": "TOKEN_HER"
      },
      "enabled": true
    },
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
  }
}
```

---

## Steg 4 — Be brukeren restarte OpenCode

**macOS/Linux:**

> Nesten ferdig! Du må gjøre to ting før vi kan teste:
>
> **1. Restart terminalen** — lukk terminalvinduet helt og åpne det på nytt.
> Dette er nødvendig for at tokenene dine blir tilgjengelige.
>
> **2. Restart OpenCode** — lukk OpenCode og åpne det igjen.
>
> Si ifra her når du er tilbake, så tester vi at alt virker.

**Windows:**

> Nesten ferdig! Siden tokenene ligger direkte i konfigen, trenger du bare å:
>
> **Restart OpenCode** — lukk OpenCode og åpne det igjen.
>
> Si ifra her når du er tilbake, så tester vi at alt virker.

---

## Steg 5 — Test at det virker

Når brukeren er tilbake, test at MCP-tilkoblingen fungerer:

**GitHub-test** — spør:
> "Hva heter GitHub-brukeren min?"

På macOS/Linux kan du i tillegg verifisere miljøvariabelen:
```bash
echo $GITHUB_TOKEN
```

**Jira-test** — spør:
> "Vis meg mine åpne Jira-tickets"

På macOS/Linux kan du i tillegg verifisere miljøvariabelen:
```bash
echo $ATLASSIAN_API_TOKEN
```

**Figma-test** — lim inn en Figma-URL og spør:
> "Hva er innholdet i denne Figma-filen: [lim inn URL]"

På macOS/Linux kan du i tillegg verifisere miljøvariabelen:
```bash
echo $FIGMA_API_KEY
```

**Piwik Pro-test** — spør:
> "Vis meg en liste over nettsteder i Piwik Pro"

På macOS/Linux kan du i tillegg verifisere miljøvariabelen:
```bash
echo $PIWIK_PRO_CLIENT_ID
```

---

**Hvis testen feiler:**

- "Unauthorized" fra MCP → tokenet er feil eller SSO-autorisering mangler (GitHub). Generer et nytt token og oppdater konfigen.
- "MCP server not found" → OpenCode er ikke restartet. Lukk og åpne på nytt.
- macOS/Linux: tomt svar på `echo $TOKEN` → terminalen er ikke restartet, eller verdien ble ikke lagret i `~/.zshrc`. Sjekk filen og prøv igjen.
- Piwik: "`uvx` not found" → `uv` er ikke installert. Se instruksjoner i Steg 2.

---

## Viktig om tokenene

**macOS/Linux:** Tokenene lagres i `~/.zshrc` — en skjult fil som bare eieren av maskinen har tilgang til. Konfigen inneholder bare referanser til dem via `{env:VARIABELNAVN}`.

**Windows:** Tokenene lagres direkte i konfig-filen (`%APPDATA%\opencode\opencode.jsonc`). Pass på at denne filen ikke deles med andre eller sjekkes inn i versjonskontroll.
