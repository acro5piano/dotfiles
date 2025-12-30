#!/bin/bash

# Configure system-wide config using root priviledge
# This is impossible using nix because I'm using arch linux rather than NixOS
set -euo pipefail

# ==============================================================================
# System packages (pacman)
# These require root or system-level integration
# ==============================================================================

SYSTEM_PACKAGES=(
    # Core system (require root or system-level integration)
    arch-install-scripts
    archlinux-keyring
    base
    base-devel
    # linux
    # linux-headers
    # linux-zen
    # linux-zen-headers
    curl
    chromium
    fish
    lynis
    ntp
    openssh
    vim
    ddcutil
    light

    # Docker (daemon requires system integration)
    docker
    docker-compose

    # Desktop environment (Wayland/X11 require system integration)
    easyeffects
    fuse2
    pavucontrol-qt
    pipewire
    pipewire-alsa
    pipewire-pulse
    portaudio
    sway
    wireplumber
    polkit
    xdg-desktop-portal-wlr
    fcitx5
    fcitx5-gtk
    fcitx5-mozc
    fcitx5-configtool

    # Outdated x11 things
    xorg-xinit
    xorg-xwayland
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
