# 同步yazi输出的路径
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
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

alias yazi=y
alias zed=zeditor
