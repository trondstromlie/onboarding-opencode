# OpenCode Skills — Kom i gang

Dette er et verktøy som installerer ferdige "skills" (hjelpere) til OpenCode på maskinen din.  
Når skills er installert, kan du be OpenCode om å sette opp GitHub, koble til Jira/Figma, og mer — uten å måtte gjøre noe manuelt.

---

## Steg 1 — Søk om tilganger

Før du gjør noe annet, må du ha disse tilgangene på plass. Be lederen din bestille dem via Gjensidiges tilgangsportal.

| Tilgangspakke | Hvorfor du trenger den |
|---------------|------------------------|
| **GitHub Team: Claims New** (`ROLE_AAD_GITHUB_CLAIMS_NEW`) | Gir deg medlemskap i Gjensidige-organisasjonen på GitHub og tilgang til Claims-teamets repoer |
| **GitHub Team: Copilot Users** (`ROLE_AAD_GITHUB_COPILOT_USERS`) | Gir deg GitHub Copilot-lisens, som er nødvendig for å bruke OpenCode |
| **Azure: GenAI Small Consumer (Prod)** (`ROLE_AAD_GENAI-SMALL-CONSUMER`) | Gir tilgang til GenAI-tjenestene som OpenCode bruker |

> Tilgangene kan ta litt tid å bli aktivert. Fortsett gjerne med installasjon mens du venter.

---

## Steg 2 — Installer Node.js og OpenCode

Følg instruksjonene for ditt operativsystem:

---

### Mac

#### 2a — Installer Node.js

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

#### 2b — Installer OpenCode

```
brew install opencode
```

Eller last ned fra: https://opencode.ai

---

### Windows

> **Merk:** Disse instruksjonene er laget for Windows-brukere uten administratortilgang.  
> Alt installeres i din egen brukerprofil — ingen admin-rettigheter nødvendig.

#### 2a — Tillat kjøring av scripts i PowerShell

Windows blokkerer som standard kjøring av scripts. Dette må gjøres én gang.

1. Åpne **PowerShell** (søk etter "PowerShell" i Start-menyen)
2. Lim inn og kjør:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

3. Svar `J` eller `Y` hvis du blir spurt om å bekrefte.

Dette gjelder kun din bruker og krever ikke admin.

#### 2b — Installer Node.js (ingen admin)

1. Gå til https://nodejs.org
2. Klikk på **"Other Downloads"** under den anbefalte versjonen
3. Under **"Windows"**, last ned **"node-vXX.X.X-win-x64.zip"** (ikke `.msi`-installeren)
4. Pakk ut ZIP-filen til `C:\Users\DITTBRUKERNAVN\nodejs`
5. Åpne **Systemegenskaper** → **Avansert** → **Miljøvariabler**
6. Under **Brukervariabler**, rediger **Path** og legg til:  
   `C:\Users\DITTBRUKERNAVN\nodejs`
7. Åpne en **ny** PowerShell og sjekk at det fungerte:

```powershell
node --version
```

Du skal se noe som `v22.0.0` eller høyere.

#### 2c — Installer OpenCode

Last ned fra: https://opencode.ai  
Velg Windows-versjonen og kjør installeren.

Hvis du ikke har admin: velg "Install for me only" (kun for meg) hvis du får det valget.

---

## Steg 3 — Installer skills

**Mac:**
```
npx opencode-setup
```

**Windows (PowerShell):**
```powershell
npx opencode-setup
```

Første gang kan det ta litt tid fordi `npx` laster ned verktøyet. Følg instruksjonene som vises. Du kan velge hvilke skills du vil installere, eller installere alle.

---

## Steg 4 — Start OpenCode

**Mac:** Åpne Terminal, naviger til en mappe du jobber i, og skriv:
```
opencode
```

**Windows:** Åpne PowerShell, naviger til en mappe du jobber i, og skriv:
```powershell
opencode
```

Skills er nå tilgjengelige. Prøv å skrive: *"Sett opp GitHub SSH for meg"*

---

## Hva er skills?

Skills er instruksjoner som hjelper OpenCode å veilede deg gjennom kompliserte oppsett steg for steg.

| Skill | Hva den gjør |
|-------|-------------|
| `github-setup` | Setter opp SSH-nøkkel, kobler til GitHub, SSO og signerte commits |
| `install-mcp` | Kobler OpenCode til GitHub, Jira og/eller Figma |
| `piwik-mcp` | Kobler OpenCode til Piwik Pro for analytics-data |

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

Ta kontakt med **Trond Strøm-Lie** på Slack: `@Trond Strøm-Lie`
