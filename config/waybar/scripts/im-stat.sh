#!/bin/bash

current_im=$(fcitx5-remote -n 2>/dev/null)

case "$current_im" in
"keyboard-us" | "keyboard")
	echo '{"text": "EN", "tooltip": "英文", "class": "en"}'
	;;
"pinyin")
	echo '{"text": "拼", "tooltip": "拼音", "class": "pinyin"}'
	;;
"wubi" | "wbx")
	echo '{"text": "五", "tooltip": "五笔", "class": "wubi"}'
	;;
*)
	echo '{"text": "⌨️", "tooltip": "输入法"}'
	;;
esac
