export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

if [ -z "$TOAAM_DOTFILES" ] || [ ! -d "$TOAAM_DOTFILES" ]; then
	_src="${BASH_SOURCE[0]:-${(%):-%N}}"
	while [ -h "$_src" ]; do
		_dir="$(cd -P "$(dirname "$_src")" && pwd)"
		_src="$(readlink "$_src")"
		[[ "$_src" != /* ]] && _src="$_dir/$_src"
	done
	_dir="$(cd -P "$(dirname "$_src")" && pwd)"

	TOAAM_DOTFILES="$(cd "$_dir/.." && pwd)"

	export TOAAM_DOTFILES

	unset _src _dir
fi

[[ -f $HOME/secrets.sh ]] && . $HOME/secrets.sh

export EDITOR='nvim'
export GUI_EDITOR='zeditor'

# dotnet
export DOTNET_ROOT=/usr/share/dotnet
export PATH="$PATH:$HOME/.dotnet/tools"
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# cargo
export PATH="$PATH:$HOME/.cargo/bin"

# ruby
export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"
