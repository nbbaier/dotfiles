fpath=($DOTFILES/system/plugins/zsh-completions/src $fpath)
fpath=($DOTFILES/system/prompt $fpath)
fpath=($DOTFILES/system/completions $fpath)
fpath=($DOTFILES/bin $fpath)

autoload -Uz if_source

setopt AUTO_CD           # Go to folder path without using cd.
setopt AUTO_PUSHD        # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS # Do not store duplicates in the stack.
setopt PUSHD_SILENT      # Do not print the directory stack after pushd or popd.
setopt CORRECT           # Spelling correction
setopt CDABLE_VARS       # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB     # Use extended globbing syntax.

setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first whenk trimming history.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY         # append to history file
setopt HIST_NO_STORE          # Don't store history commands

export LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

bindkey -e
autoload -U compinit && compinit
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
   source $DOTFILES/system/plugins/$plugin/$plugin.plugin.zsh
done

autopair-init

function set_name() {
   echo -ne "\033]0;${PWD/#$HOME/~}\007"
}

precmd_functions+=(set_name)

if_source $CARGO_HOME/env
if_source $HOME/.deno/env
if_source $HOME/.bun/_bun

timezsh() {
   shell=${1-$SHELL}
   for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

export PATH="/opt/homebrew/opt/curl/bin:$PATH"

# bun completions
[ -s "/Users/nbbaier/.bun/_bun" ] && source "/Users/nbbaier/.bun/_bun"
