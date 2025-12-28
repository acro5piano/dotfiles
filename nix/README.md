# Nix

Install nix and home-manager:

```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
. /home/kazuya/.nix-profile/etc/profile.d/nix.fish

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

```bash
cp local.nix.example local.nix
nvim local.nix                     # Replace with your own username
```
