---
name: piwik-mcp
description: Sett opp Piwik Pro MCP-server i OpenCode. Bruk denne skill-en når noen spør om "Piwik", "koble til Piwik Pro", "analytics MCP", "sett opp sporing", "Piwik MCP", "tilgang til Piwik", "se besøksstatistikk i OpenCode", eller ønsker å analysere trafikk og brukeradferd via OpenCode. Trigger også ved "piwik token", "piwik organisasjon", "piwik site id".
---

# Piwik Pro MCP-oppsett

Denne skill-en kobler OpenCode til Piwik Pro slik at du kan spørre om besøksstatistikk, sidetrafikk og brukeradferd direkte i OpenCode.

Gå gjennom stegene i rekkefølge. Still ett spørsmål om gangen.

---

## Steg 0 — Finn ut hvilket OS brukeren har

Spør:

> Bruker du **Mac** eller **Windows**?

**Konfig-sti per OS:**
- Mac: `~/.config/opencode/opencode.jsonc`
- Windows: `%APPDATA%\opencode\opencode.jsonc` (typisk `C:\Users\<brukernavn>\AppData\Roaming\opencode\opencode.jsonc`)

**Windows-merk:** Tokens legges direkte inn som strenger i konfigen i stedet for som miljøvariabler.

---

## Steg 1 — Hent Piwik Pro API-token

Si til brukeren:

> Jeg trenger et Piwik Pro API-token. Slik henter du det:
>
> 1. Logg inn på Piwik Pro-instansen din
> 2. Klikk på **brukernavnet ditt** øverst til høyre
> 3. Velg **"My Profile"** eller **"Settings"**
> 4. Klikk på **"API Access"** eller **"API tokens"**
> 5. Klikk **"Generer ny token"** (eller **"Create new token"**)
> 6. Gi tokenet et navn — f.eks. `opencode`
> 7. Velg nødvendig tilgang — minst lesetilgang til analytics-data
> 8. Kopier tokenet som vises — det vises bare én gang!
>
> Lim tokenet inn her.

---

## Steg 2 — Hent Piwik Pro-URL og organisasjons-ID

Når brukeren har gitt deg tokenet, spør:

> Hva er adressen til din Piwik Pro-instans?
> (f.eks. `https://dittnavn.piwik.pro` eller en intern URL)

Så:

> Hva er organisasjons-ID-en? Du finner den i nettleserens adressefelt når du er inne på instansen.
> Den ser slik ut: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` (en lang kode med bindestreker)

---

## Steg 3 — Oppdater OpenCode-konfigen

Åpne konfig-filen og legg til Piwik Pro MCP:

**Mac (bruker miljøvariabel):**

Lagre tokenet først:
```bash
echo 'export PIWIK_PRO_CLIENT_ID="TOKEN_HER"' >> ~/.zshrc && source ~/.zshrc
```

Legg til i `~/.config/opencode/opencode.jsonc`:
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4.6",
  "mcp": {
    "piwik-pro": {
      "type": "local",
      "command": ["npx", "-y", "--prefer-offline", "@piwikpro/mcp-server"],
      "environment": {
        "PIWIK_PRO_URL": "https://din-instans.piwik.pro",
        "PIWIK_PRO_ORG_ID": "DIN_ORG_ID",
        "PIWIK_PRO_CLIENT_ID": "{env:PIWIK_PRO_CLIENT_ID}"
      },
      "enabled": true
    }
  }
}
```

**Windows (token direkte i konfig):**

Legg til i `%APPDATA%\opencode\opencode.jsonc` — erstatt alle verdier:
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "github-copilot/claude-sonnet-4.6",
  "mcp": {
    "piwik-pro": {
      "type": "local",
      "command": ["npx", "-y", "--prefer-offline", "@piwikpro/mcp-server"],
      "environment": {
        "PIWIK_PRO_URL": "https://din-instans.piwik.pro",
        "PIWIK_PRO_ORG_ID": "DIN_ORG_ID",
        "PIWIK_PRO_CLIENT_ID": "TOKEN_HER"
      },
      "enabled": true
    }
  }
}
```

Bytt ut:
- `https://din-instans.piwik.pro` → instansens faktiske URL
- `DIN_ORG_ID` → organisasjons-ID-en fra Steg 2
- `TOKEN_HER` (Windows) → tokenet fra Steg 1

Hvis konfigen allerede inneholder en `mcp`-blokk med andre tjenester (GitHub, Jira, Figma), legg til `piwik-pro` som et nytt felt inne i `mcp`-blokken — ikke erstatt eksisterende oppføringer.

---

## Steg 4 — Restart OpenCode

**Mac:**

> Du må gjøre to ting:
>
> **1. Restart terminalen** — lukk og åpne den på nytt så miljøvariabelen lastes.
> **2. Restart OpenCode** — lukk og åpne på nytt.
>
> Si ifra her når du er tilbake.

**Windows:**

> Restart OpenCode — lukk og åpne den på nytt.
>
> Si ifra her når du er tilbake.

---

## Steg 5 — Test tilkoblingen

Spør i OpenCode:

> "Vis meg en liste over nettsteder/apper i Piwik Pro"

Hvis det fungerer vil du se en liste over nettstedene du har tilgang til i Piwik Pro.

**Eksempler på hva du kan spørre om etter oppsett:**
- "Hvor mange sidevisninger hadde vi i dag?"
- "Hvilke sider er mest besøkt denne uken?"
- "Vis meg antall unike besøkende siste 30 dager for nettsted X"
- "Hva er fluktfrekvensen på landingssiden?"

---

## Feilsøking

**"Unauthorized" eller 401-feil:**
- Tokenet er feil eller utløpt. Generer et nytt i Piwik Pro og oppdater konfigen.
- Sjekk at du brukte riktig instans-URL.

**"MCP server not found":**
- OpenCode er ikke restartet. Lukk og åpne på nytt.

**Mac: tomt svar på `echo $PIWIK_PRO_CLIENT_ID`:**
- Terminalen er ikke restartet. Lukk og åpne terminalvinduet på nytt.
- Sjekk at linjen ble lagt til i `~/.zshrc`: `grep PIWIK ~/.zshrc`

**Finner ikke organisasjons-ID:**
- Logg inn på Piwik Pro. I adressefeltet i nettleseren, se etter en lang ID i URL-en, f.eks.: `https://dittnavn.piwik.pro/administration/organization/<ORG_ID>/...`
