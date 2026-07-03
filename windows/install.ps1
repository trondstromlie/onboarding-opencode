# ── konfig ────────────────────────────────────────────────────────────────────
$NodeVersion  = "24.18.0"
$GhVersion    = "2.96.0"
$AzCliVersion = "2.87.0"
$GitVersion   = "2.55.0.2"

$NodeUrl  = "https://nodejs.org/dist/v$NodeVersion/node-v$NodeVersion-win-x64.zip"
$GhUrl    = "https://github.com/cli/cli/releases/download/v$GhVersion/gh_${GhVersion}_windows_amd64.zip"
$AzCliUrl = "https://azcliprod.blob.core.windows.net/zip/azure-cli-${AzCliVersion}-x64.zip"
$GitUrl   = "https://github.com/git-for-windows/git/releases/download/v2.55.0.windows.2/MinGit-${GitVersion}-64-bit.zip"

$ToolsDir = "$env:USERPROFILE\tools"
$NodeDir  = "$ToolsDir\nodejs"
$GhDir    = "$ToolsDir\gh"
$AzCliDir = "$ToolsDir\azcli"
$GitDir   = "$ToolsDir\git"
$TempDir  = "$env:TEMP\opencode-install"
$ReadmeUrl = "https://github.com/trondstromlie/onboarding-opencode#steg-3--installer-skills"

$ErrorActionPreference = "Stop"

# ── hjelpefunksjoner ──────────────────────────────────────────────────────────
function Write-Step($msg) {
    Write-Host "`n$msg" -ForegroundColor Cyan
}

function Write-Ok($msg) {
    Write-Host "  OK  $msg" -ForegroundColor Green
}

function Write-Fail($msg) {
    Write-Host "`n  FEIL: $msg" -ForegroundColor Red
}

function Add-ToUserPath($newPath) {
    $current = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($current -notlike "*$newPath*") {
        [Environment]::SetEnvironmentVariable("Path", "$current;$newPath", "User")
        Write-Ok "Lagt til i PATH: $newPath"
    } else {
        Write-Host "  --  Allerede i PATH: $newPath" -ForegroundColor Yellow
    }
}

function Invoke-Download($url, $outFile, $navn) {
    Write-Step "Laster ned $navn..."
    try {
        Invoke-WebRequest -Uri $url -OutFile $outFile -UseBasicParsing
        Write-Ok "Nedlasting ferdig"
    } catch {
        Write-Fail "Klarte ikke laste ned $navn. Sjekk internettilkoblingen og prøv igjen."
        Write-Host "  Feilmelding: $_" -ForegroundColor DarkRed
        Write-Host "`n  Gaa til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
        Read-Host "`nTrykk Enter for aa lukke"
        exit 1
    }
}

function Expand-AndMove($zipPath, $destDir, $navn, $innerDirPattern = $null) {
    Write-Step "Pakker ut $navn..."
    try {
        $extractTemp = "$TempDir\extract-$navn"
        Expand-Archive -Path $zipPath -DestinationPath $extractTemp -Force

        if ($innerDirPattern) {
            # ZIP har en mappe inni seg — flytt den mappen til destDir
            $inner = Get-ChildItem $extractTemp -Directory | Where-Object { $_.Name -like $innerDirPattern } | Select-Object -First 1
            if (-not $inner) { throw "Fant ikke mappe som matcher '$innerDirPattern' etter utpakking" }
            if (Test-Path $destDir) { Remove-Item $destDir -Recurse -Force }
            Move-Item $inner.FullName $destDir
        } else {
            # ZIP pakker direkte ut til rot — flytt hele extractTemp til destDir
            if (Test-Path $destDir) { Remove-Item $destDir -Recurse -Force }
            Move-Item $extractTemp $destDir
        }
        Write-Ok "Pakket ut til $destDir"
    } catch {
        Write-Fail "Klarte ikke pakke ut $navn`: $_"
        Write-Host "`n  Gaa til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
        Read-Host "`nTrykk Enter for aa lukke"
        exit 1
    }
}

# ── klargjør mapper ───────────────────────────────────────────────────────────
New-Item -ItemType Directory -Force -Path $ToolsDir, $TempDir | Out-Null

# ── [1/6] Node.js ─────────────────────────────────────────────────────────────
Invoke-Download $NodeUrl "$TempDir\node.zip" "Node.js $NodeVersion"
Expand-AndMove "$TempDir\node.zip" $NodeDir "Node.js" "node-*"

Add-ToUserPath $NodeDir
$npmGlobal = "$env:APPDATA\npm"
New-Item -ItemType Directory -Force -Path $npmGlobal | Out-Null
Add-ToUserPath $npmGlobal

$env:Path = [Environment]::GetEnvironmentVariable("Path", "User") + ";" +
            [Environment]::GetEnvironmentVariable("Path", "Machine")
$env:Path = "$env:Path;$npmGlobal"

