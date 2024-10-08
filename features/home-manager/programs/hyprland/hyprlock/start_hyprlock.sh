#!/usr/bin/env bash

grim -o HDMI-A-1 -l 0 /tmp/hyprlock_screenshot1.png & # run this command in background
# grim -o DP-1 -l 0 /tmp/hyprlock_screenshot2.png & # idem
wait && # wait background commands to finish
pidof hyprlock || hyprlock # so hyprlock will only start when screenshot(s) are done
