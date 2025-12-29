#!/bin/bash

# Configure system-wide config using root priviledge
# This is impossible using nix because I'm using arch linux rather than NixOS
set -euo pipefail

# ==============================================================================
# System packages (pacman)
# These require root or system-level integration
# ==============================================================================

SYSTEM_PACKAGES=(
    # Core system (from pacman.yml)
    acpi
    arch-install-scripts
    archlinux-keyring
    curl
    dnsutils
    fish
    gcc
    gcc-fortran
    git
    lapack
    light
    lynis
    make
    man-db
    ntp
    openssh
    openssl
    postgresql-client
    python
    python-pip
    rsync
    ruby
    rubygems
    tmux
    tree
    unzip
    vim
    zip

    # Docker
    docker
    docker-compose

    # Desktop environment (from sway.yml)
    clipmenu
    ddcutil
    dunst
    easyeffects
    feh
    fuse2
    grim
    i3status-rust
    pavucontrol-qt
    pipewire
    pipewire-alsa
    pipewire-pulse
    slurp
    sway
    swaybg
    wireplumber
    wl-clipboard
    xclip
    xcolor
    xdg-desktop-portal-wlr
    xorg-xinit
    xorg-xwayland


    portaudio
)

echo "Installing system packages..."
sudo pacman -S --needed --noconfirm "${SYSTEM_PACKAGES[@]}"

# ==============================================================================
# User and group configuration (from user.yml)
# ==============================================================================

echo "Configuring user and groups..."

# Ensure plugdev group exists
sudo groupadd -f plugdev

# Add user to required groups
sudo usermod -aG sys,docker,video,wheel,plugdev,input kazuya

# ==============================================================================
# System configuration files
# ==============================================================================

echo "Copying system configuration files..."

sudo cp -v ./etc/modules-load.d/uinput.conf /etc/modules-load.d/uinput.conf
sudo cp -v ./etc/iwd/main.conf /etc/iwd/main.conf
sudo cp -v ./etc/systemd/network/20-wlan.network /etc/systemd/network/20-wlan.network

echo "Done! System configuration applied."
