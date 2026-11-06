# Useful homebrew env vars
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_BAT=1

# init homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

#pnpm stuff
export PNPM_HOME="$HOME/Library/pnpm"
typeset -U path
# setting up path + pnpm
path=("$HOME/.local/bin" "$HOME/.cargo/bin" "$PNPM_HOME/bin" $path)

# use bitwarden's ssh agent
export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
