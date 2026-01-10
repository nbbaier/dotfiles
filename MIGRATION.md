# Migration from Old Structure

## Overview

The dotfiles repository was refactored to use GNU Stow for symlink management. This document describes the old structure and how it maps to the new one.

## Old Structure → New Structure

### Configuration Files (XDG)

**Old:** `config/` directory with recursive linking via `bin/link_config`

**New:** Individual Stow packages with `.config/` subdirectories

| Old Location | New Location |
|--------------|--------------|
| `config/zsh/` | `zsh/.config/zsh/` |
| `config/git/` | `git/.config/git/` |
| `config/bat/` | `bat/.config/bat/` |
| `config/gh/` | `gh/.config/gh/` |
| `config/karabiner/` | `karabiner/.config/karabiner/` |
| `config/aerospace/` | `aerospace/.config/aerospace/` |
| `config/fastfetch/` | `fastfetch/.config/fastfetch/` |
| `config/ghostty/` | `ghostty/.config/ghostty/` |
| `config/litecli/` | `litecli/.config/litecli/` |
| `config/micro/` | `micro/.config/micro/` |
| `config/pandoc/` | `pandoc/.config/pandoc/` |
| `config/twtxtr/` | `twtxtr/.config/twtxtr/` |
| `config/topgrade.toml` | `topgrade/.config/topgrade.toml` |
| `config/curlrc` | `curl/.config/curlrc` |

### Home Dotfiles

**Old:** Separate directories with `bin/link_home`

**New:** Stow packages with files in root

| Old Location | New Location |
|--------------|--------------|
| `zshenv/.zshenv` | `zsh/.zshenv` |
| `jq/.jq` | `jq/.jq` (unchanged) |

### System Files

**Old:** `system/` directory with aliases, completions, prompts

**New:** `system/.config/zsh/` with same subdirectories

| Old Location | New Location |
|--------------|--------------|
| `system/aliases` | `system/.config/zsh/aliases` |
| `system/completions/` | `system/.config/zsh/completions/` |
| `system/prompt/` | `system/.config/zsh/prompt/` |
| `system/plugins/` | `system/plugins/` (unchanged, still git submodules) |

**Note:** Plugins remain as git submodules in `system/plugins/` and are NOT stowed.

### Applications

**Old:** `apps/` directory with `bin/link_ides`

**New:** `apps/` directory unchanged (macOS-specific paths not suited for Stow)

Applications like VS Code and Cursor use `~/Library/Application Support/` on macOS, which doesn't follow XDG conventions. These continue to use custom linking via `bin/link_ides`.

## Installation Scripts

**Old:**
- `install.sh` - Monolithic installer

**New:**
- `install.sh` - Thin wrapper calling `bin/dotfiles install`
- `install-deps.sh` - Dependency installation only
- `bin/dotfiles` - Main orchestrator with subcommands

## Linking Scripts

**Old:**
- `bin/link_config` - Custom recursive linker for ~/.config
- `bin/link_home` - Custom linker for home dotfiles
- `bin/link_ides` - Custom linker for IDE configs

**New:**
- `bin/dotfiles link` - Uses GNU Stow for most packages
- `bin/link_ides` - Still used for macOS Application Support paths

## Git Submodules

Git submodules in `system/plugins/` are unchanged:
- fzf-tab
- zsh-autopair
- zsh-autosuggestions
- zsh-completions
- zsh-syntax-highlighting
- zsh-you-should-use

These are loaded by `.zshrc` from `$DOTFILES/system/plugins/` and do not need to be stowed.

## Why This Change?

1. **Standardization**: GNU Stow is a well-established tool with predictable behavior
2. **Modularity**: Each config is now a separate package that can be installed independently
3. **Simplicity**: Less custom linking code to maintain
4. **Idempotency**: Stow handles re-running safely
5. **Community**: Stow-based dotfiles are a common pattern with lots of examples

## Backward Compatibility

The old `config/`, `zshenv/`, and `system/` directories are marked as deprecated and will be removed in a future commit. If you have an existing installation:

1. **Unstow/unlink old configs** (if you used the old installer)
2. **Pull the latest changes**
3. **Run the new installer:** `./install.sh`

The new installer will:
- Install dependencies
- Link dotfiles via GNU Stow
- Set up IDE configs (macOS)
- Apply macOS defaults (macOS)
