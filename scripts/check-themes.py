#!/usr/bin/env python3
"""Validate Doterm .properties terminal themes using only the Python standard library."""

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
THEMES_DIR = ROOT / "themes"
REQUIRED_KEYS = ("background", "foreground", "cursor") + tuple(
    f"color{i}" for i in range(16)
)
HEX_COLOR = re.compile(r"^#[0-9A-Fa-f]{6}$")


def validate_theme(path: Path) -> list[str]:
    errors: list[str] = []
    values: dict[str, str] = {}

    try:
        lines = path.read_text(encoding="utf-8").splitlines()
    except OSError as exc:
        return [f"{path.relative_to(ROOT)}: could not read file: {exc}"]

    for line_number, raw_line in enumerate(lines, start=1):
        line = raw_line.strip()
        if not line or line.startswith(("#", "!")):
            continue
        if "=" not in line:
            errors.append(
                f"{path.relative_to(ROOT)}:{line_number}: expected KEY=#RRGGBB, got {raw_line!r}"
            )
            continue

        key, value = (part.strip() for part in line.split("=", 1))
        if key in values:
            errors.append(
                f"{path.relative_to(ROOT)}:{line_number}: duplicate key '{key}'"
            )
            continue
        values[key] = value

        if key in REQUIRED_KEYS and not HEX_COLOR.fullmatch(value):
            errors.append(
                f"{path.relative_to(ROOT)}:{line_number}: invalid color for '{key}': "
                f"{value!r} (expected # followed by 6 hexadecimal digits)"
            )

    for key in REQUIRED_KEYS:
        if key not in values:
            errors.append(f"{path.relative_to(ROOT)}: missing required key '{key}'")

    return errors


def main() -> int:
    if not THEMES_DIR.is_dir():
        print("ERROR: themes/ directory not found.", file=sys.stderr)
        return 1

    theme_files = sorted(THEMES_DIR.glob("*.properties"))
    if not theme_files:
        print("ERROR: no themes/*.properties files found.", file=sys.stderr)
        return 1

    errors: list[str] = []
    for theme_file in theme_files:
        errors.extend(validate_theme(theme_file))

    if errors:
        print("Theme validation failed:")
        for error in errors:
            print(f"  - {error}")
        return 1

    print(f"Theme validation passed: {len(theme_files)} theme(s) checked.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
