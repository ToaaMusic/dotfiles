#!/usr/bin/env bash

city="$1"

for i in {1..5}; do
	text=$(curl -s "https://wttr.in/$city?format=1")
	if [[ $? == 0 ]]; then
		text=$(echo "$text" | sed -E "s/\s+/ /g")
		tooltip=$(curl -s "https://wttr.in/$city?format=4")
		if [[ $? == 0 ]]; then
			tooltip=$(echo "$tooltip" | sed -E "s/\s+/ /g")
			echo "{\"text\":\"$text\", \"tooltip\":\"$tooltip\"}"
			exit
		fi
	fi
	sleep 2
done
echo "{\"text\":\"error\", \"tooltip\":\"error\"}"
