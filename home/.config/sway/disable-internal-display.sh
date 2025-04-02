#!/bin/bash

# Check if HDMI-A-1 is connected
if swaymsg -t get_outputs | grep -q "HDMI-A-1"; then
    # If HDMI is connected, disable the internal display
    swaymsg output eDP-1 disable
    swaymsg output HDMI-A-1 enable
else
    # If HDMI is not connected, enable the internal display
    swaymsg output eDP-1 enable
fi
