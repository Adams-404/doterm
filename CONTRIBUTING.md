# Contributing to Doterm

Thanks for considering a contribution. Doterm is a small project, so clear, focused changes are especially helpful.

## Ways to contribute

- Add a terminal color theme.
- Report a bug or suggest a feature.
- Improve documentation or installation.
- Test Doterm on a supported Termux setup and report what happened.

If you're unsure about an idea, open an issue first so we can discuss it before you spend time implementing it.

## Adding a theme

1. Create a file in `themes/` with a lowercase, descriptive name and the `.properties` extension, for example `themes/my-theme.properties`.
2. Use the Termux color keys shown below. Values should be six-digit hexadecimal colors prefixed with `#`.
3. Include all 16 palette colors, from `color0` through `color15`, as well as `background`, `foreground`, and `cursor`.
4. Doterm's current theme collection uses a pure-black background (`background=#000000`) for AMOLED displays. Keep foreground text and the cursor easy to read.
5. Update the README's bundled themes list if your theme is added to the project.
6. If the palette is based on an existing theme, mention its origin and follow any applicable license and attribution requirements.

Example theme:

```properties
background=#000000
foreground=#39FF88
cursor=#B8FFD8
color0=#000000
color1=#FF5C70
color2=#39FF88
color3=#D7FF5F
color4=#5AA9FF
color5=#D783FF
color6=#45E6D3
color7=#C9F7DE
color8=#28513D
color9=#FF7185
color10=#65FF9F
color11=#E7FF83
color12=#7AB8FF
color13=#E3A0FF
color14=#6BFFEA
color15=#F0FFF6
```

Theme filenames become the names used with `doterm theme`. For example, `themes/green-ghost.properties` is applied with `doterm theme green-ghost`. Green Ghost is Doterm's default theme for fresh installs; the installer must not overwrite an existing user's theme.

## Working on code

1. Fork the repository and clone your fork.
2. Make a branch for your change, such as `add-new-theme` or `fix-backup-restore`.
3. Keep changes focused and avoid unrelated formatting or refactoring.
4. Test the change in Termux when possible.
5. Commit with a clear message and open a pull request against `main`.

For shell changes, check syntax with `bash -n bin/doterm install.sh`. If you change installation behavior, test the installer carefully and confirm it does not unexpectedly modify existing user settings.

An automated theme validator is tracked in [issue #1](https://github.com/Adams-404/doterm/issues/1). Until it is implemented, double-check that each theme includes every required key and valid hex colors.

## Pull requests

Please describe what changed, why it is useful, and how you tested it. For theme contributions, include the theme name and a screenshot or a short description of the palette if possible.

Be respectful, explain your reasoning, and be open to feedback. Thanks for helping make Doterm better.
