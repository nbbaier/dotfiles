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
         $command "$package"
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

check_and_install_tool "$HOMEBREW_PREFIX/bin/git" "brew install git git-extras" "installing git"
check_and_install_tool "cargo" "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh" "installing rust"
check_and_install_tool "node" "brew install node" "installing node"
if is_installed go; then
   info "go is installed"
else
   warn "you'll need to install go manually"
fi
step
check_and_install_tool "uv" "curl -LsSf https://astral.sh/uv/install.sh | sh" "installing uv"
check_and_install_tool "bun" "curl -fsSL https://bun.sh/install | bash" "installing bun"
check_and_install_tool "deno" "curl -fsSL https://deno.land/install.sh | sh" "installing deno"

info "installing brew packages and casks"
brew bundle --file=$BREWFILE
step

info "installing is vscode extensions"
install_extensions code $CODEFILE
step

info "installing is cursor extensions"
install_extensions cursor $CURSORFILE
step

install_packages "npm install -g" "$NPMFILE" "npm"
install_packages "cargo install" "$RUSTFILE" "rust"
install_packages "uv tool install" "$UVFILE" "uv"
install_packages "bun install -g" "$BUNFILE" "bun"

info "linking config"
source "$DOTFILES/bin/link_config"
step

info "linking home"
source "$DOTFILES/bin/link_home"
step

info "linking IDE configs"
source "$DOTFILES/bin/link_ides"
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
