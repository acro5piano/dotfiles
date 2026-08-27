#!/bin/bash

# Install AUR packages
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
source "$DOTFILES_DIR/bin/packages.sh"

# paru builds AUR packages with makepkg against system libraries, so it has to
# be a system package itself. Bootstrap it if it is not there yet.
if ! command -v paru &>/dev/null; then
    echo "==> paru not found. Bootstrapping paru-bin from the AUR..."
    tmp="$(mktemp -d)"
    git clone --depth 1 https://aur.archlinux.org/paru-bin.git "$tmp/paru-bin"
    (cd "$tmp/paru-bin" && makepkg -si --noconfirm)
    rm -rf "$tmp"
fi

echo "Installing aur packages..."
paru -S --needed --noconfirm "${AUR_PACKAGES[@]}"

echo "Done! Paru package installation applied."
