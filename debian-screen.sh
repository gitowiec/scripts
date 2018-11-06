#!/bin/sh
xrandr --setprovideroutputsource 1 0

xrandr --output VIRTUAL1 --off \
        --output DP1 --off \
        --output DVI-I-1-1 --mode 2560x1440 --pos 0x0 --rotate normal \
        --output HDMI1 --off \
        --output LVDS1 --primary --mode 1920x1080 --pos 640x1440 --rotate normal \
        --output VGA1 --off
