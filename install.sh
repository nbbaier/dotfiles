#!/usr/bin/env zsh

# Enable error handling
set -e # Exit immediately if a command exits with non-zero status
set -u # Treat unset variables as an error
# set -o pipefail  # Pipeline fails on any command failure (commented because zsh works differently with pipefail)

export DOTFILES="$HOME/.dotfiles"
source "$DOTFILES/zshenv/.zshenv"
export PKG_DIR="$DOTFILES/packages"
export APPSUPPORT_DIR="$HOME/Library/Application Support"

GOFILE="$PKG_DIR/gofile"
BREWFILE="$PKG_DIR/brewfile"
CASKFILE="$PKG_DIR/caskfile"
CODEFILE="$PKG_DIR/codefile"
CURSORFILE="$PKG_DIR/cursorfile"
BUNFILE="$PKG_DIR/bunfile"
NPMFILE="$PKG_DIR/npmfile"
RUSTFILE="$PKG_DIR/rustfile"
UVFILE="$PKG_DIR/uvfile"

info() {
   printf "\r\033[01;32m[ i ]\033[0m $1\n"
}

warn() {
   printf "\r\033[01;31m[ w ]\033[0m $1\n"
}

error() {
   printf "\r\033[01;31m[ ERROR ]\033[0m $1\n"
   exit 1
}

step() {
   printf "\n"
}

work() {
   printf "\r\033[01;33m[ w ]\033[0m $1\n"
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

### INSTALL STARTS HERE ###

echo ''
info "starting install"
step

if [ "$SHELL" != "/bin/zsh" ]; then
   info 'Changing default shell to zsh'
   chsh -s /bin/zsh
else
   info 'Already using zsh'
fi
step

warn "need sudo"
sudo -v
keep_sudo_alive
step

if is_installed brew; then
   info "homebrew is installed"
else
   work "installing homebrew"
   NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
step

if is_installed "$HOMEBREW_PREFIX/bin/git"; then
   info "git is installed"
else
   work "installing git"
   brew install git git-extras
fi
step

if is_installed cargo; then
   info "rust is installed"
else
   work "installing rust"
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
step

if is_installed node; then
   info "node is installed"
else
   work "installing node"
   brew install node
fi
step

if is_installed go; then
   info "go is installed"
else
   warn "you'll need to install go manually"
fi
step

if is_installed uv; then
   info "uv is installed"
else
   work "installing uv"
   curl -LsSf https://astral.sh/uv/install.sh | sh
fi
step

if is_installed bun; then
   info "bun is installed"
else
   work "installing bun"
   curl -fsSL https://bun.sh/install | bash
fi
step

if is_installed deno; then
   info "deno is installed"
else
   work "installing deno"
   curl -fsSL https://deno.land/install.sh | sh
fi
step

info "installing is brew formula"
brew bundle --file=$BREWFILE
step

info "installing is brew casks"
brew bundle --file=$CASKFILE
step

info "installing is vscode extensions"
install_extensions code $CODEFILE
step

info "installing is cursor extensions"
install_extensions cursor $CURSORFILE
step

info "installing npm packages"
while IFS= read -r package || [ -n "$package" ]; do
   if [[ -n "${package// /}" && ! "$package" =~ ^# ]]; then
      work "installing $package"
      npm install -g "$package"
   fi
done <"$NPMFILE"
step

info "installing rust packages"
while IFS= read -r package || [ -n "$package" ]; do
   if [[ -n "${package// /}" && ! "$package" =~ ^# ]]; then
      work "installing $package"
      cargo install "$package"
   fi
done <"$RUSTFILE"
step

info "installing uv packages"
while IFS= read -r package || [ -n "$package" ]; do
   if [[ -n "${package// /}" && ! "$package" =~ ^# ]]; then
      work "installing $package"
      uv tool install "$package"
   fi
done <"$UVFILE"
step

info "installing bun packages"
while IFS= read -r package || [ -n "$package" ]; do
   if [[ -n "${package// /}" && ! "$package" =~ ^# ]]; then
      work "installing $package"
      bun install -g "$package"
   fi
done <"$BUNFILE"
step

info "linking config"
source "$DOTFILES/bin/link-config"
step

info "linking home"
source "$DOTFILES/bin/link-home"
step

info "linking IDE configs"
source "$DOTFILES/bin/link-ides"
step

info "setting macos defaults"
for DEFAULTS_FILE in "${DOTFILES}"/macos/*.sh; do
   [[ ! "$DEFAULTS_FILE" == *".bak"* ]] && echo "applying $(basename $DEFAULTS_FILE)" && . "${DEFAULTS_FILE}"
done
step

info "cloning espanso config"
if [ -d "$APPSUPPORT_DIR/espanso" ]; then
   warn "espanso config already exists, removing"
   rm -rf "$APPSUPPORT_DIR/espanso"
fi

git clone https://github.com/nbbaier/espanso-config "$APPSUPPORT_DIR/espanso"
step

info "Everything installed, some changes may require restart to take effect"
