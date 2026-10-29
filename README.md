# Doterm

**Make your Termux yours.**

Doterm is a modular command-line toolkit for customizing the Termux environment with terminal fonts, color themes, and configuration backup and restoration.

## Features

- Switch between bundled terminal fonts.
- Apply original Doterm color themes designed around readable foreground colors and a pure-black AMOLED background.
- Back up supported Termux configuration files before changing fonts or themes.
- Restore settings from the latest backup, including removing supported files that did not exist in the saved state.
- List available fonts and themes.
- Keep the bundled fonts' license notices alongside the assets.

## Installation

Doterm is designed for Termux on Android. Make sure Git and curl are available:

```bash
pkg install git curl
```

Install the latest version with:

```bash
curl -fsSL https://raw.githubusercontent.com/Adams-404/doterm/main/install.sh | bash
```

Alternatively, clone the repository and run the installer locally:

```bash
git clone https://github.com/Adams-404/doterm.git
cd doterm
bash install.sh
```

The installer places the commands in `$PREFIX/bin/` and the bundled fonts, themes, and licenses in `$PREFIX/share/doterm/`. It does not change your current terminal font or theme during installation.

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

Apply a theme by its name:

```bash
doterm theme ghostroot
doterm theme ice-cyan
doterm theme afterbyte
doterm theme violet-pulse
doterm theme monochrome-steel
doterm theme solar-flare
doterm theme red-wedding
```

All seven themes use a pure-black (`#000000`) background. Each has its own foreground, cursor, and ANSI color palette.

Back up your current supported settings:

```bash
doterm backup
```

Restore the latest backup:

```bash
doterm restore
```

## Updating

If you installed Doterm by cloning the repository, update it with:

```bash
cd doterm
git pull
bash install.sh
```

To reinstall the latest version without keeping a clone, run the one-line installation command again.

## Backups

Doterm stores backups under:

```text
~/.termux/backups/doterm/
```

Each new backup includes a manifest recording which supported configuration files existed when the backup was made. Restore uses that manifest to restore saved files and remove supported configuration files that were absent from the backup. Older backups without a manifest are restored in compatibility mode.

## Bundled assets

Fonts:
- Fira Code Regular
- JetBrains Mono NL Regular

Original Doterm themes:
- Ghostroot: vivid green
- Ice Cyan: crisp cyan
- Afterbyte: warm amber
- Violet Pulse: electric violet
- Monochrome Steel: cool silver
- Solar Flare: luminous golden yellow
- Red Wedding: regal crimson, inspired by the dramatic red-and-black aesthetic of *Game of Thrones*

The bundled fonts retain their SIL Open Font License notices in `licenses/`.

## Contributing

Contributions are welcome, including new themes, bug fixes, documentation improvements, and feature ideas. Read [CONTRIBUTING.md](CONTRIBUTING.md) for the theme format and contribution workflow. GitHub issue and pull request templates are available to help make reports and proposed changes easier to review.

## Limitations

Doterm currently targets Termux on Android. It manages its bundled fonts and themes and backs up the supported configuration files listed by the tool. It does not manage every Termux setting.

## License

Doterm's own code is licensed under the MIT License. See `LICENSE`.

The bundled fonts are distributed under their respective licenses in `licenses/`.
