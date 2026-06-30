---
name: github-setup
description: Sett opp GitHub med SSH-nøkkel, autentiser med SSO og aktiver signerte commits. Bruk denne skill-en når noen spør om å "sette opp GitHub", "koble til GitHub", "lage SSH-nøkkel", "SSO GitHub", "signerte commits", "git-oppsett", "autentisere mot GitHub", eller når de får feil som "Permission denied (publickey)" fra GitHub. Trigger også ved "gpg", "git config", "commit signing".
---

# GitHub SSH-oppsett, SSO og signerte commits

Denne skill-en setter opp GitHub fra scratch. Gå gjennom stegene i riktig rekkefølge. Still ett spørsmål om gangen og vent på svar.

---

## Steg 0 — Finn ut hvilket OS brukeren har

Spør:

> Bruker du **Mac** eller **Windows**?

Bruk svaret til å gi riktige kommandoer gjennom hele flyten.

---

## Steg 1 — Sjekk om SSH-nøkkel allerede finnes

**Mac/Linux:**
```bash
ls ~/.ssh/id_ed25519.pub
```

**Windows (PowerShell):**
```powershell
dir $env:USERPROFILE\.ssh\id_ed25519.pub
```

Hvis filen finnes: hopp til Steg 3 (legg inn i GitHub).

Hvis ikke: gå til Steg 2.

---

## Steg 2 — Lag SSH-nøkkel

Be brukeren kjøre (bytt ut e-postadressen med sin GitHub-e-post):

**Mac/Linux:**
```bash
ssh-keygen -t ed25519 -C "din@epost.no"
```

Når terminalen spør:
- `Enter file in which to save the key` → trykk **Enter** (standard plassering er bra)
- `Enter passphrase` → **velg et passord du husker — dette er påkrevd, ikke trykk Enter uten passord**
- `Enter same passphrase again` → gjenta passordet

Bekreft at det gikk bra:
```bash
ls ~/.ssh/id_ed25519.pub
```

**Windows (PowerShell):**
```powershell
ssh-keygen -t ed25519 -C "din@epost.no"
```

Samme svar på spørsmålene som på Mac — husk at passphrase er påkrevd. Bekreft:
```powershell
dir $env:USERPROFILE\.ssh\id_ed25519.pub
```

---

## Steg 3 — Legg SSH-nøkkelen inn i GitHub

Vis innholdet i den offentlige nøkkelen:

**Mac/Linux:**
```bash
cat ~/.ssh/id_ed25519.pub
```

**Windows (PowerShell):**
```powershell
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub
```

Kopier hele linjen som vises (starter med `ssh-ed25519`). Gå så til GitHub:

> 1. Gå til: https://github.com/settings/keys
> 2. Klikk **"New SSH key"**
> 3. Gi nøkkelen et navn — f.eks. `min-jobb-pc`
> 4. Lim inn nøkkelen i feltet **"Key"**
> 5. Klikk **"Add SSH key"**

---

## Steg 4 — Aktiver SSO for organisasjonen (hvis nødvendig)

Hvis GitHub-kontoen er koblet til en organisasjon som bruker SSO (f.eks. Gjensidige):

> 1. Gå tilbake til https://github.com/settings/keys
> 2. Finn nøkkelen du nettopp la til
> 3. Klikk **"Configure SSO"** ved siden av nøkkelen
> 4. Klikk **"Authorize"** ved siden av organisasjonsnavnet

Uten dette steget vil nøkkelen ikke fungere mot organisasjonens repositories.

---

## Steg 5 — Test tilkoblingen

**Mac/Linux:**
```bash
ssh -T git@github.com
```

**Windows (PowerShell):**
```powershell
ssh -T git@github.com
```

Forventet svar (det er OK selv om det sier "permission denied" til "you've successfully authenticated"):
```
Hi brukernavn! You've successfully authenticated, but GitHub does not provide shell access.
```

Hvis du ser `Permission denied (publickey)`: sjekk at nøkkelen ble lagt til riktig i GitHub, og at SSH-agenten kjører (se feilsøking under).

---

## Steg 6 — Sett opp git-konfig

Sett navn og e-post (brukes i alle commits):

**Mac/Linux og Windows:**
```bash
git config --global user.name "Ditt Navn"
git config --global user.email "din@epost.no"
```

---

## Steg 7 — Signerte commits (GPG)

Signerte commits viser en grønn "Verified"-badge på GitHub. Dette krever GPG.

### 7a — Sjekk om GPG er installert

**Mac:**
```bash
gpg --version
```
Hvis ikke installert:
```bash
brew install gnupg
```
Hvis `brew` ikke er installert, se feilsøking.

**Windows (PowerShell):**
```powershell
gpg --version
```
Hvis ikke installert, last ned fra https://www.gpg4win.org/ og kjør installeren.

