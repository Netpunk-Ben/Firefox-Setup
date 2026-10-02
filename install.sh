#!/usr/bin/env bash
# Firefox Setup fuer macOS und Linux. Als normaler Benutzer ausfuehren, sudo wird bei Bedarf abgefragt.
set -euo pipefail

REPO_BASE="${REPO_BASE:-https://raw.githubusercontent.com/Netpunk-Ben/Firefox-Setup/main}"
BETTERFOX="https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"

get_file() {
  if [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/$1" ]]; then cat "$SCRIPT_DIR/$1"
  else curl -fsSL "$REPO_BASE/$1"; fi
}

case "$(uname)" in
  Darwin)
    if [[ ! -d /Applications/Firefox.app ]]; then
      command -v brew >/dev/null || { echo "Homebrew fehlt: https://brew.sh"; exit 1; }
      brew install --cask firefox
    fi
    FF_BIN="/Applications/Firefox.app/Contents/MacOS/firefox"
    POLICY_DIR="/Applications/Firefox.app/Contents/Resources/distribution"
    PROFILE_ROOTS=("$HOME/Library/Application Support/Firefox/Profiles")
    ;;
  Linux)
    FF_BIN="$(command -v firefox || true)"
    [[ -n "$FF_BIN" ]] || { echo "Firefox bitte zuerst ueber den Paketmanager installieren."; exit 1; }
    POLICY_DIR="/etc/firefox/policies"
    PROFILE_ROOTS=("$HOME/.mozilla/firefox" "$HOME/.config/mozilla/firefox")
    ;;
  *) echo "Nicht unterstuetztes System"; exit 1 ;;
esac

# 1. Policies ablegen
sudo mkdir -p "$POLICY_DIR"
get_file policies.json | sudo tee "$POLICY_DIR/policies.json" >/dev/null
echo "policies.json abgelegt in $POLICY_DIR"

# 2. Firefox muss geschlossen sein
if pgrep -x firefox >/dev/null || pgrep -f "Firefox.app" >/dev/null; then
  read -rp "Firefox laeuft noch. Bitte schliessen und Enter druecken "
fi

find_profiles() {
  for root in "${PROFILE_ROOTS[@]}"; do
    [[ -d "$root" ]] && find "$root" -maxdepth 2 -name compatibility.ini -exec dirname {} \;
  done
}

# 3. Profil anlegen, falls noch keins existiert
if [[ -z "$(find_profiles)" ]]; then
  echo "Lege Standardprofil an ..."
  "$FF_BIN" --headless >/dev/null 2>&1 &
  sleep 10
  kill "$!" 2>/dev/null || true
  sleep 2
fi

# 4. user.js bauen und verteilen
USER_JS="$(curl -fsSL "$BETTERFOX")"$'\n\n'"$(get_file user-overrides.js)"
while IFS= read -r prof; do
  [[ -n "$prof" ]] || continue
  printf '%s\n' "$USER_JS" > "$prof/user.js"
  echo "user.js geschrieben: $prof"
done < <(find_profiles)

echo
echo "Fertig. Firefox starten, mit Firefox-Konto anmelden, 1Password verbinden."
