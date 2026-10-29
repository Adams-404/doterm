#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf -- "$TMP"' EXIT

export PREFIX="$TMP/prefix"
export HOME="$TMP/home"
mkdir -p "$PREFIX/bin" "$PREFIX/share/doterm/fonts" "$PREFIX/share/doterm/themes" "$HOME/.termux" "$TMP/stubs"
cp "$ROOT/bin/doterm" "$PREFIX/bin/doterm"
cp "$ROOT/bin/font" "$PREFIX/bin/font"
cp "$ROOT"/fonts/*.ttf "$PREFIX/share/doterm/fonts/"
cp "$ROOT"/themes/*.properties "$PREFIX/share/doterm/themes/"
cp "$ROOT/VERSION" "$PREFIX/share/doterm/VERSION"
printf '#!/usr/bin/env bash\nexit 0\n' > "$TMP/stubs/termux-reload-settings"
chmod +x "$TMP/stubs/termux-reload-settings"
export PATH="$TMP/stubs:$PATH"

pass() { printf 'PASS: %s\n' "$1"; }
fail() { printf 'FAIL: %s\n' "$1" >&2; exit 1; }
assert_contains() {
    local output="$1" expected="$2" label="$3"
    [[ "$output" == *"$expected"* ]] || fail "$label (missing: $expected)"
    pass "$label"
}

# Help and inventories
out="$("$PREFIX/bin/doterm" help)"
assert_contains "$out" "doterm status" "help lists status command"
out="$("$PREFIX/bin/doterm" list)"
assert_contains "$out" "Fira Code (fira)" "list names Fira Code"
assert_contains "$out" "oxide-bloom" "list includes expanded themes"
out="$("$PREFIX/bin/doterm" status)"
assert_contains "$out" "Version: $(cat "$ROOT/VERSION")" "status reports installed version"

# Missing inventories should be handled cleanly.
mv "$PREFIX/share/doterm/fonts" "$TMP/fonts.saved"
out="$("$PREFIX/bin/doterm" list)"
assert_contains "$out" "Font directory missing" "list handles missing font directory"
mv "$TMP/fonts.saved" "$PREFIX/share/doterm/fonts"

# Invalid font/theme names must fail without changing user config.
printf 'original-colors\n' > "$HOME/.termux/colors.properties"
before="$(sha256sum "$HOME/.termux/colors.properties")"
if "$PREFIX/bin/doterm" font not-a-font >/dev/null 2>&1; then fail "invalid font should fail"; fi
if "$PREFIX/bin/doterm" theme not-a-theme >/dev/null 2>&1; then fail "invalid theme should fail"; fi
after="$(sha256sum "$HOME/.termux/colors.properties")"
[[ "$before" == "$after" ]] || fail "invalid names changed existing theme config"
[[ ! -e "$HOME/.termux/font.ttf" ]] || fail "invalid font created font config"
pass "invalid font/theme leave settings unchanged"

# Font changes save a backup and install the selected font.
"$PREFIX/bin/doterm" font fira >/dev/null
cmp -s "$PREFIX/share/doterm/fonts/FiraCode-Regular.ttf" "$HOME/.termux/font.ttf" || fail "Fira Code was not applied"
backup_dir="$(find "$HOME/.termux/backups/doterm" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
[[ -n "$backup_dir" ]] || fail "font change did not create backup"
grep -Fxq colors.properties "$backup_dir/manifest" || fail "backup manifest did not record colors.properties"
pass "font change backs up existing settings"

# Theme apply + keep should back up the prior state and apply selected theme.
printf 'y\n' | "$PREFIX/bin/doterm" theme green-ghost >/dev/null
cmp -s "$PREFIX/share/doterm/themes/green-ghost.properties" "$HOME/.termux/colors.properties" || fail "theme was not applied"
pass "theme applies successfully when confirmed"

# Manifest restore restores files that existed and removes files absent at backup time.
printf 'before-restore\n' > "$HOME/.termux/colors.properties"
"$PREFIX/bin/doterm" backup >/dev/null
manifest_backup="$(find "$HOME/.termux/backups/doterm" -mindepth 1 -maxdepth 1 -type d | sort | tail -n 1)"
rm -f "$HOME/.termux/colors.properties" "$HOME/.termux/font.ttf"
"$PREFIX/bin/doterm" restore >/dev/null
[[ -f "$HOME/.termux/colors.properties" ]] || fail "restore did not restore manifest-listed colors"
[[ ! -e "$HOME/.termux/font.ttf" ]] || fail "restore did not remove font absent from manifest"
grep -Fxq colors.properties "$manifest_backup/manifest" || fail "backup manifest missing colors entry"
pass "manifest restore restores and removes expected files"

# Legacy backups restore files that are present without requiring a manifest.
legacy="$HOME/.termux/backups/doterm/19990101-000000"
mkdir -p "$legacy"
printf 'legacy-theme\n' > "$legacy/colors.properties"
"$PREFIX/bin/doterm" restore >/dev/null
grep -Fxq "legacy-theme" "$HOME/.termux/colors.properties" || fail "legacy backup was not restored"
pass "legacy backup restore remains supported"

printf '\nAll Doterm shell tests passed.\n'
