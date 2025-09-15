# === general === #
export DOTFILES="$HOME/.dotfiles"
export PATH="$DOTFILES/bin:$PATH" # add dotfiles bin dir to path

# === XDG === #
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# === ZSH === #
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# === history === #
export HISTFILE="$ZDOTDIR/.zsh_history"
export HISTSIZE=200000
export SAVEHIST=$HISTSIZE
export HISTCONTROL=ignoreboth
export HISTORY_IGNORE="(l|la|ll|ln|ls|lsa|lsg|lsng|pwd|exit)"

# === less === #
export LESSHISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/lesshst"

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

# === node === #
export NPM_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/node_modules"
export NPM_BIN="${XDG_CONFIG_HOME:-$HOME/.config}/node_modules/bin"
export NODE_REPL_HISTORY="${XDG_STATE_HOME:-$HOME/.local/state}/node_repl_history"
export NPM_CONFIG_INIT_MODULE="${XDG_CONFIG_HOME:-$HOME/.config}/npm/config/npm-init.js"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/npm"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npmrc"

# === bun === #
export PATH="$HOME/.bun/bin:$PATH"

# === deno === #
export PATH="$HOME/.deno/bin:$PATH"

# === python === #
export PYTHON_HISTORY="${XDG_STATE_HOME:-$HOME/.local/state}/python_history"
export IPYTHONDIR=${XDG_CONFIG_HOME:-$HOME/.config}/ipython
export JUPYTER_CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}/jupyter

# === rust === #
export PATH=$PATH:"${XDG_DATA_HOME:-$HOME/.local/share}/cargo/bin"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"

# === database stuff === #
export PATH="$HOMEBREW_PREFIX/opt/sqlite/bin:$PATH"
export PATH="$HOMEBREW_PREFIX/opt/postgresql@17/bin:$PATH"
export LDFLAGS="-L$HOMEBREW_PREFIX/opt/sqlite/lib"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/sqlite/include"
export PSQL_HISTORY="${XDG_STATE_HOME:-$HOME/.local/state}/psql_history"

# === smallweb === #
export SMALLWEB_DIR="$HOME/smallweb/localhost"
export PATH="$HOME/.cache/.bun/bin:$PATH"

# === opencode === #
export PATH="$HOME/.opencode/bin:$PATH"

# === try === #
export TRY_PATH=~/code/experiments
