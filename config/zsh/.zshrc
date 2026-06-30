fpath[1,0]=(
	"$DOTFILES/system/plugins/zsh-completions/src"
	"$DOTFILES/system/prompt"
	"$DOTFILES/system/completions"
	"$DOTFILES/bin"
)

autoload -Uz if_source

# Directory navigation
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT CDABLE_VARS

# Globbing
setopt EXTENDED_GLOB

# History
setopt EXTENDED_HISTORY INC_APPEND_HISTORY \
	HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS \
	HIST_FIND_NO_DUPS HIST_IGNORE_SPACE HIST_SAVE_NO_DUPS \
	HIST_VERIFY APPEND_HISTORY HIST_NO_STORE

export LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
zstyle ':completion:*' list-colors "${(@)${(s.:.)LS_COLORS}}"

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
autoload -Uz colors && colors
zstyle ":completion:*" menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' use-fzf-default-opts yes

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

export HOMEBREW_NO_ENV_HINTS=1

source $DOTFILES/system/aliases
source $DOTFILES/system/prompt/prompt_custom_setup

if_source $HOME/.localrc

plugins=(
	zsh-syntax-highlighting
	zsh-autosuggestions
	zsh-you-should-use
	fzf-tab
	zsh-autopair
)

for plugin in $plugins; do
	if_source "$DOTFILES/system/plugins/$plugin/$plugin.plugin.zsh"
done

autopair-init

set_name() {
	echo -ne "\033]0;${PWD/#$HOME/~}\007"
}

precmd_functions+=(set_name)

if_source $HOME/.cargo/env # Rust environment
if_source $HOME/.deno/env  # Deno environment
if_source $HOME/.bun/_bun  # Bun completions

timezsh() {
	local shell=${1-$SHELL}
	local i
	for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

if_source $HOME/.turso/env

source <(try init --path "$TRY_PATH")

# bun completions
if_source $HOME/.bun/_bun
if_source $HOME/.deno/env

path[1,0]=(
	"$HOMEBREW_PREFIX/opt/trash/bin"
	"$HOMEBREW_PREFIX/opt/curl/bin"
)

if [[ -f "$HOME/.local/bin/google-cloud-sdk/path.zsh.inc" ]]; then
	. "$HOME/.local/bin/google-cloud-sdk/path.zsh.inc"
fi
if [[ -f "$HOME/.local/bin/google-cloud-sdk/completion.zsh.inc" ]]; then
	. "$HOME/.local/bin/google-cloud-sdk/completion.zsh.inc"
fi
[[ -f "$XDG_CONFIG_HOME/cf/completions/_cf.zsh" ]] && source "$XDG_CONFIG_HOME/cf/completions/_cf.zsh"

export PNPM_HOME="$XDG_DATA_HOME/pnpm"
if ((!${path[(Ie)$PNPM_HOME]})); then
	path[1,0]=$PNPM_HOME
fi

. "$HOME/.local/share/../bin/env"
