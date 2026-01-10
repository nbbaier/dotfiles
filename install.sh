#!/usr/bin/env zsh
set -eu

DOTFILES="$HOME/.dotfiles"

info() { printf "\033[32m[✓]\033[0m %s\n" "$1"; }
warn() { printf "\033[33m[!]\033[0m %s\n" "$1"; }

# Install homebrew if missing
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install packages (including stow)
info "Installing packages from Brewfile"
brew bundle --file="$DOTFILES/Brewfile"

# Link all dotfiles with one command
info "Linking dotfiles with stow"
stow --dir="$DOTFILES" --target="$HOME" .

# Link IDE configs (VSCode and Cursor) - these go to Application Support, not ~/.config
if [[ "$(uname)" == "Darwin" ]]; then
    APPSUPPORT_DIR="$HOME/Library/Application Support"
    
    if [[ -d "$DOTFILES/apps/vscode" || -d "$DOTFILES/apps/cursor" ]]; then
        info "Linking IDE configs"
        
        # VSCode
        if [[ -d "$DOTFILES/apps/vscode" ]]; then
            mkdir -p "$APPSUPPORT_DIR/Code/User/snippets"
            ln -sf "$DOTFILES/apps/vscode/settings.json" "$APPSUPPORT_DIR/Code/User/settings.json"
            for snippet_file in "$DOTFILES/apps/vscode/snippets"/*; do
                if [ -f "$snippet_file" ]; then
                    ln -sf "$snippet_file" "$APPSUPPORT_DIR/Code/User/snippets/$(basename "$snippet_file")"
                fi
            done
        fi
        
        # Cursor
        if [[ -d "$DOTFILES/apps/cursor" ]]; then
            mkdir -p "$APPSUPPORT_DIR/Cursor/User"
            ln -sf "$DOTFILES/apps/cursor/settings.json" "$APPSUPPORT_DIR/Cursor/User/settings.json"
        fi
    fi
fi

# macOS defaults
if [[ "$(uname)" == "Darwin" ]]; then
    info "Applying macOS defaults"
    for defaults_file in "$DOTFILES"/macos/*.sh; do
        [[ -f "$defaults_file" && ! "$defaults_file" == *".bak"* ]] && source "$defaults_file"
    done
fi

# Clone espanso config
if [[ "$(uname)" == "Darwin" ]]; then
    APPSUPPORT_DIR="$HOME/Library/Application Support"
    if [ ! -d "$APPSUPPORT_DIR/espanso" ]; then
        info "Cloning espanso config"
        git clone https://github.com/nbbaier/espanso-config "$APPSUPPORT_DIR/espanso"
    else
        warn "Espanso config already exists, skipping"
    fi
fi

info "Done! Some changes may require a restart."
