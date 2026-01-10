# Dotfiles with GNU Stow

Stow is dead simple: it symlinks directory contents to a target (default: parent directory). Your dotfiles structure already maps well to this.

## Directory Structure

```
~/.dotfiles/
├── zsh/
│   └── .zshrc
│   └── .zshenv
├── git/
│   └── .gitconfig
│   └── .gitignore_global
├── nvim/
│   └── .config/
│       └── nvim/
│           └── init.lua
├── starship/
│   └── .config/
│       └── starship.toml
├── ghostty/
│   └── .config/
│       └── ghostty/
│           └── config
├── packages/
│   ├── Brewfile
│   ├── npmfile
│   └── ...
├── macos/
│   └── defaults.sh
└── install.sh
```

**Key insight**: The directory structure inside each "package" mirrors where it goes in `~`. So `zsh/.zshrc` becomes `~/.zshrc`, and `nvim/.config/nvim/init.lua` becomes `~/.config/nvim/init.lua`.

## Simplified install.sh

```zsh
#!/usr/bin/env zsh
set -eu

DOTFILES="$HOME/.dotfiles"

info() { printf "\033[32m[✓]\033[0m %s\n" "$1"; }
warn() { printf "\033[33m[!]\033[0m %s\n" "$1"; }

# Install homebrew if missing
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install everything from Brewfile (including stow)
info "Installing packages from Brewfile"
brew bundle --file="$DOTFILES/packages/Brewfile"

# Stow all config packages
info "Linking dotfiles with stow"
cd "$DOTFILES"

# List packages to stow (everything except meta directories)
PACKAGES=(zsh git nvim starship ghostty)

for pkg in "${PACKAGES[@]}"; do
    if [[ -d "$pkg" ]]; then
        stow -v --target="$HOME" "$pkg"
        info "Stowed $pkg"
    fi
done

# macOS defaults
if [[ "$(uname)" == "Darwin" ]]; then
    info "Applying macOS defaults"
    source "$DOTFILES/macos/defaults.sh"
fi

info "Done! Some changes may require a restart."
```

## Consolidated Brewfile

Put everything in one place—Homebrew can handle it all:

```ruby
# packages/Brewfile

# Taps
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

# Rust tools (if you prefer brew over cargo)
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

# Mac App Store (requires `mas` brew)
brew "mas"
mas "Things 3", id: 904280696
```

## Stow Commands

```bash
# Link a package
stow zsh                    # Links ~/.dotfiles/zsh/* → ~/

# Unlink a package
stow -D zsh                 # Removes symlinks

# Re-link (useful after changes)
stow -R zsh                 # Unlinks then links

# Dry run (see what would happen)
stow -n -v zsh

# Adopt existing files (pulls them into dotfiles)
stow --adopt zsh            # Moves ~/file → ~/.dotfiles/zsh/file, creates symlink
```

## Handling Conflicts

If you have existing files that aren't symlinks:

```bash
# Option 1: Adopt them
stow --adopt zsh

# Option 2: Back them up first
mv ~/.zshrc ~/.zshrc.bak
stow zsh
```

## What You Can Delete

With stow, you no longer need:

-  `bin/link_config`
-  `bin/link_home`
-  `bin/link_ides`
-  Individual package install scripts (if consolidated into Brewfile)

Your install.sh goes from ~150 lines to ~40.
