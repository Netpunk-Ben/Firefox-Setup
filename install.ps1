#Requires -RunAsAdministrator
# Firefox Setup fuer Windows. In einer Admin-PowerShell unter dem eigenen Konto ausfuehren.
param(
    [string]$RepoBase = "https://raw.githubusercontent.com/Netpunk-Ben/Firefox-Setup/main"
)
$ErrorActionPreference = 'Stop'
$Betterfox = "https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js"
$Utf8 = New-Object System.Text.UTF8Encoding($false)   # ohne BOM, sonst parst Firefox die JSON nicht

function Get-SetupFile([string]$Name) {
    if ($PSScriptRoot) {
        $local = Join-Path $PSScriptRoot $Name
        if (Test-Path $local) { return [IO.File]::ReadAllText($local) }
    }
    return (Invoke-WebRequest "$RepoBase/$Name" -UseBasicParsing).Content
}

# 1. Firefox installieren
$FfDir = Join-Path $env:ProgramFiles "Mozilla Firefox"
if (-not (Test-Path "$FfDir\firefox.exe")) {
    Write-Host "Installiere Firefox ueber winget ..."
    winget install --id Mozilla.Firefox.de -e --scope machine --accept-package-agreements --accept-source-agreements
}

# 2. Policies ablegen
$DistDir = Join-Path $FfDir "distribution"
New-Item $DistDir -ItemType Directory -Force | Out-Null
[IO.File]::WriteAllText((Join-Path $DistDir "policies.json"), (Get-SetupFile "policies.json"), $Utf8)
Write-Host "policies.json abgelegt."

# 3. Firefox muss fuer den Rest geschlossen sein
if (Get-Process firefox -ErrorAction SilentlyContinue) {
    Read-Host "Firefox laeuft noch. Bitte schliessen und Enter druecken"
}

# 4. Profil anlegen, falls noch keins existiert
$ProfRoot = Join-Path $env:APPDATA "Mozilla\Firefox\Profiles"
function Get-Profiles {
    if (-not (Test-Path $ProfRoot)) { return @() }
    Get-ChildItem $ProfRoot -Directory | Where-Object { Test-Path (Join-Path $_.FullName "compatibility.ini") }
}
if (-not (Get-Profiles)) {
    Write-Host "Lege Standardprofil an ..."
    Start-Process "$FfDir\firefox.exe" -ArgumentList "-headless" | Out-Null
    Start-Sleep -Seconds 10
    Get-Process firefox -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
}

# 5. user.js aus Betterfox und eigenen Overrides bauen und in alle Profile schreiben
$UserJs = (Invoke-WebRequest $Betterfox -UseBasicParsing).Content + "`n`n" + (Get-SetupFile "user-overrides.js")
foreach ($p in Get-Profiles) {
    [IO.File]::WriteAllText((Join-Path $p.FullName "user.js"), $UserJs, $Utf8)
    Write-Host "user.js geschrieben: $($p.Name)"
}

Write-Host "`nFertig. Firefox starten, mit Firefox-Konto anmelden, 1Password verbinden."