> **Windows uten admin:** Gpg4win krever dessverre admin. Alternativet er å bruke GitHub sin SSH-signering i stedet (se Steg 7c).

### 7b — Lag GPG-nøkkel

**Mac/Linux og Windows:**
```bash
gpg --full-generate-key
```

Velg:
- Key type: `1` (RSA and RSA)
- Key size: `4096`
- Expiry: `0` (utløper aldri)
- Navn og e-post (bruk samme e-post som på GitHub)
- Passord: velg noe du husker

Finn nøkkelens ID:
```bash
gpg --list-secret-keys --keyid-format=long
```

Kopier ID-en som vises etter `sec rsa4096/` (de 16 tegnene).

Eksporter offentlig nøkkel:
```bash
gpg --armor --export DIN_NOKKEL_ID
```

Legg inn på GitHub:
> 1. Gå til https://github.com/settings/gpg/new
> 2. Lim inn nøkkelen
> 3. Klikk **"Add GPG key"**

Aktiver signing i git:
```bash
git config --global user.signingkey DIN_NOKKEL_ID
git config --global commit.gpgsign true
```

**Mac — fortell git hvor GPG er:**
```bash
git config --global gpg.program $(which gpg)
```

### 7c — Alternativ: SSH-signering (Windows uten admin)

Hvis GPG ikke er mulig (f.eks. Windows uten admin), bruk SSH-nøkkelen til signering i stedet:

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
```

**Windows:**
```powershell
git config --global gpg.format ssh
git config --global user.signingkey $env:USERPROFILE\.ssh\id_ed25519.pub
git config --global commit.gpgsign true
```

Legg til SSH-nøkkelen som signeringsnøkkel på GitHub:
> 1. Gå til https://github.com/settings/keys
> 2. Klikk **"New SSH key"**
> 3. Under **Key type**, velg **"Signing Key"**
> 4. Lim inn den samme nøkkelen som i Steg 3
> 5. Klikk **"Add SSH key"**

---

## Steg 8 — Test at alt fungerer

Lag en testkommit:

```bash
git init /tmp/test-repo
cd /tmp/test-repo
echo "test" > test.txt
git add test.txt
git commit -m "Test signert commit"
git log --show-signature
```

Du skal se `gpg: Good signature` eller `Good "git" signature`.

---

## Feilsøking

**SSH-agenten kjører ikke (Mac/Linux):**
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

**SSH-agenten kjører ikke (Windows):**
```powershell
Start-Service -Name ssh-agent
ssh-add $env:USERPROFILE\.ssh\id_ed25519
```
Hvis `ssh-agent`-tjenesten ikke er aktiv: Åpne **Tjenester** (services.msc), finn **OpenSSH Authentication Agent**, høyreklikk → **Egenskaper** → sett **Oppstartstype** til **Automatisk**, klikk **Start**.

**brew ikke installert (Mac):**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Følg instruksjonene, og kjør deretter `eval "$(/opt/homebrew/bin/brew shellenv)"` for å aktivere det.

**GPG spør om passord ved hver commit (Mac):**
```bash
echo "default-cache-ttl 28800" >> ~/.gnupg/gpg-agent.conf
echo "max-cache-ttl 28800" >> ~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent
```

---

## Steg 9 — Gjensidige npm-pakker (.npmrc)

For å kunne installere Gjensidige sine interne npm-pakker må du legge inn GitHub-tokenet ditt i `.npmrc`.

Bruk det samme tokenet du lagde i Steg 3 (det som starter med `ghp_`).

**Mac/Linux:**
```bash
echo "@gjensidige:registry=https://npm.pkg.github.com" >> ~/.npmrc
echo "//npm.pkg.github.com/:_authToken=TOKENET_DITT" >> ~/.npmrc
```

**Windows (PowerShell):**
```powershell
Add-Content $env:USERPROFILE\.npmrc "@gjensidige:registry=https://npm.pkg.github.com"
Add-Content $env:USERPROFILE\.npmrc "//npm.pkg.github.com/:_authToken=TOKENET_DITT"
```

Bytt ut `TOKENET_DITT` med ditt faktiske token (f.eks. `ghp_xxxxxxxxxxxxxxxxxxxxxx`).

Bekreft at filen ble riktig:

**Mac/Linux:**
```bash
cat ~/.npmrc
```

**Windows:**
```powershell
Get-Content $env:USERPROFILE\.npmrc
```

Du skal se:
```
@gjensidige:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=ghp_xxxxxxxxxxxxxxxxxxxxxx
```

> **Viktig:** Pass på at tokenet har `read:packages`-tilgang på GitHub, og at SSO er autorisert for Gjensidige-organisasjonen (se Steg 4). Uten SSO-autorisering vil du få 401-feil når du kjører `npm install`.
