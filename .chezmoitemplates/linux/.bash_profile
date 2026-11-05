# PATH

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# pnpm

export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Interactive shell

if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi
