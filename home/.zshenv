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

source $HOME/secrets.sh
export PATH="$PATH:$HOME/Apps/mine"

export EDITOR='nvim'
export GUI_EDITOR='zeditor'

# dotnet
export DOTNET_ROOT=/usr/share/dotnet
export PATH="$PATH:$HOME/.dotnet/tools"
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# cargo
export PATH="$PATH:$HOME/.cargo/bin"
