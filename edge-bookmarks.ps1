# Wandelt die Edge-Favoriten in eine Firefox-Lesezeichensicherung (.json) um.
# Die Datei wird in Firefox ueber "Lesezeichen verwalten > Importieren und Sichern >
# Wiederherstellen > Datei waehlen" eingespielt und ersetzt dabei ALLE vorhandenen Lesezeichen.
# Edge-Favoritenleiste  -> Firefox-Lesezeichen-Symbolleiste
# Edge Weitere Favoriten -> Firefox Weitere Lesezeichen
# Edge Mobile Favoriten  -> Firefox Mobile Lesezeichen
param(
    [string]$EdgeProfile = "Default",
    [string]$OutFile = (Join-Path ([Environment]::GetFolderPath('Desktop')) "edge-lesezeichen-fuer-firefox.json")
)
$ErrorActionPreference = 'Stop'

$UserData = Join-Path $env:LOCALAPPDATA "Microsoft\Edge\User Data"
$Src = Join-Path $UserData "$EdgeProfile\Bookmarks"
if (-not (Test-Path $Src)) {
    Write-Host "Keine Edge-Favoriten gefunden unter: $Src"
    Write-Host "Vorhandene Edge-Profile mit Favoriten:"
    Get-ChildItem $UserData -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path (Join-Path $_.FullName "Bookmarks") } |
        ForEach-Object { Write-Host "  $($_.Name)   (Aufruf mit -EdgeProfile '$($_.Name)')" }
    return
}

$raw = [IO.File]::ReadAllText($Src, [Text.Encoding]::UTF8)
$raw = [regex]::Replace($raw, '"sync_metadata"\s*:\s*"[^"]*"\s*,?', '')   # grosser Sync-Blob, wird nicht gebraucht
$Edge = $raw | ConvertFrom-Json

$script:NextId = 1
$script:Count = 0
$script:Rng = New-Object System.Random
$script:Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_'.ToCharArray()
$EpochOffset = [int64]11644473600000000   # Mikrosekunden zwischen 1601 und 1970
$Now = [int64]([DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()) * 1000

function New-MozGuid { -join (1..12 | ForEach-Object { $script:Chars[$script:Rng.Next(64)] }) }

function Convert-Time($Value) {
    $t = [int64]0
    if ([int64]::TryParse([string]$Value, [ref]$t) -and $t -gt $EpochOffset) { return $t - $EpochOffset }
    return $Now
}

function Convert-Node($Node, [int]$Index) {
    $script:NextId++
    $added = Convert-Time $Node.date_added
    if ($Node.type -eq 'url') {
        $script:Count++
        return [ordered]@{
            guid = New-MozGuid; title = [string]$Node.name; index = $Index
            dateAdded = $added; lastModified = $added; id = $script:NextId
            typeCode = 1; type = 'text/x-moz-place'; uri = [string]$Node.url
        }
    }
    $folder = [ordered]@{
        guid = New-MozGuid; title = [string]$Node.name; index = $Index
        dateAdded = $added; lastModified = (Convert-Time $Node.date_modified); id = $script:NextId
        typeCode = 2; type = 'text/x-moz-place-container'
    }
    $folder.children = Convert-Children $Node.children
    return $folder
}

function Convert-Children($Children) {
    $list = New-Object System.Collections.ArrayList
    $i = 0
    foreach ($c in @($Children)) {
        if ($null -eq $c) { continue }
        [void]$list.Add((Convert-Node $c $i))
        $i++
    }
    return ,$list
}

function New-Root([string]$Guid, [string]$Title, [int]$Index, [string]$RootName, $Children) {
    $script:NextId++
    $r = [ordered]@{
        guid = $Guid; title = $Title; index = $Index; dateAdded = $Now; lastModified = $Now
        id = $script:NextId; typeCode = 2; type = 'text/x-moz-place-container'; root = $RootName
    }
    $r.children = $Children
    return $r
}

$Empty = { ,(New-Object System.Collections.ArrayList) }
$Roots = New-Object System.Collections.ArrayList
[void]$Roots.Add((New-Root 'menu________'    'menu'    0 'bookmarksMenuFolder'    (& $Empty)))
[void]$Roots.Add((New-Root 'toolbar_____'    'toolbar' 1 'toolbarFolder'          (Convert-Children $Edge.roots.bookmark_bar.children)))
[void]$Roots.Add((New-Root 'tags________'    'tags'    2 'tagsFolder'             (& $Empty)))
[void]$Roots.Add((New-Root 'unfiled_____'    'unfiled' 3 'unfiledBookmarksFolder' (Convert-Children $Edge.roots.other.children)))
[void]$Roots.Add((New-Root 'mobile______'    'mobile'  4 'mobileFolder'           (Convert-Children $Edge.roots.synced.children)))

$Backup = [ordered]@{
    guid = 'root________'; title = ''; index = 0; dateAdded = $Now; lastModified = $Now
    id = 1; typeCode = 2; type = 'text/x-moz-place-container'; root = 'placesRoot'
}
$Backup.children = $Roots

$Json = ConvertTo-Json $Backup -Depth 100 -Compress
[IO.File]::WriteAllText($OutFile, $Json, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "$($script:Count) Lesezeichen umgewandelt."
Write-Host "Datei: $OutFile"
Write-Host "Diese Datei enthaelt deine Lesezeichen. Nicht ins Repo hochladen und nach dem Import loeschen."
