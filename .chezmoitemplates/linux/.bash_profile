# pnpm to path
export PNPM_HOME="$HOME/.local/share/pnpm"
# local bins + cargo to path
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PNPM_HOME:$PATH"
# init .bashrc
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
# add rbw as the ssh agent socket
[ -n "$XDG_RUNTIME_DIR" ] && export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/rbw/ssh-agent-socket"
