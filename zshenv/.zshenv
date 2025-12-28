# === XDG Base Directory === #
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# === General === #
export DOTFILES="$HOME/.dotfiles"
export EDITOR="code"

# === ZSH === #
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
export HISTFILE="$ZDOTDIR/.zsh_history"
export HISTSIZE=200000
export SAVEHIST=$HISTSIZE

# === Homebrew === #
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_NO_AUTO_UPDATE=1

# === Development Tools === #
# Node
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_repl_history"
export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME/npm/config/npm-init.js"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# Python
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"

# Rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# Go
export GOPATH="$XDG_DATA_HOME/go"

# === Tools === #
export LESSHISTFILE="$XDG_STATE_HOME/lesshst"
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"

# === FZF === #
export FZF_DEFAULT_COMMAND="fd -H"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 30% --layout=reverse --border'

# === Database === #
export LDFLAGS="-L$HOMEBREW_PREFIX/opt/sqlite/lib"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/sqlite/include"

# === Custom Tools === #
export SMALLWEB_DIR="$HOME/smallweb/localhost"
export TRY_PATH="$HOME/code/experiments"
export AMI_INSTALL="$HOME/.ami"

# === PATH (consolidated) === #
path=(
  "$DOTFILES/bin"
  "$HOME/.local/bin"
  "$HOME/.bun/bin"
  "$HOME/.deno/bin"
  "$CARGO_HOME/bin"
  "$HOMEBREW_PREFIX/opt/sqlite/bin"
  "$HOMEBREW_PREFIX/opt/postgresql@17/bin"
  "$HOME/.cache/.bun/bin"
  "$HOME/.opencode/bin"
  "$AMI_INSTALL/bin"
  "$GOPATH/bin"
  $path
)
export PATH

# tuitube
export PATH=/Users/nbbaier/.termcast/compiled/tuitube/bin:$PATH
