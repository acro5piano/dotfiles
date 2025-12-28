#!/bin/bash

# Configure system-wide config using root priviledge
# This is impossible using nix because I'm using arch linux rather than NixOS
set -euo pipefail

sudo cp -v ./etc/modules-load.d/uinput.conf /etc/modules-load.d/uinput.conf
sudo cp -v ./etc/iwd/main.conf /etc/iwd/main.conf
sudo cp -v ./etc/systemd/network/20-wlan.network /etc/systemd/network/20-wlan.network
