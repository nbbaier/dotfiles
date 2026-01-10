#!/usr/bin/env bash
# Dependency installer for dotfiles
# This script installs required tools and packages but does NOT link dotfiles
# For linking, use: bin/dotfiles link

set -euo pipefail

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
export PKG_DIR="$DOTFILES/packages"
export APPSUPPORT_DIR="$HOME/Library/Application Support"

# Load helper functions from bin
source "$DOTFILES/bin/is_installed"

BREWFILE="$PKG_DIR/brewfile"
CODEFILE="$PKG_DIR/codefile"
CURSORFILE="$PKG_DIR/cursorfile"
BUNFILE="$PKG_DIR/bunfile"
NPMFILE="$PKG_DIR/npmfile"
RUSTFILE="$PKG_DIR/rustfile"
UVFILE="$PKG_DIR/uvfile"

info() {
   printf "\r\033[01;32m[ i ]\033[0m %s\n" "$1"
}

warn() {
   printf "\r\033[01;31m[ w ]\033[0m %s\n" "$1"
}

error() {
   printf "\r\033[01;31m[ ERROR ]\033[0m %s\n" "$1"
   exit 1
}

step() {
   printf "\n"
}

work() {
   printf "\r\033[01;33m[ w ]\033[0m %s\n" "$1"
}

# Function to install packages from a file using a given command
install_packages() {
   local command="$1"
   local package_file="$2"
   local package_name="$3"

   if [ ! -f "$package_file" ]; then
      warn "$package_name file not found: $package_file"
      return
   fi

   info "installing $package_name packages"
   while IFS= read -r package || [ -n "$package" ]; do
      if [[ -n "${package// /}" && ! "$package" =~ ^# ]]; then
         work "installing $package"
         eval "$command \"$package\""
      fi
   done <"$package_file"
   step
}

# Function to check and install a tool if not present
check_and_install_tool() {
   local tool_name="$1"
   local install_command="$2"
   local install_message="$3"

   if is_installed "$tool_name"; then
      info "$tool_name is installed"
   else
      work "$install_message"
      eval "$install_command"
   fi
   step
}

# Keep sudo alive throughout the script execution
keep_sudo_alive() {
   info "Setting up sudo auto-renewal"
   sudo -v
   while true; do
      sudo -n true
      sleep 60
      kill -0 "$$" || exit
   done 2>/dev/null &
}

### DEPENDENCY INSTALLATION STARTS HERE ###

echo ''
info "starting dependency installation"
step

# Ensure we're in bash or zsh
if [ -n "${ZSH_VERSION:-}" ]; then
   info "Running in zsh"
elif [ -n "${BASH_VERSION:-}" ]; then
   info "Running in bash"
else
   warn "Unknown shell, proceeding anyway"
fi

# Check/set default shell to zsh (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
   if [ "${SHELL##*/}" != "zsh" ]; then
      info 'Changing default shell to zsh'
      chsh -s /bin/zsh
   else
      info 'Already using zsh'
   fi
fi
step

warn "need sudo for some operations"
sudo -v
keep_sudo_alive
step

# Install Homebrew (macOS)
if is_installed brew; then
   info "homebrew is installed"
else
   work "installing homebrew"
   NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
step

# Determine HOMEBREW_PREFIX
if [[ "$OSTYPE" == "darwin"* ]]; then
   if [[ "$(uname -m)" == "arm64" ]]; then
      export HOMEBREW_PREFIX="/opt/homebrew"
   else
      export HOMEBREW_PREFIX="/usr/local"
   fi
   eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

# Install core development tools
check_and_install_tool git "brew install git git-extras" "installing git"
check_and_install_tool cargo "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" "installing rust"
check_and_install_tool node "brew install node" "installing node"

if is_installed go; then
   info "go is installed"
else
   warn "you'll need to install go manually"
fi
step

check_and_install_tool uv "curl -LsSf https://astral.sh/uv/install.sh | sh" "installing uv"
check_and_install_tool bun "curl -fsSL https://bun.sh/install | bash" "installing bun"
check_and_install_tool deno "curl -fsSL https://deno.land/install.sh | sh" "installing deno"

# Install GNU Stow
check_and_install_tool stow "brew install stow" "installing stow"

info "installing brew packages and casks"
if [ -f "$BREWFILE" ]; then
   brew bundle --file="$BREWFILE"
else
   warn "brewfile not found: $BREWFILE"
fi
step

# Install VS Code extensions
if [ -f "$CODEFILE" ] && is_installed code; then
   info "installing vscode extensions"
   "$DOTFILES/bin/install_extensions" code "$CODEFILE"
else
   warn "vscode not installed or codefile not found, skipping extensions"
fi
step

# Install Cursor extensions
if [ -f "$CURSORFILE" ] && is_installed cursor; then
   info "installing cursor extensions"
   "$DOTFILES/bin/install_extensions" cursor "$CURSORFILE"
else
   warn "cursor not installed or cursorfile not found, skipping extensions"
fi
step

# Install packages from various package managers
install_packages "npm install -g" "$NPMFILE" "npm"
install_packages "cargo install" "$RUSTFILE" "rust"
install_packages "uv tool install" "$UVFILE" "uv"
install_packages "bun install -g" "$BUNFILE" "bun"

# macOS-specific configurations
if [[ "$OSTYPE" == "darwin"* ]]; then
   info "setting macos defaults"
   for DEFAULTS_FILE in "${DOTFILES}"/macos/*.sh; do
      [[ ! "$DEFAULTS_FILE" == *".bak"* ]] && echo "applying $(basename "$DEFAULTS_FILE")" && bash "${DEFAULTS_FILE}"
   done
   step

   info "cloning espanso config"
   if [ -d "$APPSUPPORT_DIR/espanso" ]; then
      warn "espanso config already exists, removing"
      rm -rf "$APPSUPPORT_DIR/espanso"
   fi
   git clone https://github.com/nbbaier/espanso-config "$APPSUPPORT_DIR/espanso" || warn "Failed to clone espanso config"
   step
fi

info "Dependency installation complete!"
step

# Link IDE configs (vscode, cursor) - these use macOS-specific paths
if [[ "$OSTYPE" == "darwin"* ]]; then
   info "linking IDE configs"
   if [ -f "$DOTFILES/bin/link_ides" ]; then
      bash "$DOTFILES/bin/link_ides"
   fi
   step
fi

info "Dependency installation and IDE linking complete!"
info "Next steps:"
info "  1. Run 'bin/dotfiles link' to link your dotfiles"
info "  2. Restart your shell or run 'source ~/.zshenv && source ~/.config/zsh/.zshrc'"
