# Windows development setup

Minimal, reproducible configuration for my Windows 11 development environment. It contains PowerShell, Windows Terminal, VS Code, and a current LazyVim starter configuration. It intentionally does not attempt to reproduce every application on the machine.

## Stack

- PowerShell 7, PSReadLine, PSFzf, fzf, zoxide, Oh My Posh, Terminal-Icons
- JetBrainsMono Nerd Font with Oh My Posh's font installer
- Neovim/LazyVim with Catppuccin Mocha, VTSLS, blink.cmp, Snacks Explorer/Picker, and the TypeScript, JSON, Prettier, and ESLint extras
- VS Code with Prettier, ESLint, React/TypeScript, Remote Development, Catppuccin, Claude Code, and ChatGPT extensions

## Fresh setup

1. Install Windows 11 updates and ensure App Installer/winget is available.
2. Clone this repository.
3. Run `pwsh -ExecutionPolicy Bypass -File .\setup.ps1`.
4. Run with `-Force` only when you intentionally want to replace existing profile/editor files.
5. Restart PowerShell and VS Code. Open Windows Terminal settings and review/apply `windows-terminal/settings.json` manually.

The script installs the selected winget packages, CurrentUser PowerShell modules, and the global `tree-sitter-cli` npm package. It copies the profile, VS Code settings/keybindings, and Neovim configuration. Existing files are skipped unless `-Force` is supplied; the script does not make automatic backups.

## Fonts and extensions

JetBrainsMono Nerd Font was installed with Oh My Posh's font installer. It is documented here rather than forced through winget. Restore VS Code extensions with `code --install-extension <id>` for each line in `vscode/extensions.txt` (or use the Extensions UI). The live machine currently lacks `pascalreitermann93.vscode-yaml-sort`; it remains listed because it is part of the intended setup.

## Neovim

The `nvim/` directory is copied from the live LazyVim starter configuration. `lazy-lock.json` is retained for reproducible plugin revisions. Runtime data, installed plugins, caches, and `.git` metadata are not included. See `nvim/README.md` for a small personal cheat sheet.

## Updating from the live machine

Review changes first, then copy only intentional configuration files from the live locations into this repository. Do not copy VS Code `globalStorage`, `History`, `workspaceStorage`, profiles, Neovim data, plugin directories, or personal exports.

## Intentionally omitted

Personal bookmarks, Mozilla notes, old software lists, Scoop, custom Oh My Posh themes, credentials, machine-specific paths, WSL details, and unrelated applications are intentionally not tracked. Windows Terminal keeps only the useful reproducible settings and excludes the machine-specific `G:\\My Drive\\Koreai` profile.
