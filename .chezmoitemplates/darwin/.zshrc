# Zinit package manager
source "$HOMEBREW_PREFIX/opt/zinit/zinit.zsh"

# Plugins
zinit wait lucid light-mode for \
	atinit'zicompinit; zicdreplay' \
	nocd \
	zsh-users/zsh-completions \
	atload'_zsh_autosuggest_start' \
	zsh-users/zsh-autosuggestions \
	zdharma-continuum/fast-syntax-highlighting \
	wait'0a' \
	Aloxaf/fzf-tab

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Shell integrations
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"
# zoxide
eval "$(zoxide init --cmd cd zsh)"
# fzf shell integration
source <(fzf --zsh)

# Aliases
alias ls="eza --icons=always --hyperlink"
alias c="clear"