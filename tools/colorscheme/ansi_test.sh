#!/bin/bash

# ANSI 16色预览脚本
# 显示标准16色的各种样式组合
# 由 deepseek 生成

# 颜色定义
reset='\033[0m'
bold='\033[1m'
dim='\033[2m'
italic='\033[3m'
underline='\033[4m'
blink='\033[5m'
reverse='\033[7m'
hidden='\033[8m'

# 前景色
fg_colors=(
	"30:黑色" "31:红色" "32:绿色" "33:黄色"
	"34:蓝色" "35:品红" "36:青色" "37:白色"
	"90:亮黑" "91:亮红" "92:亮绿" "93:亮黄"
	"94:亮蓝" "95:亮品红" "96:亮青" "97:亮白"
)

# 背景色
bg_colors=(
	"40:黑色" "41:红色" "42:绿色" "43:黄色"
	"44:蓝色" "45:品红" "46:青色" "47:白色"
	"100:亮黑" "101:亮红" "102:亮绿" "103:亮黄"
	"104:亮蓝" "105:亮品红" "106:亮青" "107:亮白"
)

# 打印标题
print_header() {
	echo -e "\n${bold}${underline}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${reset}"
	echo -e "${bold}  🎨 ANSI 16色完整预览${reset}"
	echo -e "${bold}${underline}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${reset}\n"
}

# 打印颜色块
print_color_block() {
	local fg_code=$1
	local bg_code=$2
	local label=$3
	local style=$4

	printf "${style}${bg_code};${fg_code}m"
	printf " %-12s " "$label"
	printf "${reset}"
}

# 打印前景色表
print_foreground_colors() {
	echo -e "${bold}▶ 前景色 (Foreground Colors)${reset}\n"

	# 表头
	printf "      "
	for i in {0..7}; do
		printf "  %-8s" "标准$((i + 1))"
	done
	echo
	printf "      "
	for i in {0..7}; do
		printf "  %-8s" "亮色$((i + 1))"
	done
	echo

	# 分隔线
	printf "      "
	for i in {0..15}; do
		printf "──────────"
	done
	echo

	# 普通颜色
	printf "普通  "
	for i in {0..7}; do
		printf "\033[3${i}m  %-8s\033[0m" "示例"
	done
	printf "\n"

	# 亮色
	printf "亮色  "
	for i in {0..7}; do
		printf "\033[9${i}m  %-8s\033[0m" "示例"
	done
	echo -e "\n"
}

# 打印背景色表
print_background_colors() {
	echo -e "${bold}▶ 背景色 (Background Colors)${reset}\n"

	# 表头
	printf "      "
	for i in {0..7}; do
		printf "  %-8s" "标准$((i + 1))"
	done
	echo
	printf "      "
	for i in {0..7}; do
		printf "  %-8s" "亮色$((i + 1))"
	done
	echo

	# 分隔线
	printf "      "
	for i in {0..15}; do
		printf "──────────"
	done
	echo

	# 普通背景
	printf "普通  "
	for i in {0..7}; do
		printf "\033[4${i}m  %-8s\033[0m" "示例"
	done
	printf "\n"

	# 亮色背景
	printf "亮色  "
	for i in {0..7}; do
		printf "\033[10${i}m  %-8s\033[0m" "示例"
	done
	echo -e "\n"
}

# 打印组合样式表
print_combinations() {
	echo -e "${bold}▶ 前景+背景组合 (Foreground + Background Combinations)${reset}\n"

	# 标题行
	printf "%-10s" "FG\\BG"
	for bg in {40..47}; do
		printf "\033[${bg}m  %-4s\033[0m" "$((bg - 40))"
	done
	printf "  "
	for bg in {100..107}; do
		printf "\033[${bg}m  %-4s\033[0m" "$((bg - 90))"
	done
	echo

	# 分隔线
	printf "%-10s" ""
	for i in {0..15}; do
		printf "──────"
	done
	echo

	# 标准前景色
	for fg in {30..37}; do
		printf "\033[${fg}m%-8s\033[0m" "$((fg - 30))"
		for bg in {40..47}; do
			printf "\033[${bg};${fg}m  %-4s\033[0m" "A"
		done
		printf "  "
		for bg in {100..107}; do
			printf "\033[${bg};${fg}m  %-4s\033[0m" "A"
		done
		echo
	done

	# 亮前景色
	for fg in {90..97}; do
		printf "\033[${fg}m%-8s\033[0m" "$((fg - 80))"
		for bg in {40..47}; do
			printf "\033[${bg};${fg}m  %-4s\033[0m" "A"
		done
		printf "  "
		for bg in {100..107}; do
			printf "\033[${bg};${fg}m  %-4s\033[0m" "A"
		done
		echo
	done
	echo
}

