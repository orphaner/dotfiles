#!/bin/sh

# UDEV Rule : cat /etc/udev/rules.d/99-monitor-hotplug.rules
# ACTION=="change", SUBSYSTEM=="drm", ENV{HOTPLUG}=="1", RUN+="/home/nicolas/bin/dualscreen.sh"
# https://bbs.archlinux.org/viewtopic.php?id=170294

export DISPLAY=:0
export XAUTHORITY=/home/nicolas/.Xauthority

if xrandr | grep -q -E "HDMI2 connected"
then
    echo "HDMI2 connected"
    xrandr \
        --output DP2 --off \
        --output DP1 --off \
        --output HDMI2 ---mode 1920x1080 --pos 1920x0 --rotate normal \
        --output HDMI1 --off \
        --output eDP1 --mode 1920x1080 --pos 0x0 --rotate normal \
        --output VGA1 --off \
	--output VIRTUAL1 --off
else
    echo "VGA1 disconnected"
    xrandr \
        --output DP2 --off \
        --output DP1 --off \
        --output HDMI2 --off \
        --output HDMI1 --off \
        --output eDP1 --mode 1920x1080 --pos 1920x0 --rotate normal \
        --output VGA1 --off \
	--output VIRTUAL1 --off
fi
