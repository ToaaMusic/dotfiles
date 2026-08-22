#!/bin/bash

mako_mode=$(makoctl mode | xargs)

if [[ "$mako_mode" == "do-not-disturb" ]]; then
    makoctl mode -s default
else
    makoctl mode -s do-not-disturb
fi

pkill --signal SIGRTMIN+1 waybar
