#!/bin/bash
# Install user tools via Nix (home-manager)
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# Check if nix is installed
if ! command -v nix &>/dev/null; then
    echo "==> Nix not found. Installing..."
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
    echo "==> Please restart your shell and run this script again."
    exit 0
fi

# Ensure experimental features are enabled
echo "==> Ensuring nix experimental features..."
mkdir -p ~/.config/nix
grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null || \
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Check if home-manager is installed
if ! command -v home-manager &>/dev/null; then
    echo "==> home-manager not found. Installing..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
fi

echo "==> Applying home-manager configuration..."
cd "$DOTFILES_DIR"
home-manager switch --flake .

echo "==> Installing devtools using mise..."
mise install

echo "==> Done."