# 打印文本样式
print_text_styles() {
	echo -e "${bold}▶ 文本样式 (Text Styles)${reset}\n"

	printf "%-20s" "样式"
	printf "%-25s" "示例文本"
	printf "%-20s" "代码"
	echo

	# 分隔线
	printf "%-20s" "────────────────────"
	printf "%-25s" "─────────────────────────"
	printf "%-20s" "────────────────────"
	echo

	printf "%-20s" "重置 (Reset)"
	printf "\033[0m%-25s\033[0m" "Hello World"
	printf "%-20s" "\033[0m"
	echo

	printf "%-20s" "粗体 (Bold)"
	printf "\033[1m%-25s\033[0m" "Hello World"
	printf "%-20s" "\033[1m"
	echo

	printf "%-20s" "暗淡 (Dim)"
	printf "\033[2m%-25s\033[0m" "Hello World"
	printf "%-20s" "\033[2m"
	echo

	printf "%-20s" "斜体 (Italic)"
	printf "\033[3m%-25s\033[0m" "Hello World"
	printf "%-20s" "\033[3m"
	echo

	printf "%-20s" "下划线 (Underline)"
	printf "\033[4m%-25s\033[0m" "Hello World"
	printf "%-20s" "\033[4m"
	echo

	printf "%-20s" "闪烁 (Blink)"
	printf "\033[5m%-25s\033[0m" "Hello World"
	printf "%-20s" "\033[5m"
	echo

	printf "%-20s" "反色 (Reverse)"
	printf "\033[7m%-25s\033[0m" "Hello World"
	printf "%-20s" "\033[7m"
	echo

	printf "%-20s" "隐藏 (Hidden)"
	printf "\033[8m%-25s\033[0m" "Hello World"
	printf "%-20s" "\033[8m"
	echo -e "\n"
}

# 打印调色板
print_palette() {
	echo -e "${bold}▶ 颜色调色板 (Color Palette)${reset}\n"

	# 标准色
	echo -e "${bold}标准色:${reset}"
	for i in {0..7}; do
		printf "\033[48;5;${i}m  %-3s  \033[0m" "$i"
	done
	echo -e "\n"

	# 亮色
	echo -e "${bold}亮色:${reset}"
	for i in {8..15}; do
		printf "\033[48;5;${i}m  %-3s  \033[0m" "$i"
	done
	echo -e "\n"

	# 216色（6x6x6）
	echo -e "${bold}216色 (6x6x6 cube):${reset}"
	for r in {0..5}; do
		for g in {0..5}; do
			for b in {0..5}; do
				color=$((16 + r * 36 + g * 6 + b))
				printf "\033[48;5;${color}m  \033[0m"
			done
			printf " "
		done
		echo
	done
	echo

	# 灰度
	echo -e "${bold}灰度 (Grayscale):${reset}"
	for i in {232..255}; do
		printf "\033[48;5;${i}m  %-3s  \033[0m" "$i"
		if [ $(((i - 232) % 6)) -eq 5 ]; then
			echo
		fi
	done
	echo -e "\n"
}

# 主函数
main() {
	clear

	print_header
	print_foreground_colors
	print_background_colors
	print_combinations
	print_text_styles
	print_palette

	echo -e "${bold}${underline}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${reset}"
	echo -e "${dim}提示: 按任意键退出...${reset}"
	read -n 1 -s
	clear
}

# 检查终端是否支持颜色
if [ -t 1 ] && [ "$TERM" != "dumb" ]; then
	main
else
	echo "错误: 终端不支持颜色或不在交互式终端中运行"
	exit 1
fi
