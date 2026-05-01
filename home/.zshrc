# PROMPT='%F{cyan}%m%f%#'
# PROMPT=$'%F{cyan}%m%f '

PROMPT='%F{cyan}>%f '

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt inc_append_history
setopt append_history

# 同步yazi输出的路径
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

function dotnet() {
    if [[ "$1" == "run" || "$1" == "test" ]]; then
        local dir="$PWD"
        local found_env=""
        
        while [[ "$dir" != "/" ]]; do
            if [[ -f "$dir/.env.sh" ]]; then
                found_env="$dir/.env.sh"
                break
            fi
            dir="$(dirname "$dir")"
        done
        
        if [[ -n "$found_env" ]]; then
            echo "🔧 Loading: $found_env"
            (
                source "$found_env"
                command dotnet "$@"
            )
        else
            command dotnet "$@"
        fi
    else
        command dotnet "$@"
    fi
}

# todo tool
function todo() {
    local script="$TOAAM_DOTFILES/tools/todo/todo.lua"
    lua "$script" "$@"
}

# open dotfiles project
function tdf() {
    # local opener=${1:-${GUI_EDITOR:-nvim}}
    nvim "$TOAAM_DOTFILES"
}

# cd repos dir
function repos() {
  cd ~/repos/
}

# transparent cava
function cavat() {
  kitty --override "background_opacity=0" cava
}

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias yazi=y
alias zed=zeditor
alias oc=opencode
alias sd=shutdown
alias dn=dotnet
alias ectl=/home/ToaaM/repos/ebrain-ai/.build/ctl/EbrainEngine.Ctl
