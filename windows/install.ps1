# ── logo ──────────────────────────────────────────────────────────────────────
Clear-Host
Write-Host ""
Write-Host "                              .###############-                              " -ForegroundColor White
Write-Host "                         +##########################-                        " -ForegroundColor White
Write-Host "                     +#  +##############################                     " -ForegroundColor White
Write-Host "                  .####  -################################-                  " -ForegroundColor White
Write-Host "                #######  .###################################                " -ForegroundColor White
Write-Host "              +########   ############+      -#################              " -ForegroundColor White
Write-Host "             ##########   ############        ##################.            " -ForegroundColor White
Write-Host "           +###########   ############        ####################           " -ForegroundColor White
Write-Host "          #############   ###########         +####################          " -ForegroundColor White
Write-Host "         ##############.  ##########-         +#####################         " -ForegroundColor White
Write-Host "        +##############.  #######               -####################        " -ForegroundColor White
Write-Host "        ###############    -###                   ####################       " -ForegroundColor White
Write-Host "       ###############+     ++                     ###################       " -ForegroundColor White
Write-Host "      +###############+                             ###################      " -ForegroundColor White
Write-Host "      #################           +                 ###################      " -ForegroundColor White
Write-Host "      ##################        -##                  ##################.     " -ForegroundColor White
Write-Host "      ##################   ##+#####                   #################-     " -ForegroundColor White
Write-Host "      ##################   ######+              .      ################-     " -ForegroundColor White
Write-Host "      ##################   ######                      ################.     " -ForegroundColor White
Write-Host "      ##################.  ######                #+    ################      " -ForegroundColor White
Write-Host "      ##################+  -####                 -#     ###############      " -ForegroundColor White
Write-Host "       ##################   ####                  #-   +##############       " -ForegroundColor White
Write-Host "       .#################   ####                        +#############       " -ForegroundColor White
Write-Host "        +################   ###-                    #    ############        " -ForegroundColor White
Write-Host "         ################   ###                   -   #  ###########         " -ForegroundColor White
Write-Host "          ###############   ###                       -  ##########          " -ForegroundColor White
Write-Host "           ##############   ###                          #########           " -ForegroundColor White
Write-Host "             ############+  +##                    -############-            " -ForegroundColor White
Write-Host "              ############  .#####-             .+#############              " -ForegroundColor White
Write-Host "                ##########   ######            ##############                " -ForegroundColor White
Write-Host "                  -#######   ######+          #############                  " -ForegroundColor White
Write-Host "                     #####   #######        ############                     " -ForegroundColor White
Write-Host "                        -#   #######        #########                        " -ForegroundColor White
Write-Host "                              +#####         ++                              " -ForegroundColor White
Write-Host ""
Write-Host "  Legger inn nodvendige pakker for OpenCode..." -ForegroundColor White
Write-Host "  -------------------------------------------------------" -ForegroundColor DarkGray
Write-Host ""
Start-Sleep -Seconds 1

# ── konfig ────────────────────────────────────────────────────────────────────
$NodeVersion  = "24.18.0"
$GhVersion    = "2.96.0"
$AzCliVersion = "2.87.0"
$GitVersion   = "2.55.0.2"

$NodeUrl  = "https://nodejs.org/dist/v$NodeVersion/node-v$NodeVersion-win-x64.zip"
$GhUrl    = "https://github.com/cli/cli/releases/download/v$GhVersion/gh_${GhVersion}_windows_amd64.zip"
$AzCliUrl = "https://azcliprod.blob.core.windows.net/zip/azure-cli-${AzCliVersion}-x64.zip"
$GitUrl   = "https://github.com/git-for-windows/git/releases/download/v2.55.0.windows.2/MinGit-${GitVersion}-64-bit.zip"

$ToolsDir  = "$env:USERPROFILE\tools"
$NodeDir   = "$ToolsDir\nodejs"
$GhDir     = "$ToolsDir\gh"
$AzCliDir  = "$ToolsDir\azcli"
$GitDir    = "$ToolsDir\git"
$TempDir   = "$env:TEMP\opencode-install"
$ReadmeUrl = "https://github.com/trondstromlie/onboarding-opencode#steg-3--installer-skills"

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# ── hjelpefunksjoner ──────────────────────────────────────────────────────────
function Write-Step($msg) {
    Write-Host ""
    Write-Host "  --> $msg" -ForegroundColor Cyan
}

