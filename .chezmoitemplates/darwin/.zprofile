export HOMEBREW_NO_ENV_HINTS=1
eval "$(/opt/homebrew/bin/brew shellenv)"

export PNPM_HOME="$HOME/Library/pnpm"
typeset -U path
path=("$HOME/.local/bin" "$HOME/.cargo/bin" "$PNPM_HOME/bin" $path)

export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
