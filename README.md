# OpenCode Skills — Kom i gang

Dette er et verktøy som installerer ferdige "skills" (hjelpere) til OpenCode på maskinen din.  
Når skills er installert, kan du be OpenCode om å sette opp GitHub, koble til Jira/Figma, og mer — OpenCode veileder deg steg for steg og hjelper deg å finne riktig informasjon underveis.

---

## Steg 1 — Koble GitHub-kontoen din til Gjensidige

> **Har du allerede tilgang til Gjensidiges GitHub-organisasjon?** Hopp videre til Steg 2.

For å bruke OpenCode med Gjensidiges repoer trenger du en GitHub-konto koblet til Gjensidiges organisasjon. Følg disse stegene:

### 1a — Søk om tilgang i IdentityNow

1. Gå til **https://gjensidige.identitynow.com** og klikk på **Forespørselssenter**
2. Søk etter og be om tilgang til følgende:

| Tilgangspakke | Påkrevd | Hvorfor du trenger den |
|---------------|---------|------------------------|
| **ROLE_AAD_GITHUB_COPILOT_USERS** | Påkrevd | Gir deg GitHub Copilot-lisens, som er nødvendig for å bruke OpenCode |
| **PRG-github** | Påkrevd | Gir deg tilgang til Gjensidiges GitHub Enterprise-organisasjon |
| **PRG_GITHUB_DEVELOPERS** | Anbefalt | Gir skrivetilgang til de fleste repoer |

> Tilgangene godkjennes av Team Platform og kan ta litt tid. Fortsett gjerne med resten av installasjonen mens du venter.

### 1b — Klargjør GitHub-kontoen din

Har du ikke en GitHub-konto? Opprett en på **https://github.com/signup**. Bruk gjerne jobb-e-postadressen din (`@gjensidige.no`).

Har du allerede en privat GitHub-konto? Gjør dette for å koble den til Gjensidige:

1. Logg inn på **https://github.com** med din private konto
2. Gå til **Settings → Emails** og legg til `@gjensidige.no`-adressen din — verifiser den
3. Aktiver **Two-Factor Authentication** under **Settings → Password and authentication**
4. Fyll inn navnet ditt under **Settings → Public profile → Name** (påkrevd for å bli med i organisasjonen)

### 1c — Koble til Gjensidiges organisasjon via Azure AD

Når tilgangen fra 1a er godkjent:

1. Gå til **https://github.com/orgs/gjensidige/sso**
2. Logg inn med din Gjensidige-konto (Azure AD)

Dette knytter din GitHub-bruker til Gjensidiges organisasjon.

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

Du skal se noe som `v24.0.0` eller høyere.

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

> **Ingenting skjer etter at du limer inn?** Det er normalt — hvis det ikke dukker opp en rød feilmelding, har kommandoen fungert. Du kan gå videre til neste steg.

Dette gjelder kun din bruker og krever ikke admin.

#### 2b — Installer Node.js (ingen admin)

**Del 1 — Last ned Node.js**

1. Gå direkte til denne lenken:  
   **https://nodejs.org/dist/v24.18.0/node-v24.18.0-win-x64.zip**
2. Filen lastes ned automatisk til **Nedlastinger**-mappen din. Vent til den er ferdig.

**Del 2 — Pakk ut filen**