function Write-Ok($msg) {
    Write-Host "      Ferdig: $msg" -ForegroundColor Green
}

function Write-Fail($msg) {
    Write-Host ""
    Write-Host "  FEIL: $msg" -ForegroundColor Red
}

function Add-ToUserPath($newPath) {
    $current = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($current -notlike "*$newPath*") {
        [Environment]::SetEnvironmentVariable("Path", "$current;$newPath", "User")
    }
}

function Invoke-Download($url, $outFile, $navn) {
    Write-Step "Laster ned $navn..."
    try {
        # Hent filstorrelse
        $totalMB = 0
        try {
            $head = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing
            $bytes = [int]$head.Headers["Content-Length"]
            $totalMB = [math]::Round($bytes / 1MB, 0)
        } catch {}

        if ($totalMB -gt 0) {
            Write-Host "      Storrelse: ca. $totalMB MB" -ForegroundColor DarkGray
        }
        Write-Host "      Laster ned" -ForegroundColor DarkGray -NoNewline

        # Last ned i bakgrunnen og vis punkter underveis
        $job = Start-Job -ScriptBlock {
            param($u, $o)
            $ProgressPreference = "SilentlyContinue"
            Invoke-WebRequest -Uri $u -OutFile $o -UseBasicParsing
        } -ArgumentList $url, $outFile

        while ($job.State -eq "Running") {
            Write-Host "." -NoNewline -ForegroundColor DarkGray
            Start-Sleep -Seconds 1

            # Vis hvor mye er lastet ned
            if ((Test-Path $outFile) -and $totalMB -gt 0) {
                $downloadedMB = [math]::Round((Get-Item $outFile).Length / 1MB, 0)
                Write-Host " $downloadedMB/$totalMB MB" -NoNewline -ForegroundColor DarkGray
            }
        }

        Receive-Job $job -ErrorAction Stop | Out-Null
        Remove-Job $job

        Write-Host "" # ny linje etter punktene
        Write-Ok "Nedlasting fullfort"
    } catch {
        Write-Host ""
        Write-Fail "Klarte ikke laste ned $navn. Sjekk internettilkoblingen og prov igjen."
        Write-Host "  Feilmelding: $_" -ForegroundColor DarkRed
        Write-Host ""
        Write-Host "  Ga til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
        Read-Host "  Trykk Enter for a lukke"
        exit 1
    }
}

