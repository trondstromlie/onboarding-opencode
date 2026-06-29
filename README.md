# OpenCode Skills — Kom i gang

Dette er et verktøy som installerer ferdige "skills" (hjelpere) til OpenCode på maskinen din.  
Når skills er installert, kan du be OpenCode om å sette opp GitHub, koble til Jira/Figma, og mer — uten å måtte gjøre noe manuelt.

---

## Hva er skills?

Skills er instruksjoner som hjelper OpenCode å veilede deg gjennom kompliserte oppsett steg for steg.  
Etter installasjon kan du for eksempel skrive:

> *"Sett opp GitHub SSH for meg"*

... og OpenCode vil guide deg gjennom hele prosessen.

### Skills som følger med:

| Skill | Hva den gjør |
|-------|-------------|
| `github-setup` | Setter opp SSH-nøkkel, kobler til GitHub, SSO og signerte commits |
| `install-mcp` | Kobler OpenCode til GitHub, Jira og/eller Figma |
| `piwik-mcp` | Kobler OpenCode til Piwik Pro for analytics-data |

---

## Tilganger du trenger

Før du starter, sjekk at du har tilgang til følgende. Ta kontakt med din leder eller IT hvis du mangler noe.

### GitHub
- En konto på [github.com](https://github.com)
- Tilgangspakken **"GitHub Team: Claims New"** (`ROLE_AAD_GITHUB_CLAIMS_NEW`)
  — gir deg medlemskap i Gjensidige-organisasjonen på GitHub og tilgang til Claims-teamets repoer
- Tilgangspakken **"GitHub Team: Copilot Users"** (`ROLE_AAD_GITHUB_COPILOT_USERS`)
  — gir deg GitHub Copilot-lisens, som er nødvendig for å bruke OpenCode
- Tilgangspakken **"Azure: GenAI Small Consumer (Prod)"** (`ROLE_AAD_GENAI-SMALL-CONSUMER`)
  — gir tilgang til GenAI-tjenestene som OpenCode bruker

> Be din leder bestille disse tilgangspakkene via Gjensidiges tilgangsportal.

---

## Forutsetninger — installer dette først

Verktøyet krever **Node.js** og **OpenCode**. Følg instruksjonene for ditt operativsystem:

---

### Mac

#### Steg 1 — Installer Node.js

1. Åpne **Terminal** (søk etter "Terminal" i Spotlight, eller finn den i Programmer → Verktøy)
2. Lim inn denne kommandoen og trykk Enter:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

3. Følg instruksjonene på skjermen. Det kan ta noen minutter.
4. Når Homebrew er ferdig, kjør:

```
brew install node
```

5. Sjekk at det fungerte:

```
node --version
```

Du skal se noe som `v22.0.0` eller høyere.

#### Steg 2 — Installer OpenCode

```
brew install opencode
```

Eller last ned fra: https://opencode.ai

#### Steg 3 — Installer skills

Lim inn og kjør denne kommandoen i Terminal:

```
npx opencode-setup
```

Følg instruksjonene som vises. Du kan velge hvilke skills du vil installere, eller installere alle.

#### Steg 4 — Start OpenCode

Åpne en ny terminal, naviger til en mappe du jobber i, og skriv:

```
opencode
```

Skills er nå tilgjengelige. Prøv å skrive: *"Sett opp GitHub SSH for meg"*

---

### Windows

> **Merk:** Disse instruksjonene er laget for Windows-brukere uten administratortilgang.  
> Alt installeres i din egen brukerprofil — ingen admin-rettigheter nødvendig.

#### Steg 1 — Installer Node.js via Microsoft Store (anbefalt, ingen admin)

1. Åpne **Microsoft Store** (søk i Start-menyen)
2. Søk etter **Node.js**
3. Installer den versjonen som heter **Node.js** (fra Node.js Foundation)
4. Åpne **PowerShell** (søk etter "PowerShell" i Start-menyen)
5. Sjekk at det fungerte:

```powershell
node --version
```

Du skal se noe som `v22.0.0` eller høyere.

> **Alternativ: manuell installasjon uten admin (via NVM)**
>
> Hvis Microsoft Store ikke er tilgjengelig:
>
> 1. Last ned NVM for Windows som ZIP-fil fra: https://github.com/coreybutler/nvm-windows/releases  
>    Velg `nvm-noinstall.zip`
> 2. Pakk ut innholdet til `C:\Users\DITTBRUKERNAVN\nvm`
> 3. Åpne **Systemegenskaper** → **Avansert** → **Miljøvariabler**
> 4. Under **Brukervariabler** (ikke systemvariabler), legg til:
>    - Ny variabel: `NVM_HOME` = `C:\Users\DITTBRUKERNAVN\nvm`
>    - Ny variabel: `NVM_SYMLINK` = `C:\Users\DITTBRUKERNAVN\nodejs`
>    - Rediger `Path`: legg til `%NVM_HOME%` og `%NVM_SYMLINK%`
> 5. Åpne en **ny** PowerShell og kjør:
>    ```powershell
>    nvm install 22
>    ```
> 6. Fordi NVM på Windows uten admin ikke kan lage symbolkoblinger, må du peke direkte til Node:
>    - Legg til hele stien til node.exe i Path, f.eks.:  
>      `C:\Users\DITTBRUKERNAVN\nvm\v22.x.x`  
>      (erstatt `v22.x.x` med den faktiske versjonen som ble installert)

#### Steg 2 — Installer OpenCode

Last ned fra: https://opencode.ai  
Velg Windows-versjonen og kjør installeren.

Hvis du ikke har admin: velg "Install for me only" (kun for meg) hvis du får det valget.

#### Steg 3 — Installer skills

Åpne **PowerShell** og kjør:

```powershell
npx opencode-setup
```

Første gang kan det ta litt tid fordi `npx` laster ned verktøyet. Følg instruksjonene som vises.

#### Steg 4 — Start OpenCode

Åpne PowerShell, naviger til en mappe du jobber i, og skriv:

```powershell
opencode
```

Skills er nå tilgjengelige. Prøv å skrive: *"Sett opp GitHub SSH for meg"*

---

## Oppdatere skills

Kjør den samme kommandoen på nytt for å oppdatere til siste versjon:

```
npx opencode-setup@latest
```

---

## Vanlige spørsmål

**Hva er Terminal / PowerShell?**  
Det er et tekstbasert program der du kan gi datamaskinen instruksjoner ved å skrive kommandoer.  
På Mac heter det Terminal. På Windows heter det PowerShell eller Ledetekst.

**Kommandoen "henger" og ingenting skjer?**  
Noen kommandoer tar tid. Vent til du ser en ny linje med en blinkende markør.

**Jeg får feilmeldingen "command not found: node"?**  
Node er ikke installert riktig, eller terminalen har ikke blitt restartet etter installasjon.  
Lukk terminalen og åpne en ny, og prøv igjen.

**Jeg er usikker — kan jeg bare spørre i OpenCode?**  
Ja! Etter at du har installert skills, kan du skrive hva du trenger hjelp med og OpenCode vil veilede deg.

---

## Problemer?

Ta kontakt med din lokale tekniske kontaktperson, eller åpne et issue på GitHub-repositoriet for dette verktøyet.
