---
name: github-setup
description: Sett opp GitHub med SSH-nøkkel, autentiser med SSO og aktiver signerte commits. Bruk denne skill-en når noen spør om å "sette opp GitHub", "koble til GitHub", "lage SSH-nøkkel", "SSO GitHub", "signerte commits", "git-oppsett", "autentisere mot GitHub", "sette opp npm for Gjensidige", "installere npm-pakker fra GitHub", ".npmrc", "GPG", "commit signing", eller når de får feil som "Permission denied (publickey)", "401 Unauthorized" fra npm, eller "403 Forbidden" fra GitHub.
---

# GitHub SSH-oppsett, SSO og signerte commits

Denne skill-en setter opp GitHub fra scratch. Gå gjennom stegene i riktig rekkefølge. Still ett spørsmål om gangen og vent på svar.

---

## Sjekk først — ikke gjør det som allerede er på plass

Før du starter, kjør disse sjekkene og oppsummer hva som allerede er satt opp:

**SSH-nøkkel (Mac):**
```bash
ls ~/.ssh/id_ed25519.pub 2>/dev/null && echo "FUNNET" || echo "MANGLER"
```
**SSH-nøkkel (Windows):**
```powershell
if (Test-Path "$env:USERPROFILE\.ssh\id_ed25519.pub") { "FUNNET" } else { "MANGLER" }
```

**Git-konfig:**
```bash
git config --global user.name && git config --global user.email
```

**GPG-nøkkel:**
```bash
gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep sec || echo "MANGLER"
```

**Commit-signering:**
```bash
git config --global commit.gpgsign && git config --global user.signingkey
```

**npm for Gjensidige (Mac/Linux):**
```bash
grep "npm.pkg.github.com" ~/.npmrc 2>/dev/null && echo "FUNNET" || echo "MANGLER"
```
**npm for Gjensidige (Windows):**
```powershell
if (Select-String -Path "$env:USERPROFILE\.npmrc" -Pattern "npm.pkg.github.com" -Quiet 2>$null) { "FUNNET" } else { "MANGLER" }
```

Vis brukeren en kort oppsummering:

> Her er hva jeg fant:
> ✓ SSH-nøkkel — allerede på plass
> ✗ Git-konfig — mangler
> ✓ Signerte commits — allerede satt opp
> ...
>
> Vil du at jeg setter opp det som mangler?

Hopp over alt som allerede er på plass. Kjør aldri et steg på nytt hvis det allerede er fullført, med mindre brukeren eksplisitt ber om det (f.eks. "jeg vil lage en ny SSH-nøkkel").

---

## Steg 0 — Finn ut hvilket OS brukeren har

Spør:

> Bruker du **Mac** eller **Windows**?

Bruk svaret til å gi riktige kommandoer gjennom hele flyten.

---

## Steg 1 — Sjekk om GitHub allerede er autentisert

```bash
gh auth status 2>/dev/null && echo "FUNNET" || echo "MANGLER"
```

- Hvis `FUNNET`: merk som fullført, hopp til Steg 3
- Hvis `MANGLER`: gå til Steg 2

---

## Steg 2 — Autentiser mot GitHub med gh CLI

`gh` er GitHubs offisielle kommandolinje-verktøy. Det gjør innlogging enkelt — ingen SSH-nøkler, ingen tokens å kopiere manuelt.

---

### Mac/Linux — Installer gh

> Åpne en **ny terminalfane** og kjør:
>
> ```
> brew install gh
> ```

Hvis `brew` ikke er installert, se feilsøking nederst.

---

### Windows — Installer gh (ingen admin)

**Del 1 — Last ned**

> 1. Gå til: https://github.com/cli/cli/releases/latest
> 2. Finn filen som heter `gh_X.X.X_windows_amd64.zip` og last den ned
> 3. Pakk ut zip-filen til en mappe — f.eks. `C:\Users\DITTBRUKERNAVN\gh`
>    (Høyreklikk → "Pakk ut alle..." → velg mappen)

**Del 2 — Legg gh i miljøvariabler (Path)**

> 1. Klikk på **Start-menyen**
> 2. Skriv `rediger miljøvariabler for kontoen din` og trykk Enter
> 3. Finn linjen som heter **"Path"** i Brukervariabler-listen
> 4. Klikk på **"Path"** slik at den blir markert (blå)
> 5. Klikk på **"Rediger..."**
> 6. Klikk på **"Ny"**
> 7. Skriv inn stien til gh-mappen, f.eks.: `C:\Users\DITTBRUKERNAVN\gh\bin`
> 8. Klikk **"OK"** — og **"OK"** igjen

---

### Logg inn (begge OS)

> Åpne et **nytt terminalvindu** (viktig — det gamle ser ikke endringene) og kjør:
>
> ```
> gh auth login
> ```
>
> Velg:
> - **GitHub.com**
> - **HTTPS**
> - **Login with a web browser**
>
> En kode vises. Åpne lenken i nettleseren, lim inn koden, og godkjenn.

### Koble git til gh

```
gh auth setup-git
```

Dette konfigurerer git til å bruke gh-tokenet automatisk — du slipper å skrive passord eller håndtere nøkler.

### Sjekk at det virker

```
gh auth status
```

Du skal se `Logged in to github.com`. Gå videre til **Steg 3**.

---

## Steg 3 — Test tilkoblingen

Prøv å klone et repo for å bekrefte at alt virker:

**Mac/Linux:**
```bash
git clone https://github.com/gjensidige/builders-components.git /tmp/test-clone && rm -rf /tmp/test-clone
```

**Windows:**
```powershell
git clone https://github.com/gjensidige/builders-components.git $env:TEMP\test-clone
Remove-Item -Recurse -Force $env:TEMP\test-clone
```

Hvis det fungerer: autentiseringen er på plass.

---

## Steg 4 — Sett opp git-konfig

Sett navn og e-post (brukes i alle commits):

**Mac/Linux og Windows:**
```bash
git config --global user.name "Ditt Navn"
git config --global user.email "din@epost.no"
```

---

## Steg 5 — Signerte commits (GPG)

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

## Steg 6 — Test at alt fungerer

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

## Steg 7 — Gjensidige npm-pakker (.npmrc)

For å installere Gjensidige sine interne npm-pakker trenger du et GitHub-token med pakketilgang. Dette er **ikke** SSH-nøkkelen fra Steg 2 — det er et eget API-token.

### 9a — Opprett et GitHub-token (classic)

> 1. Gå til: https://github.com/settings/tokens
> 2. Klikk **"Generate new token"** → **"Generate new token (classic)"**  
>    ⚠️ Velg **classic** — ikke "Fine-grained tokens"
> 3. Gi det et navn — f.eks. `npm-gjensidige`
> 4. Sett gyldighet til **90 days**
> 5. Huk av for: **`read:packages`** — gir tilgang til å laste ned npm-pakker fra GitHub
> 6. Klikk **"Generate token"** nederst
> 7. Kopier tokenet (starter med `ghp_`) — det vises bare én gang
> 8. Klikk **"Configure SSO"** → **"Authorize"** ved siden av **Gjensidige**

Uten SSO-autorisering vil du få 401-feil ved `npm install`.

### 9b — Legg tokenet inn i .npmrc

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