function Expand-AndMove($zipPath, $destDir, $navn, $innerDirPattern = $null) {
    Write-Step "Installerer $navn..."
    try {
        $extractTemp = "$TempDir\extract-$navn"
        Expand-Archive -Path $zipPath -DestinationPath $extractTemp -Force

        if ($innerDirPattern) {
            $inner = Get-ChildItem $extractTemp -Directory | Where-Object { $_.Name -like $innerDirPattern } | Select-Object -First 1
            if (-not $inner) { throw "Fant ikke mappe som matcher '$innerDirPattern' etter utpakking" }
            if (Test-Path $destDir) { Remove-Item $destDir -Recurse -Force }
            Move-Item $inner.FullName $destDir
        } else {
            if (Test-Path $destDir) { Remove-Item $destDir -Recurse -Force }
            Move-Item $extractTemp $destDir
        }
        Write-Ok "$navn er installert"
    } catch {
        Write-Fail "Klarte ikke installere $navn`: $_"
        Write-Host ""
        Write-Host "  Ga til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
        Read-Host "  Trykk Enter for a lukke"
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

try {
    $nodeVer = & "$NodeDir\node.exe" --version
    Write-Ok "Node.js $nodeVer er klar"
} catch {
    Write-Fail "Node.js svarer ikke etter installasjon: $_"
    Write-Host "  Ga til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
    Read-Host "  Trykk Enter for a lukke"
    exit 1
}

# ── [2/6] Git ─────────────────────────────────────────────────────────────────
Invoke-Download $GitUrl "$TempDir\git.zip" "Git $GitVersion"
Expand-AndMove "$TempDir\git.zip" $GitDir "Git"

Add-ToUserPath "$GitDir\cmd"
Add-ToUserPath "$GitDir\bin"
$env:Path = "$env:Path;$GitDir\cmd;$GitDir\bin"

try {
    $gitVer = & "$GitDir\cmd\git.exe" --version
    Write-Ok "$gitVer er klar"
} catch {
    Write-Fail "Git svarer ikke etter installasjon: $_"
    Write-Host "  Ga til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
    Read-Host "  Trykk Enter for a lukke"
    exit 1
}

# ── [3/6] GitHub CLI ──────────────────────────────────────────────────────────
Invoke-Download $GhUrl "$TempDir\gh.zip" "GitHub CLI $GhVersion"
Expand-AndMove "$TempDir\gh.zip" $GhDir "GitHub CLI"

Add-ToUserPath "$GhDir\bin"
$env:Path = "$env:Path;$GhDir\bin"

try {
    $ghVer = & "$GhDir\bin\gh.exe" --version | Select-Object -First 1
    Write-Ok "$ghVer er klar"
} catch {
    Write-Fail "GitHub CLI svarer ikke etter installasjon: $_"
    Write-Host "  Ga til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
    Read-Host "  Trykk Enter for a lukke"
    exit 1
}

# ── [4/6] Azure CLI ───────────────────────────────────────────────────────────
Invoke-Download $AzCliUrl "$TempDir\azcli.zip" "Azure CLI $AzCliVersion"
Expand-AndMove "$TempDir\azcli.zip" $AzCliDir "Azure CLI"

if (-not (Test-Path "$AzCliDir\bin\az.cmd")) {
    Write-Fail "Fant ikke az.cmd etter utpakking av Azure CLI"
    Write-Host "  Ga til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
    Read-Host "  Trykk Enter for a lukke"
    exit 1
}

Add-ToUserPath "$AzCliDir\bin"
$env:Path = "$env:Path;$AzCliDir\bin"

try {
    $azVer = & "$AzCliDir\bin\az.cmd" --version 2>&1 | Select-Object -First 1
    Write-Ok "$azVer er klar"
} catch {
    Write-Fail "Azure CLI svarer ikke etter installasjon: $_"
    Write-Host "  Ga til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
    Read-Host "  Trykk Enter for a lukke"
    exit 1
}

# ── [5/6] opencode ────────────────────────────────────────────────────────────
Write-Step "Installerer OpenCode..."
try {
    & "$NodeDir\npm.cmd" install -g opencode-ai
    Write-Ok "OpenCode er installert"
} catch {
    Write-Fail "Klarte ikke installere OpenCode: $_"
    Write-Host "  Ga til manuell installasjon: $ReadmeUrl" -ForegroundColor Yellow
    Read-Host "  Trykk Enter for a lukke"
    exit 1
}

# ── [6/6] skills ──────────────────────────────────────────────────────────────
Write-Step "Installerer OpenCode skills..."
try {
    & "$NodeDir\npx.cmd" --yes opencode-setup
    Write-Ok "Skills er installert"
} catch {
    Write-Host ""
    Write-Host "  NB: Klarte ikke installere skills automatisk." -ForegroundColor Yellow
    Write-Host "      Du kan installere dem manuelt senere ved a kjore: npx opencode-setup" -ForegroundColor Yellow
}

# ── rydd opp ──────────────────────────────────────────────────────────────────
Remove-Item $TempDir -Recurse -Force -ErrorAction SilentlyContinue

# ── ferdig ────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  -------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "  Alt er klart! Installerte verktoy:" -ForegroundColor Green
Write-Host "    - Node.js $NodeVersion" -ForegroundColor Green
Write-Host "    - Git $GitVersion" -ForegroundColor Green
Write-Host "    - GitHub CLI $GhVersion" -ForegroundColor Green
Write-Host "    - Azure CLI $AzCliVersion" -ForegroundColor Green
Write-Host "    - OpenCode" -ForegroundColor Green
Write-Host "    - OpenCode skills" -ForegroundColor Green
Write-Host "  -------------------------------------------------------" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Nettleseren apner neste steg automatisk..." -ForegroundColor White
Write-Host ""
Start-Sleep -Seconds 2
Start-Process $ReadmeUrl
Read-Host "  Trykk Enter for a lukke dette vinduet"
