fpath=($DOTFILES/system-plugins/zsh-completions/src $fpath)
fpath=($ZDOTDIR/prompt $fpath)
fpath=($ZDOTDIR/completions $fpath)
fpath=($DOTFILES/bin $fpath)

autoload -Uz if_source

# Directory navigation
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT CDABLE_VARS

# Globbing
setopt EXTENDED_GLOB

# History
setopt EXTENDED_HISTORY INC_APPEND_HISTORY SHARE_HISTORY \
	HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS \
	HIST_FIND_NO_DUPS HIST_IGNORE_SPACE HIST_SAVE_NO_DUPS \
	HIST_VERIFY APPEND_HISTORY HIST_NO_STORE

export LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

bindkey -e
autoload -Uz compinit

() {
    setopt local_options extendedglob
    local zcd="${ZDOTDIR:-$HOME}/.zcompdump"
    if [[ ! -f "$zcd" || -n ${zcd}(#qN.mh+24) ]]; then
        compinit
    else
        compinit -C
    fi
}

autoload -Uz +X bashcompinit && bashcompinit
autoload -U colors && colors
zstyle ":completion:*" menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' use-fzf-default-opts yes

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

source $ZDOTDIR/aliases
source $ZDOTDIR/prompt/prompt_custom_setup

[ -s $HOME/.localrc ] && source $HOME/.localrc

plugins=(
	zsh-syntax-highlighting
	zsh-autosuggestions
	zsh-you-should-use
	fzf-tab
	zsh-autopair
)

for plugin in $plugins; do
    if_source "$DOTFILES/system-plugins/$plugin/$plugin.plugin.zsh"
done

export ZSH_GIT_AI_PROVIDER="openai"
export ZSH_GIT_AI_STYLE="conventional"

if_source /opt/homebrew/share/zsh-git-ai/zsh-git-ai.plugin.zsh

autopair-init

function set_name() {
	echo -ne "\033]0;${PWD/#$HOME/~}\007"
}

precmd_functions+=(set_name)

if_source $HOME/.cargo/env # Rust environment
if_source $HOME/.deno/env  # Deno environment
if_source $HOME/.bun/_bun  # Bun completions

timezsh() {
	shell=${1-$SHELL}
	for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

if_source $HOME/.turso/env

eval "$(~/.local/try.rb init $TRY_PATH)"

. "$HOME/.local/share/../bin/env"

# bun completions
[ -s "/Users/nbbaier/.bun/_bun" ] && source "/Users/nbbaier/.bun/_bun"

# Added by tally installer
export PATH="$HOME/.tally/bin:$PATH"
