# Doterm

**Make your Termux yours.**

Doterm is a lightweight command-line tool for personalizing Termux with custom fonts, color themes, and configuration backups.

## Features

- Switch between bundled fonts.
- Apply color themes.
- Back up your current Termux settings.
- Restore settings from a backup.
- List available fonts and themes.
- Keep font licenses alongside the bundled fonts.

## Installation

Clone the repository:

```bash
git clone git@github.com:Adams-404/doterm.git
cd doterm
```

Install Doterm and its bundled assets:

```bash
mkdir -p "$PREFIX/share/doterm"
cp -r fonts themes "$PREFIX/share/doterm/"
install -Dm755 bin/doterm "$PREFIX/bin/doterm"
install -Dm755 bin/font "$PREFIX/bin/font"
```

These commands assume you are running Termux and have cloned the repository.

## Usage

Show available commands:

```bash
doterm help
```

List available fonts and themes:

```bash
doterm list
```

Switch fonts:

```bash
doterm font fira
doterm font jetbrains
```

Open the interactive font selector:

```bash
font
```

Apply a theme:

```bash
doterm theme green
```

Back up your current settings:

```bash
doterm backup
```

Restore the latest backup:

```bash
doterm restore
```

## Backups

Doterm stores backups under:

```text
~/.termux/backups/doterm/
```

Each new backup includes a manifest recording which supported configuration files existed when the backup was made. Restore uses that manifest to restore the saved files and remove supported configuration files that were absent from the backup.

Older backups without a manifest are restored in compatibility mode.

## Bundled assets

- Fira Code Regular
- JetBrains Mono NL Regular
- Green color theme

The bundled fonts retain their original SIL Open Font License notices in `licenses/`.

## Limitations

Doterm currently targets Termux on Android. The bundled fonts and themes are copied into Termux's configuration directories. Existing settings are backed up before font and theme changes.

## Contributing

Issues, suggestions, and pull requests are welcome.

## License

Doterm's own code is licensed under the MIT License. See `LICENSE`.

The bundled fonts are distributed under their respective licenses in `licenses/`.
