# 根据symlink推导dotfiles项目路径并写入TOAAM_DOTFILES环境变量
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

export GUI_EDITOR='zeditor'
