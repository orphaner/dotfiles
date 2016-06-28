#!/bin/sh

# UDEV Rule : cat /etc/udev/rules.d/99-monitor-hotplug.rules
# ACTION=="change", SUBSYSTEM=="drm", ENV{HOTPLUG}=="1", RUN+="/home/nicolas/bin/dualscreen.sh"
# https://bbs.archlinux.org/viewtopic.php?id=170294

    xrandr \
        --output DP2 --mode 1920x1080 --pos 0x0 --rotate normal \
        --output DP1 --mode 1920x1080 --pos 1920x0 --rotate normal \
        --output HDMI2 --off \
        --output HDMI1 --off \
        --output eDP1 --off \
        --output VGA1 --off 
