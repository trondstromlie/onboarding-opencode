# OpenCode — Kom i gang

Denne guiden setter opp **OpenCode** på maskinen din og gjør deg klar for agentisk koding — at du jobber sammen med en AI-agent som kan lese, skrive og kjøre kode for deg.

Du går gjennom fire steg: tilgang til Gjensidiges GitHub, installasjon av Node.js og OpenCode, ferdige "skills" (hjelpere), og til slutt oppstart.

Når alt er på plass, kan du be OpenCode om å sette opp GitHub, koble til Jira/Figma, og mer — OpenCode veileder deg steg for steg og hjelper deg å finne riktig informasjon underveis.

---

## Steg 1 — Koble GitHub-kontoen din til Gjensidige

> **Har du allerede tilgang til Gjensidiges GitHub-organisasjon?** Hopp videre til Steg 2.

For å bruke OpenCode med Gjensidiges repoer trenger du en GitHub-konto koblet til Gjensidiges organisasjon. Følg disse stegene:

### 1a — Søk om tilgang

**Copilot-lisens (ny self-service-løsning):**

Gå til **https://ai-hub.gjensidige.io/copilot** og klikk **"Be om tilgang"**. Dette er den enkleste måten å få Copilot-lisens på.

<details>
<summary><strong>Fungerte ikke self-service-løsningen? Prøv den gamle metoden her.</strong></summary>

Gå til **https://myaccess.microsoft.com** og søk om:

| Tilgangspakke | Hvorfor du trenger den |
|---------------|------------------------|
| **ROLE_AAD_GITHUB_COPILOT_USERS** | Gir deg GitHub Copilot-lisens |

</details>

