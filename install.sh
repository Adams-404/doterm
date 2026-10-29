#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

REPO_URL="https://github.com/Adams-404/doterm.git"
DATA_DIR="${PREFIX:-}/share/doterm"
CONFIG_DIR="$HOME/.termux"
TEMP_DIR=""

cleanup() {
    if [[ -n "${TEMP_DIR:-}" && -d "$TEMP_DIR" ]]; then
        rm -rf -- "$TEMP_DIR"
    fi
}
trap cleanup EXIT

if [[ -z "${PREFIX:-}" || ! -d "$PREFIX/bin" ]] || ! command -v pkg >/dev/null 2>&1; then
    printf 'Error: Doterm must be installed from inside Termux.\n' >&2
    exit 1
fi

SOURCE_DIR=""
SCRIPT_PATH="${BASH_SOURCE[0]:-}"

if [[ -n "$SCRIPT_PATH" && -f "$SCRIPT_PATH" ]]; then
    CANDIDATE_DIR="$(cd -- "$(dirname -- "$SCRIPT_PATH")" && pwd)"
    if [[ -f "$CANDIDATE_DIR/bin/doterm" && -d "$CANDIDATE_DIR/fonts" && -d "$CANDIDATE_DIR/themes" ]]; then
        SOURCE_DIR="$CANDIDATE_DIR"
    fi
fi

if [[ -z "$SOURCE_DIR" && -f "$PWD/bin/doterm" && -d "$PWD/fonts" && -d "$PWD/themes" ]]; then
    SOURCE_DIR="$PWD"
fi

if [[ -z "$SOURCE_DIR" ]]; then
    if ! command -v git >/dev/null 2>&1; then
        printf 'Error: Git is required to download Doterm. Install it with: pkg install git\n' >&2
        exit 1
    fi

    TEMP_DIR="$(mktemp -d)"
    printf 'Downloading Doterm...\n'
    git clone --depth 1 "$REPO_URL" "$TEMP_DIR/doterm" >&2
    SOURCE_DIR="$TEMP_DIR/doterm"
fi

printf 'Installing Doterm...\n'
mkdir -p "$DATA_DIR" "$PREFIX/bin"
for asset in fonts themes licenses; do
    if [[ -d "$SOURCE_DIR/$asset" ]]; then
        rm -rf -- "$DATA_DIR/$asset"
        cp -a -- "$SOURCE_DIR/$asset" "$DATA_DIR/$asset"
    fi
done

install -m 755 "$SOURCE_DIR/bin/doterm" "$PREFIX/bin/doterm"
install -m 755 "$SOURCE_DIR/bin/font" "$PREFIX/bin/font"

# Set Green Ghost as the first-run default without replacing an existing user theme.
if [[ ! -f "$CONFIG_DIR/colors.properties" ]]; then
    mkdir -p "$CONFIG_DIR"
    cp "$DATA_DIR/themes/green-ghost.properties" "$CONFIG_DIR/colors.properties"
    if command -v termux-reload-settings >/dev/null 2>&1; then
        termux-reload-settings
    fi
    printf 'Applied default theme: Green Ghost\n'
fi

printf '\nDoterm installed successfully.\n'
printf 'Run: doterm help\n'
printf 'Try: doterm theme green-ghost\n'
