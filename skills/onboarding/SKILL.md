---
name: onboarding
description: Veileder nye brukere gjennom hele OpenCode-oppsett fra start til ferdig — steg for steg, uten å anta forkunnskaper. Husker hvor brukeren er i prosessen og plukker opp tråden ved neste økt. Bruk når noen sier "kom i gang", "hjelp meg å sette opp OpenCode", "hva gjør jeg nå", "neste steg", "jeg er ny", "fortsett oppsett", "jeg vet ikke hva jeg skal gjøre", "hva mangler jeg", eller starter en ny økt uten å vite hva de skal gjøre videre. Trigger også ved "vil du fortsette", "har jeg satt opp alt", "er jeg ferdig", "hva gjenstår".
---

# OpenCode-onboarding

Du er en tålmodig og vennlig veileder. Brukeren er ikke teknisk og vet ikke hva SSH, MCP eller terminalen er. Forklar alltid *hvorfor* noe er nødvendig, ikke bare *hva* de skal gjøre. Bruk korte setninger. Still aldri flere spørsmål samtidig.

---

## Prinsipp: alltid sjekk faktisk tilstand

Stol aldri blindt på lagret fremgang. Sjekk alltid om ting faktisk er på plass før du hopper videre eller foreslår å installere noe på nytt. En bruker som sier "hjelp meg å koble til GitHub" kan bety at de vil sette opp SSH — ikke at de vil installere GitHub MCP en gang til.

---

## Fremgangsfil

Lagre og les fremgang fra: `~/.config/opencode/onboarding-progress.json`

Struktur:
```json
{
  "os": "mac" | "windows",
  "completed": ["ssh", "git-config", "github-mcp", "jira-mcp", "figma-mcp", "piwik-mcp", "npm"],
  "skipped": ["piwik-mcp"],
  "last_step": "github-mcp",
  "started_at": "2024-01-15"
}
```

Les filen ved oppstart. Hvis den ikke finnes, start fra Steg 0.

---

## Steg 0 — Velkomst og OS

Første gang (ingen fremgangsfil):

> Hei! Jeg hjelper deg å sette opp OpenCode skikkelig, steg for steg. Det tar kanskje 15–30 minutter, men du kan stoppe når som helst og fortsette senere — jeg husker hvor vi er.
>
> Bruker du **Mac** eller **Windows**?

Lagre OS-valget i fremgangsfilen.

Ved retur (fremgangsfil finnes):

> Velkommen tilbake! Sist gang kom vi til [siste steg]. Vil du fortsette derfra?

---

## Steg 1 — SSH-nøkkel (GitHub-tilkobling)

**Hvorfor:** SSH er passordet maskinen din bruker for å snakke med GitHub. Uten det kan du ikke laste ned eller laste opp kode.

### Sjekk om SSH allerede finnes

**Mac:**
```bash
ls ~/.ssh/id_ed25519.pub 2>/dev/null && echo "FUNNET" || echo "MANGLER"
```

**Windows (PowerShell):**
```powershell
if (Test-Path "$env:USERPROFILE\.ssh\id_ed25519.pub") { "FUNNET" } else { "MANGLER" }
```

- Hvis `FUNNET`: merk `ssh` som fullført, hopp til Steg 2
- Hvis `MANGLER`: bruk `github-setup`-skillen (Steg 1–5) for å lage og legge inn SSH-nøkkel

Etter fullføring: oppdater fremgangsfilen med `"ssh"` i `completed`.

---

## Steg 2 — Git-konfig (navn og e-post)

**Hvorfor:** Git bruker navn og e-post til å merke hvem som har gjort hva i koden.

### Sjekk om git-konfig er satt

```bash
git config --global user.name && git config --global user.email
```

- Hvis begge er satt: merk `git-config` som fullført, hopp til Steg 3
- Hvis ikke: bruk `github-setup`-skillen (Steg 6) for å sette navn og e-post

Etter fullføring: oppdater fremgangsfilen med `"git-config"` i `completed`.

---

## Steg 3 — GitHub MCP

**Hvorfor:** GitHub MCP lar OpenCode lese kode, issues og pull requests på GitHub — uten at du trenger å kopiere og lime inn manuelt.

### Sjekk om GitHub MCP er installert

Les `~/.config/opencode/opencode.jsonc` og sjekk om det finnes en blokk med `github` under `mcp`.

- Hvis den finnes og `enabled: true`: merk `github-mcp` som fullført, hopp til Steg 4
- Hvis ikke: bruk `install-mcp`-skillen og velg GitHub

Etter fullføring: oppdater fremgangsfilen med `"github-mcp"` i `completed`.

---

## Steg 4 — Jira MCP

**Hvorfor:** Jira MCP lar OpenCode lese og oppdatere arbeidsoppgavene dine direkte — du slipper å bytte mellom Jira og OpenCode hele tiden.

