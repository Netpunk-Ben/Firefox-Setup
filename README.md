# firefox-setup

Eigenes Firefox-Setup als Code. Basis ist Betterfox, darauf liegen eigene Overrides und Enterprise Policies.

## Inhalt

`policies.json` regelt alles, was Firefox systemweit erzwingen soll: Telemetrie aus, Tracking-Schutz, DNS over HTTPS, HTTPS-only, keine Werbung auf der Startseite, Erweiterungen inklusive uBlock-Filterlisten.

`user-overrides.js` enthaelt die persoenlichen Einstellungen. Das Skript laedt bei jedem Lauf die aktuelle Betterfox user.js und haengt diese Datei hinten an.

`edge-bookmarks.ps1` wandelt die Edge-Favoriten einmalig in eine Firefox-Lesezeichensicherung um (siehe unten).

`install.ps1` (Windows) und `install.sh` (macOS, Linux) installieren Firefox bei Bedarf, legen die Policies ab und schreiben die user.js in alle vorhandenen Profile.

## Neuer Rechner

Windows, Admin-PowerShell:

    irm https://raw.githubusercontent.com/Netpunk-Ben/Firefox-Setup/main/install.ps1 | iex

macOS oder Linux:

    curl -fsSL https://raw.githubusercontent.com/Netpunk-Ben/Firefox-Setup/main/install.sh | bash

Bei einem privaten Repo stattdessen klonen und das Skript lokal starten.

## Pflege

Einstellungen werden nur im Repo geaendert, danach das Skript erneut ausfuehren. Das holt gleichzeitig die neueste Betterfox-Version.

## Lesezeichen aus Edge (einmalig)

In einer normalen PowerShell im Repo-Ordner:

    powershell -ExecutionPolicy Bypass -File .\edge-bookmarks.ps1

Die Datei edge-lesezeichen-fuer-firefox.json landet auf dem Desktop. In Firefox Strg+Umschalt+O, dann Importieren und Sichern, Wiederherstellen, Datei waehlen. Das ersetzt alle vorhandenen Lesezeichen durch die Edge-Struktur. Die Datei danach loeschen und niemals ins Repo hochladen. Weitere Rechner bekommen die Lesezeichen ueber Firefox Sync.
