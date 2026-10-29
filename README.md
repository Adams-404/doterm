# Doterm

<p align="center">
  <img src="assets/doterm-logo.svg" alt="Doterm Green Ghost logo" width="220" />
</p>

**Make your Termux yours.**

Doterm is a modular command-line toolkit for customizing the Termux environment with terminal fonts, color themes, and configuration backup and restoration.

## Features

- Switch between bundled terminal fonts.
- Preview theme colors in the terminal before applying them.
- Apply original Doterm color themes designed around readable foreground colors and a pure-black AMOLED background.
- Use Green Ghost as the default theme on a fresh install, without overwriting an existing theme.
- Back up supported Termux configuration files before changing fonts or themes.
- Restore settings from the latest backup, including removing supported files that did not exist in the saved state.
- List available fonts and themes with `doterm list`.
- Inspect the active font, theme, installed assets, and version with `doterm status`.
- Update Doterm directly from Termux with `doterm update`.
- Repair a broken or incomplete installation with `doterm repair`.
- Uninstall Doterm without removing personal Termux settings or backups.
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

The installer places the commands in `$PREFIX/bin/` and the bundled fonts, themes, and licenses in `$PREFIX/share/doterm/`. On a fresh setup, it applies Green Ghost as the default theme. If `~/.termux/colors.properties` already exists, the installer preserves it.

## Usage

Show available commands:

```bash
doterm help
```

List available fonts and themes:

```bash
doterm list
```

Check your current setup without changing anything:

```bash
doterm status
```

Status reports the installed Doterm version, identifies the active font when it matches a bundled font, and identifies the active theme when its configuration matches a bundled theme. Custom or unrecognized settings are labelled accordingly. Missing asset directories are reported by `doterm list` with a suggestion to run `doterm repair`.

Check your Doterm installation with read-only diagnostics:

```bash
doterm doctor
```

The doctor checks the Termux environment, installed commands, bundled fonts, required theme colors, and settings reload command. It reports passes, warnings, and failures with basic next steps. It does not modify your configuration.

Repair a missing or broken Doterm installation:

```bash
doterm repair
```

Repair downloads a clean copy of the latest `main` branch and runs the installer again. It restores Doterm commands and bundled assets, while preserving your existing active theme and other Termux settings. It requires Git and an internet connection.

Uninstall Doterm:

```bash
doterm uninstall
```

The command shows what it will remove and asks for confirmation. It removes `$PREFIX/bin/doterm`, `$PREFIX/bin/font`, and `$PREFIX/share/doterm/`. Your `~/.termux/` configuration, active font and theme, and backups are preserved. Answer `n` or press Enter to cancel.

Switch fonts:

```bash
doterm font fira
doterm font jetbrains
```

Open the interactive font selector:

```bash
font
```

Choose a theme interactively:

```bash
doterm theme
```

The picker displays each theme name in its foreground color and marks the active bundled theme when it can be identified. Selecting a theme temporarily applies it to Termux so you can see the full terminal colors, then asks whether to keep it. Answer `y` to save it or `n` to restore the previous configuration. Enter `0` to exit without previewing. In non-interactive shells, `doterm theme` lists available themes instead. You can also select a theme directly by name:

```bash
doterm theme green-ghost
doterm theme ice-cyan
doterm theme afterbyte
doterm theme violet-pulse
doterm theme monochrome-steel
doterm theme solar-flare
doterm theme red-wedding
doterm theme oxide-bloom
doterm theme deep-current
doterm theme paper-moon
```

Print a theme's color palette without applying it:

```bash
doterm preview green-ghost
```

The command displays the theme's background, foreground, cursor, and ANSI color palette as terminal samples. It is read-only and does not create a backup or modify `~/.termux/colors.properties`.

All ten themes use a pure-black (`#000000`) background. The collection includes spectral green, crisp cyan, warm amber, electric violet, cool silver, golden yellow, crimson, copper ember, deep-sea teal, and warm lunar ivory palettes. The theme validator checks required properties, six-digit hex colors, duplicate keys, and the pure-black background rule.

Back up your current supported settings:

```bash
doterm backup
```

Restore the latest backup:

```bash
doterm restore
```

## Updating

Update Doterm directly from Termux:

```bash
doterm update
```

The updater downloads the latest `main` branch into a temporary directory, checks that the required files are present, and runs the installer. `doterm repair` uses the same download-and-validate approach to reinstall the managed files when an installation is incomplete. The temporary download is removed afterward. An update requires Git and an internet connection.

The installer replaces Doterm's bundled commands, fonts, themes, and licenses. It preserves an existing `~/.termux/colors.properties` file, so your current theme is not replaced. If the download or repository checks fail, installation does not begin.

This currently tracks the latest code on `main`, not a versioned stable release. The updater does not yet provide cryptographic release verification. For a fresh installation, follow the instructions above.

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
- Green Ghost: luminous spectral green; default on a fresh install
- Ice Cyan: crisp cyan
- Afterbyte: warm amber
- Violet Pulse: electric violet
- Monochrome Steel: cool silver
- Solar Flare: luminous golden yellow
- Red Wedding: regal crimson
- Oxide Bloom: copper and ember orange
- Deep Current: deep-sea teal
- Paper Moon: warm lunar ivory

The bundled fonts retain their SIL Open Font License notices in `licenses/`.

## Contributing

Contributions are welcome, including new themes, bug fixes, documentation improvements, and feature ideas. Read [CONTRIBUTING.md](CONTRIBUTING.md) for the theme format and contribution workflow. GitHub issue and pull request templates are available to help make reports and proposed changes easier to review.

## Limitations

Doterm currently targets Termux on Android. It manages its bundled fonts and themes and backs up the supported configuration files listed by the tool. It does not manage every Termux setting.

## License

Doterm's own code is licensed under the MIT License. See `LICENSE`.

The bundled fonts are distributed under their respective licenses in `licenses/`.
