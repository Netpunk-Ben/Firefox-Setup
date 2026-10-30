# firefox-setup

Eigenes Firefox-Setup als Code. Basis ist Betterfox, darauf liegen eigene Overrides und Enterprise Policies.

## Inhalt

`policies.json` regelt alles, was Firefox systemweit erzwingen soll: Telemetrie aus, Tracking-Schutz, DNS over HTTPS, HTTPS-only, keine Werbung auf der Startseite, Erweiterungen inklusive uBlock-Filterlisten und Tampermonkey fuer AdGuard Extra.

`user-overrides.js` enthaelt die persoenlichen Einstellungen. Das Skript laedt bei jedem Lauf die aktuelle Betterfox user.js und haengt diese Datei hinten an.

`edge-bookmarks.ps1` wandelt die Edge-Favoriten einmalig in eine Firefox-Lesezeichensicherung um (siehe unten).

`install.ps1` (Windows) und `install.sh` (macOS, Linux) installieren Firefox bei Bedarf, legen die Policies ab und schreiben die user.js in alle vorhandenen Profile.

## Edge-Verhalten

Optik und Bedienung sind an Edge angelehnt: Tabs oben ohne Seitenleiste, kompakte Darstellung, Tab-Gruppen, geteilte Ansicht, Vorschaukarten auf Tabs, eigenes dunkles Theme und die Favoritenleiste immer sichtbar. Neue Tabs aus Links landen direkt unter dem aktuellen, Strg+T haengt ans Ende, Strg+Tab geht der Reihe nach durch.

## Twitch ohne Werbung

Wie in Edge laeuft das ueber AdGuard Extra, hier als Userscript in Tampermonkey. Normale Werbung erledigt uBlock Origin, das in Firefox die Rolle der AdGuard-Erweiterung uebernimmt. Tampermonkey wird per Policy installiert, das Skript selbst muss einmal von Hand bestaetigt werden; das Installskript oeffnet die Seite dafuer automatisch:

    https://userscripts.adtidy.org/release/adguard-extra/1.0/adguard-extra.user.js

Keine zweite Twitch-Loesung parallel betreiben (TTV LOL PRO, Purple AdBlock, vaft), die kommen sich gegenseitig in die Quere. Falls AdGuard Extra irgendwann nicht mehr reicht, das Skript in Tampermonkey deaktivieren und stattdessen TTV LOL PRO nehmen.

## Eigenes Theme

netpunk-dark wird per Policy aus theme/netpunk-dark.xpi installiert. Die Datei muss im Repo liegen und von addons.mozilla.org signiert sein (web-ext sign --channel=unlisted), sonst laesst Firefox sie nicht zu und faellt auf das Standardtheme zurueck.

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
