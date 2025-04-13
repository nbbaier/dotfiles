# === general === #
export DOTFILES="$HOME/.dotfiles"
export PATH="$DOTFILES/bin:$PATH"

# === XDG === #
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# === ZSH === #
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

## history config
export HISTFILE="$ZDOTDIR/.zsh_history"
export HISTSIZE=200000
export SAVEHIST=$HISTSIZE
export HISTCONTROL=ignoreboth
export HISTORY_IGNORE="(l|la|ll|ln|ls|lsa|lsg|lsng|pwd|exit)"

# === FZF === #
export FZF_DEFAULT_COMMAND="fd -H"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 30% --layout=reverse --border'

# === Editor === #
export EDITOR="code"

# === Homebrew === #
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_NO_AUTO_UPDATE=1

# === path === #
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# === node === #
export NPM_PATH="$XDG_CONFIG_HOME/node_modules"
export NPM_BIN="$XDG_CONFIG_HOME/node_modules/bin"

# === bun === #
export PATH="$HOME/.bun/bin:$PATH"

# === deno === #
export PATH="$HOME/.deno/bin:$PATH"

# # === go === #
# export GOPATH="$XDG_DATA_HOME/go"
# export GOBIN="$XDG_DATA_HOME/go/bin"
# export GOROOT="$XDG_DATA_HOME/.go"
# export GOCACHE="$XDG_CACHE_HOME/go-build"
# export PATH=$GOROOT/bin:$GOBIN:$PATH

# === rust === #
export PATH=$PATH:"$XDG_DATA_HOME/cargo/bin"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# === database stuff === #
export PATH="$HOMEBREW_PREFIX/opt/sqlite/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/postgresql@17/bin:$PATH"

export LDFLAGS="-L$HOMEBREW_PREFIX/opt/sqlite/lib"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/sqlite/include"

# === smallweb === #
export SMALLWEB_DIR="$HOME/smallweb/localhost"
export PATH="/Users/nbbaier/.cache/.bun/bin:$PATH"