Write-Step "Sjekker Node.js..."
try {
    $nodeVer = & "$NodeDir\node.exe" --version
    Write-Ok "Node.js $nodeVer er klar"
} catch {
    Write-Fail "Node.js svarer ikke etter installasjon: $_"
    Write-Host "`n  Gaa til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
    Read-Host "`nTrykk Enter for aa lukke"
    exit 1
}

# ── [2/6] Git ─────────────────────────────────────────────────────────────────
Invoke-Download $GitUrl "$TempDir\git.zip" "Git $GitVersion"
Expand-AndMove "$TempDir\git.zip" $GitDir "Git"

Add-ToUserPath "$GitDir\cmd"
Add-ToUserPath "$GitDir\bin"
$env:Path = "$env:Path;$GitDir\cmd;$GitDir\bin"

Write-Step "Sjekker Git..."
try {
    $gitVer = & "$GitDir\cmd\git.exe" --version
    Write-Ok "$gitVer er klar"
} catch {
    Write-Fail "Git svarer ikke etter installasjon: $_"
    Write-Host "`n  Gaa til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
    Read-Host "`nTrykk Enter for aa lukke"
    exit 1
}

# ── [3/6] GitHub CLI ──────────────────────────────────────────────────────────
Invoke-Download $GhUrl "$TempDir\gh.zip" "GitHub CLI $GhVersion"
Expand-AndMove "$TempDir\gh.zip" $GhDir "GitHub CLI" "gh_*"

Add-ToUserPath "$GhDir\bin"
$env:Path = "$env:Path;$GhDir\bin"

Write-Step "Sjekker GitHub CLI..."
try {
    $ghVer = & "$GhDir\bin\gh.exe" --version | Select-Object -First 1
    Write-Ok "$ghVer er klar"
} catch {
    Write-Fail "GitHub CLI svarer ikke etter installasjon: $_"
    Write-Host "`n  Gaa til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
    Read-Host "`nTrykk Enter for aa lukke"
    exit 1
}

# ── [4/6] Azure CLI ───────────────────────────────────────────────────────────
Invoke-Download $AzCliUrl "$TempDir\azcli.zip" "Azure CLI $AzCliVersion"
Expand-AndMove "$TempDir\azcli.zip" $AzCliDir "Azure CLI"

if (-not (Test-Path "$AzCliDir\bin\az.cmd")) {
    Write-Fail "Fant ikke az.cmd etter utpakking av Azure CLI"
    Write-Host "`n  Gaa til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
    Read-Host "`nTrykk Enter for aa lukke"
    exit 1
}

Add-ToUserPath "$AzCliDir\bin"
$env:Path = "$env:Path;$AzCliDir\bin"

Write-Step "Sjekker Azure CLI..."
try {
    $azVer = & "$AzCliDir\bin\az.cmd" --version 2>&1 | Select-Object -First 1
    Write-Ok "$azVer er klar"
} catch {
    Write-Fail "Azure CLI svarer ikke etter installasjon: $_"
    Write-Host "`n  Gaa til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
    Read-Host "`nTrykk Enter for aa lukke"
    exit 1
}

# ── [5/6] opencode ────────────────────────────────────────────────────────────
Write-Step "Installerer opencode..."
try {
    & "$NodeDir\npm.cmd" install -g opencode-ai
    Write-Ok "opencode er installert"
} catch {
    Write-Fail "Klarte ikke installere opencode: $_"
    Write-Host "`n  Gaa til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
    Read-Host "`nTrykk Enter for aa lukke"
    exit 1
}

# ── [6/6] skills ──────────────────────────────────────────────────────────────
Write-Step "Installerer OpenCode skills..."
try {
    & "$NodeDir\npx.cmd" --yes opencode-setup
    Write-Ok "Skills er installert"
} catch {
    Write-Fail "Klarte ikke installere skills: $_"
    Write-Host "`n  Du kan installere skills manuelt senere ved aa kjøre: npx opencode-setup" -ForegroundColor Yellow
    # Ikke exit — resten fungerer selv om skills feiler
}

# ── rydd opp ──────────────────────────────────────────────────────────────────
Remove-Item $TempDir -Recurse -Force -ErrorAction SilentlyContinue

# ── ferdig ────────────────────────────────────────────────────────────────────
Write-Host "`n================================================" -ForegroundColor Green
Write-Host "  Ferdig! Alt er installert:" -ForegroundColor Green
Write-Host "    - Node.js $NodeVersion" -ForegroundColor Green
Write-Host "    - Git $GitVersion" -ForegroundColor Green
Write-Host "    - GitHub CLI $GhVersion" -ForegroundColor Green
Write-Host "    - Azure CLI $AzCliVersion" -ForegroundColor Green
Write-Host "    - opencode" -ForegroundColor Green
Write-Host "    - OpenCode skills" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host "`n  Nettleseren aapner neste steg automatisk...`n"
Start-Sleep -Seconds 2
Start-Process $ReadmeUrl
Read-Host "Trykk Enter for aa lukke dette vinduet"
