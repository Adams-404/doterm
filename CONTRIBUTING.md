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
4. Use a consistent, readable foreground/background combination.
5. Update the README's bundled themes list if your theme is added to the project.
6. If the palette is based on an existing theme, mention its name and follow its license and attribution requirements.

Example:

```properties
background=#1e1e2e
foreground=#cdd6f4
cursor=#f5e0dc
color0=#45475a
color1=#f38ba8
color2=#a6e3a1
color3=#f9e2af
color4=#89b4fa
color5=#f5c2e7
color6=#94e2d5
color7=#bac2de
color8=#585b70
color9=#f38ba8
color10=#a6e3a1
color11=#f9e2af
color12=#89b4fa
color13=#f5c2e7
color14=#94e2d5
color15=#a6adc8
```

Theme filenames become the names used with `doterm theme`. For example, `themes/catppuccin-mocha.properties` is applied with `doterm theme catppuccin-mocha`.

## Working on code

1. Fork the repository and clone your fork.
2. Make a branch for your change, such as `add-nord-theme` or `fix-backup-restore`.
3. Keep changes focused and avoid unrelated formatting or refactoring.
4. Test the change in Termux when possible.
5. Commit with a clear message and open a pull request against `main`.

For shell changes, check syntax with `bash -n bin/doterm install.sh`. If you change installation behavior, test the installer carefully and confirm it does not unexpectedly modify existing user settings.

## Pull requests

Please describe what changed, why it is useful, and how you tested it. For theme contributions, include the theme name and a screenshot or a short description of the palette if possible.

Be respectful, explain your reasoning, and be open to feedback. Thanks for helping make Doterm better.
