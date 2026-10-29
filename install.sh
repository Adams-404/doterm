#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

REPO_URL="https://github.com/Adams-404/doterm.git"
DATA_DIR="${PREFIX:-}/share/doterm"
CONFIG_DIR="$HOME/.termux"
TEMP_DIR=""
STAGE_DIR=""
BACKUP_DIR=""
COMMIT_STARTED=0

cleanup() {
    local status=$?
    if [[ $status -ne 0 && $COMMIT_STARTED -eq 1 && -n "$BACKUP_DIR" && -d "$BACKUP_DIR" ]]; then
        printf 'Installation failed during replacement; attempting to restore the previous Doterm files...\n' >&2
        for item in doterm font fonts themes licenses VERSION; do
            rm -rf -- "$DATA_DIR/$item" "$PREFIX/bin/$item" 2>/dev/null || true
            if [[ -e "$BACKUP_DIR/$item" ]]; then
                if [[ "$item" == "doterm" || "$item" == "font" ]]; then
                    cp -a -- "$BACKUP_DIR/$item" "$PREFIX/bin/$item" 2>/dev/null || true
                else
                    cp -a -- "$BACKUP_DIR/$item" "$DATA_DIR/$item" 2>/dev/null || true
                fi
            fi
        done
    fi
    [[ -z "$TEMP_DIR" || ! -d "$TEMP_DIR" ]] || rm -rf -- "$TEMP_DIR"
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
    if [[ -f "$CANDIDATE_DIR/bin/doterm" && -f "$CANDIDATE_DIR/bin/font" && -d "$CANDIDATE_DIR/fonts" && -d "$CANDIDATE_DIR/themes" && -d "$CANDIDATE_DIR/licenses" ]]; then
        SOURCE_DIR="$CANDIDATE_DIR"
    fi
fi

if [[ -z "$SOURCE_DIR" && -f "$PWD/bin/doterm" && -f "$PWD/bin/font" && -d "$PWD/fonts" && -d "$PWD/themes" && -d "$PWD/licenses" ]]; then
    SOURCE_DIR="$PWD"
fi

if [[ -z "$SOURCE_DIR" ]]; then
    if ! command -v git >/dev/null 2>&1; then
        printf 'Error: Git is required to download Doterm. Install it with: pkg install git\n' >&2
        exit 1
    fi

    TEMP_DIR="$(mktemp -d)"
    printf 'Downloading Doterm...\n'
    if ! git clone --depth 1 "$REPO_URL" "$TEMP_DIR/doterm" >&2; then
        printf 'Error: Could not download Doterm. Check your connection and try again.\n' >&2
        exit 1
    fi
    SOURCE_DIR="$TEMP_DIR/doterm"
fi

# Validate the complete source before touching the current installation.
for required in bin/doterm bin/font fonts themes licenses; do
    if [[ ! -e "$SOURCE_DIR/$required" ]]; then
        printf 'Error: Downloaded Doterm is incomplete; missing %s. Nothing was installed.\n' "$required" >&2
        exit 1
    fi
done
if [[ ! -f "$SOURCE_DIR/themes/green-ghost.properties" ]]; then
    printf 'Error: Required default theme is missing. Nothing was installed.\n' >&2
    exit 1
fi

TEMP_DIR="${TEMP_DIR:-$(mktemp -d)}"
STAGE_DIR="$TEMP_DIR/stage"
BACKUP_DIR="$TEMP_DIR/previous"
mkdir -p "$STAGE_DIR/data" "$STAGE_DIR/bin" "$BACKUP_DIR"
cp -a -- "$SOURCE_DIR/fonts" "$STAGE_DIR/data/fonts"
cp -a -- "$SOURCE_DIR/themes" "$STAGE_DIR/data/themes"
cp -a -- "$SOURCE_DIR/licenses" "$STAGE_DIR/data/licenses"
install -m 755 "$SOURCE_DIR/bin/doterm" "$STAGE_DIR/bin/doterm"
install -m 755 "$SOURCE_DIR/bin/font" "$STAGE_DIR/bin/font"
if [[ -f "$SOURCE_DIR/VERSION" ]]; then
    install -m 644 "$SOURCE_DIR/VERSION" "$STAGE_DIR/data/VERSION"
fi

mkdir -p "$DATA_DIR" "$PREFIX/bin"
# Save the managed files so an interrupted replacement can be rolled back.
for item in doterm font; do
    [[ ! -e "$PREFIX/bin/$item" ]] || cp -a -- "$PREFIX/bin/$item" "$BACKUP_DIR/$item"
done
for item in fonts themes licenses VERSION; do
    [[ ! -e "$DATA_DIR/$item" ]] || cp -a -- "$DATA_DIR/$item" "$BACKUP_DIR/$item"
done

printf 'Installing Doterm...\n'
COMMIT_STARTED=1
for item in fonts themes licenses VERSION; do
    rm -rf -- "$DATA_DIR/$item"
    if [[ -e "$STAGE_DIR/data/$item" ]]; then
        mv -- "$STAGE_DIR/data/$item" "$DATA_DIR/$item"
    fi
done
for item in doterm font; do
    install -m 755 "$STAGE_DIR/bin/$item" "$PREFIX/bin/$item"
done
COMMIT_STARTED=0

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