1. Åpne **Filutforsker** (trykk på mappeikonet på oppgavelinjen nederst på skjermen, eller trykk **Windows-tast + E**)
2. Klikk på **"Nedlastinger"** i menyen til venstre
3. Du skal se en fil som heter noe som `node-v24.x.x-win-x64.zip` — den har et glidelåsikon
4. **Høyreklikk** på filen
5. Velg **"Pakk ut alle..."** fra menyen som dukker opp
6. Et vindu åpner seg. Der står det en mappe-sti. **Slett det som står der** og skriv inn:  
   `C:\Users\DITTBRUKERNAVN\nodejs`  
   *(bytt ut `DITTBRUKERNAVN` med brukernavnet ditt på denne PC-en — det er ofte en kortform, en kode med bokstaver og tall, eller et datamaskinnavn, ikke nødvendigvis det fulle navnet ditt. Du finner det i adressefeltet i Filutforsker når du er inne i `C:\Users\`)*
7. Klikk **"Pakk ut"**
8. Vent til utpakkingen er ferdig. Det åpner seg kanskje en ny mappe automatisk — det er OK.

**Del 3 — Sjekk at mappen er riktig**

1. Åpne **Filutforsker** igjen
2. Klikk på **"Denne PCen"** i menyen til venstre
3. Dobbeltklikk på **"Lokal disk (C:)"**
4. Dobbeltklikk på **"Brukere"**
5. Dobbeltklikk på mappen med ditt brukernavn
6. Du skal nå se en mappe som heter **"nodejs"**
7. Dobbeltklikk på den — du skal se en fil som heter **`node.exe`** inne i mappen  
   *(hvis du ser en mappe inni mappen med samme navn, åpne den mappen også — `node.exe` skal ligge der)*  
   *(noter den fulle stien du ser i adressefeltet øverst i Filutforsker — du trenger den i neste steg)*

**Del 4 — Legg til i miljøvariabler**

1. Klikk på **Start-menyen** (Windows-ikonet nederst til venstre)
2. Skriv `rediger miljøvariabler for kontoen din` og trykk Enter
3. Et vindu åpner seg — du skal kun bruke seksjonen som heter **"Brukervariabler"** (ikke **"Systemvariabler"**)
4. Finn linjen som heter **"Path"** i Brukervariabler-listen
5. Klikk på **"Path"** slik at den blir markert (blå)
6. Klikk på **"Rediger..."**
7. Et nytt vindu åpner seg med en liste. Klikk på **"Ny"** øverst til høyre
8. Skriv inn stien til nodejs-mappen, f.eks.:  
   `C:\Users\DITTBRUKERNAVN\nodejs`  
   *(bytt ut `DITTBRUKERNAVN` med ditt brukernavn)*
9. Klikk **"OK"** — og **"OK"** igjen i alle vinduene som er åpne

**Del 5 — Verifiser installasjonen**

1. Åpne en **ny** PowerShell (viktig at det er et nytt vindu!)
2. Skriv inn og trykk Enter:

```powershell
node --version
```

Du skal se noe som `v24.0.0` eller høyere. Hvis du ser det — bra, Node.js er installert!

#### 2c — Installer OpenCode

1. Åpne **PowerShell**
2. Kjør denne kommandoen:

```powershell
npm install -g opencode-ai
```

Vent til installasjonen er ferdig. Du skal se at pakken lastes ned og installeres.

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

Første gang vil `npx` laste ned verktøyet og spørre:

```
Need to install the following packages:
opencode-setup@x.x.x
Ok to proceed? (y)
```

Skriv `y` og trykk **Enter** for å fortsette. Følg instruksjonene som vises. Du kan velge hvilke skills du vil installere, eller installere alle.

---

## Steg 4 — Start OpenCode

**Mac:** Åpne Terminal og skriv:
```
opencode
```

**Windows:** Åpne PowerShell og skriv:
```powershell
opencode
```

**Første gang du starter OpenCode** må du koble til og velge modell:

**Del 1 — Koble til GitHub**

1. Skriv `/connect` og trykk Enter
2. Velg **GitHub.com Public**
3. En boks vises med en lenke og en kode. Åpne lenken i nettleseren, lim inn koden, og godkjenn tilkoblingen

**Del 2 — Velg GitHub Copilot som provider og modell**

> Dette steget er viktig: OpenCode støtter mange AI-leverandører, men her på Gjensidige bruker vi **GitHub Copilot**.

4. Skriv `/models` og trykk Enter
5. Du får opp en liste over tilgjengelige providers — velg **GitHub Copilot**
6. Velg **Claude Opus** som modell
7. Velg **Default** når du blir spurt om variant

Dette lagres til neste gang — du trenger bare gjøre det én gang.

---

Skills er nå tilgjengelige. Det enkleste er å bare skrive:

```
fortsett oppsett
```

Da guider OpenCode deg gjennom alt steg for steg — MCP-er, GitHub, SSH og mer.

Du kan også skrive direkte hva du vil gjøre:

| Hva du vil gjøre | Skriv dette i OpenCode |
|------------------|------------------------|
| Bli guidet gjennom hele oppsettet | `fortsett oppsett` |
| Koble til GitHub, Jira, Figma eller Piwik | `koble til Jira` / `koble til GitHub` / `koble til Figma` |
| Sette opp GitHub SSH og signerte commits | `sett opp GitHub` |
| Se Figma-design direkte i OpenCode | Lim inn en Figma-lenke |

---

## Hva er skills?

Skills er instruksjoner som hjelper OpenCode å veilede deg gjennom kompliserte oppsett steg for steg.

| Skill | Hva den gjør |
|-------|-------------|
| `onboarding` | Guider deg gjennom hele oppsettet, husker hvor du er |
| `install-mcp` | Kobler OpenCode til GitHub, Jira, Figma og/eller Piwik Pro |
| `github-setup` | Setter opp SSH-nøkkel, SSO og signerte commits |
| `figma-mcp` | Hjelper deg utforske Figma-design direkte i OpenCode |
| `piwik-analytics` | Kobler OpenCode til Piwik Pro for besøksstatistikk |

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
