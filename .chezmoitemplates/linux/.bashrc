# Only run for interactive shells
case $- in
*i*) ;;
*) return ;;
esac

# History
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000

shopt -s histappend
shopt -s checkwinsize
shopt -s progcomp
shopt -s cdspell

# Menu completion visual settings
bind 'set menu-complete-display-prefix on'
bind 'set colored-completion-prefix on'
bind 'set colored-stats on'
bind 'set show-all-if-ambiguous on'
bind 'set show-all-if-unmodified on'

# Completion
if [ -r /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
fi

# fzf bash shell integration. 
eval "$(fzf --bash)"
. ~/.local/share/fzf-tab-completion/bash/fzf-bash-completion.sh
bind -x '"\t": fzf_bash_completion'

# Prompt
PS1='\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ '

# Aliases
alias ls="eza --icons=always --hyperlink"
alias c="clear"

eval "$(zoxide init bash)"