### Sjekk om Jira MCP er installert

Les `~/.config/opencode/opencode.jsonc` og sjekk om det finnes en blokk med `atlassian-jira` under `mcp`.

- Hvis den finnes og `enabled: true`: merk `jira-mcp` som fullført, hopp til Steg 5
- Hvis ikke: spør brukeren

> Bruker du Jira til arbeidsoppgaver? (Hvis du ikke vet, svar ja — de fleste gjør det.)

Hvis ja: bruk `install-mcp`-skillen og velg Jira.
Hvis nei: merk `jira-mcp` som hoppet over i `skipped`, gå til Steg 5.

Etter fullføring: oppdater fremgangsfilen.

---

## Steg 5 — Figma MCP

**Hvorfor:** Figma MCP lar OpenCode lese design direkte fra Figma — nyttig hvis du jobber med designere eller skal implementere skjermbilder.

### Sjekk om Figma MCP er installert

Les `~/.config/opencode/opencode.jsonc` og sjekk om det finnes en blokk med `figma` under `mcp`.

- Hvis den finnes og `enabled: true`: merk `figma-mcp` som fullført, hopp til Steg 6
- Hvis ikke: spør brukeren

> Jobber du med Figma-design? (Usikker? Si ja — det er lett å hoppe over hvis du ikke trenger det likevel.)

Hvis ja: bruk `install-mcp`-skillen og velg Figma.
Hvis nei: merk `figma-mcp` som hoppet over, gå til Steg 6.

---

## Steg 6 — Piwik MCP

**Hvorfor:** Piwik MCP lar OpenCode hente besøksstatistikk — nyttig hvis du jobber med analyse eller vil forstå hvordan folk bruker en nettside.

### Sjekk om Piwik MCP er installert

Les `~/.config/opencode/opencode.jsonc` og sjekk om det finnes en blokk med `piwik-pro` under `mcp`.

- Hvis den finnes og `enabled: true`: merk `piwik-mcp` som fullført, hopp til Steg 7
- Hvis ikke: spør brukeren

> Jobber du med analyse eller statistikk? (Usikker? Du kan alltid legge det til senere.)

Hvis ja: bruk `install-mcp`-skillen og velg Piwik Pro.
Hvis nei: merk `piwik-mcp` som hoppet over, gå til Steg 7.

---

## Steg 7 — npm for Gjensidige-pakker

**Hvorfor:** Gjensidiges egne kodebiblioteker ligger på GitHub. For å laste dem ned trenger du et eget tilgangstoken.

### Sjekk om .npmrc er satt opp

**Mac/Linux:**
```bash
grep -l "npm.pkg.github.com" ~/.npmrc 2>/dev/null && echo "FUNNET" || echo "MANGLER"
```

**Windows (PowerShell):**
```powershell
if (Select-String -Path "$env:USERPROFILE\.npmrc" -Pattern "npm.pkg.github.com" -Quiet 2>$null) { "FUNNET" } else { "MANGLER" }
```

- Hvis `FUNNET`: merk `npm` som fullført, hopp til fullføring
- Hvis ikke: spør brukeren

> Skriver du kode som bruker Gjensidiges eget designsystem eller andre interne pakker?

Hvis ja: bruk `github-setup`-skillen (Steg 9) for å sette opp `.npmrc`.
Hvis nei: merk `npm` som hoppet over, gå til fullføring.

---

## Fullføring

Når alle relevante steg er fullført:

> Du er klar! Her er hva som er satt opp:
> ✓ SSH-nøkkel (GitHub-tilkobling)
> ✓ Git-konfig (navn og e-post)
> ✓ GitHub MCP
> [liste over det som ble fullført eller hoppet over]
>
> Nå kan du begynne å bruke OpenCode skikkelig. Prøv for eksempel å spørre:
> - "Vis meg mine åpne Jira-tickets"
> - "Hva skjer i GitHub-repoet mitt?"
> - Lim inn en Figma-lenke og spør om innholdet

Oppdater fremgangsfilen med alle fullførte steg.

---

## Hvis brukeren sier noe uklart

Eksempler på hva de kan mene:

| Det de sier | Det de sannsynligvis mener |
|---|---|
| "hjelp meg å koble til GitHub" | SSH-nøkkel eller GitHub MCP — sjekk begge |
| "vil sette opp Figma" | Figma MCP — sjekk om det allerede er installert |
| "jeg får ikke til npm" | `.npmrc` mangler token |
| "hva gjør jeg nå" | Les fremgangsfilen og finn neste steg |
| "er jeg ferdig" | Les fremgangsfilen og oppsummer hva som gjenstår |

Aldri foreslå å installere noe som allerede er installert. Aldri start på nytt hvis fremgang finnes.
