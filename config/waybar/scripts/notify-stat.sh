#!/bin/bash

mako_mode=$(makoctl mode | xargs)

if [[ "$mako_mode" == "default" ]]; then
    echo '{ "text": "󰂚", "alt": "activated", "class": "activated" }'
else
    echo '{ "text": "󰂛", "alt": "deactivated", "class": "deactivated" }'
fi
