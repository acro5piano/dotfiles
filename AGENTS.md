# AGENTS.md

## Nix + mise (critical)

- **New dev tools / CLIs** (pinact, uv, npm tools, etc.): add to `nix/home.nix:134` under `programs.mise.globalConfig.tools` (e.g. `pinact = "latest";`).
- **Never** add dev runtimes to `home.packages`. Use Nix packages only for the few custom derivations (toggl-cli, clipman, xremap) or true system tools.
- After any change to `nix/home.nix`:
  ```bash
  ./bin/apply-nix.sh
  ```
  (runs `home-manager switch --flake . && mise install` + other setup)

- See `NIX.md` for architecture: Arch Linux (pacman) → Nix (user packages via home-manager) → mise (all dev toolchains).

## Workflow

- `home-manager switch --flake .` after Nix edits.
- `mise install` activates new tools declared in home.nix.
- Dotfiles in `home/` are symlinked via `home.file`/`xdg.configFile` in `nix/home.nix`.
- Test Nix changes with `nix flake check`.

Preserve this structure. All future tool additions must follow the mise pattern.
