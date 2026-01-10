# Dotfiles with GNU Stow (Flat Layout)

Stow symlinks directory contents to a target. The simplest approach: keep your dotfiles exactly as they appear in `~`, then stow the entire repo with one command.

## Directory Structure

```
~/.dotfiles/
├── .config/
│   ├── ghostty/
│   │   └── config
│   ├── nvim/
│   │   └── init.lua
│   └── starship.toml
├── .gitconfig
├── .gitignore_global
├── .zshrc
├── .zshenv
├── .tmux.conf
├── .vimrc
│
├── Brewfile              # stow ignores by default
├── install.sh            # stow ignores by default
├── README.md             # stow ignores by default
└── macos/                # add to .stow-local-ignore
    └── defaults.sh
```

**Key insight**: The repo mirrors your home directory exactly. Files already have their `.` prefix. The `.config/` folder structure matches what goes in `~/.config/`.

## One Command to Link Everything

```bash
stow --dir="$HOME/.dotfiles" --target="$HOME" .
```

That's it. The `.` means "stow this entire directory as one package."

Stow automatically ignores common files like `README.*`, `LICENSE`, `Makefile`, and `install.sh`. For other files you want in the repo but not symlinked (like your `macos/` folder), add them to `.stow-local-ignore`:

```
# .stow-local-ignore
macos
Brewfile
packages
```

## Simplified install.sh

```zsh
#!/usr/bin/env zsh
set -eu

DOTFILES="$HOME/.dotfiles"

info() { printf "\033[32m[✓]\033[0m %s\n" "$1"; }

# Install homebrew if missing
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install packages (including stow)
info "Installing packages from Brewfile"
brew bundle --file="$DOTFILES/Brewfile"

# Link all dotfiles with one command
info "Linking dotfiles"
stow --dir="$DOTFILES" --target="$HOME" .

# macOS defaults
if [[ "$(uname)" == "Darwin" ]]; then
    info "Applying macOS defaults"
    source "$DOTFILES/macos/defaults.sh"
fi

info "Done! Some changes may require a restart."
```

~30 lines vs your current ~150.

## Consolidated Brewfile

Keep it in the repo root. Homebrew can manage everything:

```ruby
# Brewfile

tap "homebrew/bundle"

# Core tools
brew "git"
brew "git-extras"
brew "stow"
brew "node"
brew "bun"
brew "uv"
brew "deno"
brew "go"

# CLI tools
brew "ripgrep"
brew "fd"
brew "bat"
brew "eza"
brew "zoxide"
brew "fzf"
brew "jq"
brew "gh"
brew "starship"
brew "delta"

# Casks
cask "ghostty"
cask "raycast"
cask "1password"
cask "visual-studio-code"
cask "cursor"
cask "arc"
cask "espanso"

# Mac App Store
brew "mas"
mas "Things 3", id: 904280696
```

## Migration from Your Current Setup

```bash
# 1. Flatten your structure
cd ~/.dotfiles

# Move dotfiles to root (adjust paths to match your setup)
mv zshenv/.zshenv .
mv zsh/.zshrc .
mv git/.gitconfig .

# Move .config contents
mkdir -p .config
mv nvim/.config/nvim .config/
mv starship/.config/starship.toml .config/
mv ghostty/.config/ghostty .config/

# 2. Create .stow-local-ignore
cat > .stow-local-ignore << 'EOF'
macos
packages
bin
EOF

# 3. Remove old package directories
rm -rf zsh zshenv git nvim starship ghostty

# 4. Test with dry run
stow -n -v --dir="$HOME/.dotfiles" --target="$HOME" .

# 5. Actually link
stow --dir="$HOME/.dotfiles" --target="$HOME" .
```

## Stow Commands

```bash
# Link everything
stow --dir="$HOME/.dotfiles" --target="$HOME" .

# Unlink everything  
stow -D --dir="$HOME/.dotfiles" --target="$HOME" .

# Re-link (after adding new files)
stow -R --dir="$HOME/.dotfiles" --target="$HOME" .

# Dry run
stow -n -v --dir="$HOME/.dotfiles" --target="$HOME" .

# Adopt existing files into repo
stow --adopt --dir="$HOME/.dotfiles" --target="$HOME" .
```

**Tip**: If your dotfiles live at `~/.dotfiles`, you can simplify:
```bash
cd ~/.dotfiles && stow --target="$HOME" .
```

## Handling Conflicts

If you have existing files that aren't symlinks:

```bash
# Option 1: Adopt them (moves file into repo, creates symlink)
stow --adopt --dir="$HOME/.dotfiles" --target="$HOME" .

# Option 2: Back them up first
mv ~/.zshrc ~/.zshrc.bak
stow --dir="$HOME/.dotfiles" --target="$HOME" .
```

## What You Can Delete

With this approach, you no longer need:
- `bin/link_config`
- `bin/link_home`  
- `bin/link_ides`
- Per-app package directories
- Separate package list files (npmfile, rustfile, etc. → consolidate in Brewfile)

## Adding New Dotfiles

```bash
# New file in home directory
mv ~/.newrc ~/.dotfiles/.newrc
stow -R --dir="$HOME/.dotfiles" --target="$HOME" .

# New file in .config
mv ~/.config/newapp ~/.dotfiles/.config/newapp
stow -R --dir="$HOME/.dotfiles" --target="$HOME" .
```

Or use `--adopt` to do the move and link in one step.
