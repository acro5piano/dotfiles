# Nix

Install nix and home-manager:

```bash
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install > /tmp/nix-install
bash /tmp/nix-install --no-daemon
. ~/.nix-profile/etc/profile.d/nix.fish

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
home-manager switch --flake .
```