**GitHub-medlemskap** — i tillegg trenger du disse tilgangene fra **IdentityNow** (gå til **https://gjensidige.identitynow.com** og klikk på **Forespørselssenter**):

| Tilgangspakke | Hvorfor du trenger den |
|---------------|------------------------|
| **GitHub Enterprise** | Gjør deg til medlem av Gjensidiges GitHub-organisasjon — **uten denne aktiveres ikke Copilot-lisensen** |
| **GitHub Developer** | Gir skrivetilgang til de fleste repoer — **anbefalt hvis du skal jobbe med kode i Gjensidiges repoer** |

> Tilgangene godkjennes og kan ta litt tid. Fortsett gjerne med resten av installasjonen mens du venter.

> **Advarsel:** OpenCode kommer ikke til å virke før tilgangene er på plass. Copilot-lisensen **og** GitHub Enterprise må være godkjent, og SSO-koblingen i steg 1c må være gjort, før GitHub Copilot fungerer i OpenCode. Du kan installere ferdig i mellomtiden, men vent med å teste OpenCode til tilgangene er godkjent.

**Ekstra tilgang — kun for Skadefryd hackaton**

Skal du være med på **Skadefryd hackaton** (https://skadefryd.tech/)? Da må du i tillegg søke om denne tilgangen i **MyAccess**:

| Tilgangspakke | Hvorfor du trenger den |
|---------------|------------------------|
| **GenAI Small Consumer (Prod)** | Gir tilgang til GenAI-tjenestene som brukes under hackatonet |

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

#### Prøv dette først — automatisk installasjon (enklest)

1. Åpne **Terminal** (søk etter "Terminal" i Spotlight, eller finn den i Programmer → Verktøy)
2. Lim inn denne kommandoen og trykk Enter:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/trondstromlie/onboarding-opencode/main/mac/install.sh)"
```

3. Scriptet installerer alt du trenger: Homebrew (hvis du ikke har det), Node.js, Git, GitHub CLI, Azure CLI, OpenCode og skills.
4. **Det kan ta flere minutter** — spesielt Azure CLI er stor. La vinduet stå åpent og vent.
5. Blir du bedt om et passord, er det **Mac-passordet** ditt (det du logger inn med).
6. Når det er ferdig åpnes nettleseren automatisk med neste steg.

> **Feilet noe underveis?** Kjør kommandoen en gang til. Det som allerede er installert hoppes over, så andre forsøk går som regel igjennom.

---

> **Fungerte ikke den automatiske installasjonen?** Følg den manuelle fremgangsmåten under.

<details>
<summary><strong>Manuell installasjon (backup)</strong></summary>

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

</details>

---

### Windows

> **Merk:** Disse instruksjonene er laget for Windows-brukere uten administratortilgang.  
> Alt installeres i din egen brukerprofil — ingen admin-rettigheter nødvendig.

#### Prøv dette først — automatisk installasjon (enklest)

**Del 1 — Last ned filen**

1. Klikk på denne lenken for å laste ned:  
   **[Last ned opencode-setup-windows.zip](https://github.com/trondstromlie/onboarding-opencode/releases/latest/download/opencode-setup-windows.zip)**
2. Nettleseren spør kanskje om du vil beholde filen. Klikk **"Behold"** eller **"Keep"** hvis det dukker opp.
3. Filen lastes ned til **Nedlastinger**-mappen din. Vent til den er ferdig — det tar noen sekunder.

**Del 2 — Pakk ut filen**

En ZIP-fil er som en konvolutt med innhold inni. Du må åpne konvolutten før du kan bruke innholdet.

1. Trykk på mappeikonet nede på oppgavelinjen (eller trykk **Windows-tast + E**) for å åpne Filutforsker
2. Klikk på **"Nedlastinger"** i menyen til venstre
3. Du skal se en fil som heter **`opencode-setup-windows.zip`** — den har et glidelåsikon på seg
4. **Høyreklikk** på filen (trykk på høyre museknapp)
5. Velg **"Pakk ut alle..."** fra menyen som dukker opp  
   *(På engelsk: "Extract All...")*
6. Et lite vindu åpner seg. Klikk bare på **"Pakk ut"** — du trenger ikke endre noe
7. En ny mappe åpner seg automatisk med innholdet

**Del 3 — Kjør installasjonen**

Inne i mappen som åpnet seg skal du se en fil som heter **`install.bat`**.

1. **Dobbeltklikk** på **`install.bat`**

> **Får du en advarsel fra Windows?** Det er normalt for filer lastet ned fra internett.  
> - Blå boks: Klikk **"Mer informasjon"** og deretter **"Kjør likevel"**  
> - Gul boks: Klikk **"Ja"**

2. Et svart vindu åpner seg og viser hva som skjer. **Ikke lukk dette vinduet** — det jobber i bakgrunnen.
3. Installasjonen laster ned flere pakker og **kan ta opptil 10 minutter**. Spesielt utpakkingen av Azure CLI går tregt fordi antivirus skanner alle filene — det ser ut som at det henger, men det jobber. La vinduet stå åpent og vent.
4. Vent til det stopper og du ser **"Ferdig!"**
5. Nettleseren din åpner seg automatisk med neste steg.

> **Feilet installasjonen underveis?** Kjør **`install.bat`** en gang til. Det som allerede er installert hoppes over, så andre forsøk går som regel igjennom.

---

> **Fungerte ikke den automatiske installasjonen?** Følg den manuelle fremgangsmåten under.

<details>
<summary><strong>Manuell installasjon (backup)</strong></summary>

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

</details>

---

## Steg 3 — Installer skills

> **Brukte du den automatiske installasjonen (ZIP-filen) på Windows?** Skills ble allerede installert automatisk — hopp videre til Steg 4.

**Mac:**
```
npx opencode-setup
```

**Windows (manuell installasjon):**
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
2. Du blir spurt om hvilken GitHub Copilot du vil bruke — **velg `GitHub.com Public`** (den øverste), **ikke** Enterprise
3. En boks vises med en lenke og en kode. Åpne lenken i nettleseren, lim inn koden, og godkjenn tilkoblingen

> **Viktig:** Velg alltid **Public**, ikke **Enterprise**. Enterprise-varianten fungerer ikke her og gir feil senere når du skal velge modell.

> **Går OpenCode tilbake til `/connect` etter at du godkjente i nettleseren?**  
> Det betyr at GitHub-tokenet ble utstedt ok, men Copilot-lisensen din er ikke aktiv ennå — eller den er ikke koblet til kontoen din riktig. Gjør dette:
> 1. Sjekk om Copilot-lisensen er aktiv ved å kjøre denne kommandoen i Terminal/PowerShell:
>    ```
>    gh api /user/copilot_billing
>    ```
>    Ser du `"enabled": true` i svaret? Da er lisensen ok — hopp til punkt 3.  
>    Får du en feil eller tomt svar? Da mangler lisensen — fortsett til punkt 2.
> 2. Sjekk at **begge** tilgangene er godkjent: `ROLE_AAD_GITHUB_COPILOT_USERS` (MyAccess) **og** `GitHub Enterprise` (IdentityNow). Tilgangene kan ta tid å aktivere — vent og prøv igjen senere.
> 3. Gå til **https://github.com/settings/copilot** og se etter seksjonen **"Get Copilot from an organization"**. Klikk **"Ask admin for access"** hvis den vises — dette sender en forespørsel til Gjensidiges GitHub-administrator om å aktivere Copilot for kontoen din. Merk: det kan ta opptil en dag før tilgangen trer i kraft.
> 4. Sjekk at du har fullført SSO-koblingen: gå til **https://github.com/orgs/gjensidige/sso** og logg inn med Gjensidige-kontoen din
> 5. Prøv `/connect` på nytt

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

## Hva kan jeg gjøre nå?

Her er eksempler på hva du kan spørre OpenCode om etter at MCP-ene er koblet til:

### GitHub
```
Lag et visuelt HTML-dashboard over hva teamet har levert siste 4 uker.
Vis PRs som er merget, en tidslinje over aktivitet og hvilke områder
av koden som har vært mest aktive. Bruk farger, ikoner og animasjoner
— det skal gi en umiddelbar følelse av fremdrift.
```
```
Lag en interaktiv HTML-side som viser alle åpne issues i repoet vårt.
Grupper dem etter tema og vis en tydelig status på hva som er under
arbeid og hva som blokkerer oss. Det skal være enkelt å forstå for
noen som ikke er utvikler.
```

### Jira
```
Lag et visuelt HTML-dashboard over sprinten vår. Vis hvor mange
oppgaver som er ferdige, hva som er i gang og hva som ikke er startet
— som et burndown-diagram og fargede statuskort. Det skal gi et
umiddelbart bilde av hvordan vi ligger an.
```
```
Lag en interaktiv HTML-oversikt over alle oppgavene som er tildelt
teamet mitt. Grupper etter person, vis hvem som har mest på bordet,
og marker tydelig hva som er blokkert eller forsinket.
```
```
Oppsummer alle oppgavene i prosjektet [PROSJEKTNØKKEL] som ble lukket
denne måneden, og lag en kort statusrapport jeg kan sende til ledelsen
— i klarspråk, uten sjargong.
```
```
Opprett en ny Jira-oppgave: "[tittel]" med en tydelig beskrivelse
av hva som skal gjøres og hvorfor
```
```
Vis meg mine åpne oppgaver, sortert etter frist
```

### Figma
```
[lim inn en Figma-lenke]
```
```
Hva er fargene og typografien som brukes i dette designet?
```
```
Lag en React-komponent basert på denne Figma-seksjonen
```

### Piwik
```
Lag et imponerende interaktivt HTML-dashboard for trafikken på [URL]
siste 30 dager. Vis besøkstrender som animerte grafer, topp-sider,
enhetsfordeling og hvilke dager som hadde mest aktivitet. Det skal
se ut som noe du ville vist frem i en presentasjon.
```
```
Analyser brukeratferden på [URL] og lag en visuell HTML-rapport som
viser hvor brukerne faller av, hvilke sider som presterer best, og
hva vi bør prioritere å forbedre. Presenter det med farger og grafer
— ikke bare tabeller.
```
```
Sammenlign trafikk denne uken mot forrige uke
```

### Kombiner flere kilder

Det kraftigste er når OpenCode henter fra flere MCP-er samtidig — for
eksempel GitHub, Jira og Piwik i samme oversikt.

```
Lag en interaktiv HTML-tidslinje som kobler sammen de siste commitene
i repoet vårt med trafikktallene fra Piwik for [URL]. Vis hvordan
besøk og brukeratferd endrer seg rundt hver leveranse, og koble hver
commit til Jira-oppgaven den hører til. Bruk farger og grafer så det
er lett å se hva som ga effekt.
```
```
Lag en statusrapport for sprinten som kombinerer Jira og GitHub:
vis hvilke Jira-oppgaver som er ferdige, hvilke PRs som hører til
hver oppgave, og hva som fortsatt gjenstår. Presenter det som en
visuell HTML-side jeg kan vise frem i sprint-gjennomgangen.
```
```
Analyser de siste leveransene våre: hent merget PRs fra GitHub,
finn Jira-oppgavene de løser, og sammenhold med trafikk- og
konverteringstallene fra Piwik. Lag en HTML-rapport som viser hvilke
leveranser som faktisk flyttet tallene, og hva vi bør prioritere neste.
```
```
Lag en oversikt over hva teamet har levert siste måned: kombiner
lukkede Jira-oppgaver, merget PRs fra GitHub og trafikkutviklingen
fra Piwik til én visuell tidslinje i klarspråk — noe jeg kan sende
til ledelsen.
```

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

**Jeg får feilmeldingen "running scripts is disabled on this system"?**  
Windows blokkerer kjøring av PowerShell-scripts som standard. Lim inn denne kommandoen i PowerShell og trykk Enter:
```
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```
Skriv `J` hvis du blir spurt om å bekrefte, og prøv igjen.  
Merk: bruk alltid **Windows PowerShell** (64-bit) — ikke PowerShell (x86).

**Jeg er usikker — kan jeg bare spørre i OpenCode?**  
Ja! Etter at du har installert skills, kan du skrive hva du trenger hjelp med og OpenCode vil veilede deg.

**`/models` viser en tom liste eller jeg havner i en loop?**  
Dette skyldes som regel at GitHub Copilot-lisensen ikke er aktivert. Sjekk følgende:
1. Har du fått godkjent **`ROLE_AAD_GITHUB_COPILOT_USERS`** i MyAccess **og** **`GitHub Enterprise`** i IdentityNow?  
   Copilot-lisensen aktiveres kun når du er medlem av Gjensidiges GitHub-organisasjon — begge tilgangene må være på plass.
2. Har du fullført SSO-koblingen i **steg 1c** (logget inn på `https://github.com/orgs/gjensidige/sso`)?  
3. Prøv å skrive `/connect` på nytt i OpenCode og koble til på nytt.

Hvis alt over er i orden og det fortsatt ikke fungerer — ta kontakt med **Trond Strøm-Lie** på Slack.

---

## Problemer?

Ta kontakt med **Trond Strøm-Lie** på Slack: `@Trond Strøm-Lie`
