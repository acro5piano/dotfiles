#!/bin/bash

# Configure system-wide config using root priviledge
# This is impossible using nix because I'm using arch linux rather than NixOS
set -euo pipefail

AUR_PACKAGES=(
    brave-bin
    light
    xremap-x11-bin
)

echo "Installing aur packages..."
paru -S --needed --noconfirm "${AUR_PACKAGES[@]}"

echo "Done! Paru package installation applied."
