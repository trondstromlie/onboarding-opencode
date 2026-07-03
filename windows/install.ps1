# ── konfig ────────────────────────────────────────────────────────────────────
$NodeVersion = "24.18.0"
$NodeUrl     = "https://nodejs.org/dist/v$NodeVersion/node-v$NodeVersion-win-x64.zip"
$ToolsDir    = "$env:USERPROFILE\tools"
$NodeDir     = "$ToolsDir\nodejs"
$TempDir     = "$env:TEMP\opencode-install"
$ReadmeUrl   = "https://github.com/gjensidige/opencode-setup#steg-3--installer-skills"

$ErrorActionPreference = "Stop"

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

# ── klargjør mapper ───────────────────────────────────────────────────────────
New-Item -ItemType Directory -Force -Path $ToolsDir, $TempDir | Out-Null

# ── Node.js ───────────────────────────────────────────────────────────────────
Write-Step "Laster ned Node.js $NodeVersion..."
try {
    $nodeZip = "$TempDir\node.zip"
    Invoke-WebRequest -Uri $NodeUrl -OutFile $nodeZip -UseBasicParsing
    Write-Ok "Nedlasting ferdig"
} catch {
    Write-Fail "Klarte ikke laste ned Node.js. Sjekk internettilkoblingen og prøv igjen."
    Write-Host "  Feilmelding: $_" -ForegroundColor DarkRed
    Write-Host "`n  Gaa til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
    Read-Host "`nTrykk Enter for aa lukke"
    exit 1
}

Write-Step "Pakker ut Node.js..."
try {
    Expand-Archive -Path $nodeZip -DestinationPath $TempDir -Force
    $nodeExtracted = Get-ChildItem $TempDir -Directory | Where-Object { $_.Name -like "node-*" } | Select-Object -First 1
    if (-not $nodeExtracted) { throw "Fant ikke node-mappe etter utpakking" }
    if (Test-Path $NodeDir) { Remove-Item $NodeDir -Recurse -Force }
    Move-Item $nodeExtracted.FullName $NodeDir
    Write-Ok "Pakket ut til $NodeDir"
} catch {
    Write-Fail "Klarte ikke pakke ut Node.js: $_"
    Write-Host "`n  Gaa til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
    Read-Host "`nTrykk Enter for aa lukke"
    exit 1
}

# ── PATH ──────────────────────────────────────────────────────────────────────
Write-Step "Oppdaterer PATH..."
Add-ToUserPath $NodeDir

# Oppdater PATH i naavarende sesjon slik at npm er tilgjengelig med en gang
$env:Path = [Environment]::GetEnvironmentVariable("Path", "User") + ";" +
            [Environment]::GetEnvironmentVariable("Path", "Machine")

# npm legger globale pakker i %APPDATA%\npm — legg til denne ogsaa
$npmGlobal = "$env:APPDATA\npm"
New-Item -ItemType Directory -Force -Path $npmGlobal | Out-Null
Add-ToUserPath $npmGlobal
$env:Path = "$env:Path;$npmGlobal"

# ── verifiser node ────────────────────────────────────────────────────────────
Write-Step "Sjekker Node.js..."
try {
    $nodeVer = & "$NodeDir\node.exe" --version
    Write-Ok "Node.js $nodeVer er installert"
} catch {
    Write-Fail "Node.js svarer ikke etter installasjon: $_"
    Write-Host "`n  Gaa til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
    Read-Host "`nTrykk Enter for aa lukke"
    exit 1
}

# ── opencode ──────────────────────────────────────────────────────────────────
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

# ── rydd opp ──────────────────────────────────────────────────────────────────
Remove-Item $TempDir -Recurse -Force -ErrorAction SilentlyContinue

# ── ferdig ────────────────────────────────────────────────────────────────────
Write-Host "`n================================================" -ForegroundColor Green
Write-Host "  Ferdig! Node.js og opencode er installert." -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host "`n  Nettleseren aapner neste steg automatisk...`n"
Start-Sleep -Seconds 2
Start-Process $ReadmeUrl
Read-Host "Trykk Enter for aa lukke dette vinduet"
