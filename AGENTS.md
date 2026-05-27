# AGENTS.md

## Nix + mise (critical)

- **New dev tools / CLIs** (`pinact`, `uv`, npm CLIs, etc.):
  - Add to `nix/home.nix:134` in `programs.mise.globalConfig.tools`
  - Examples: `pinact = "latest";`, `node = ["24" "22"];`, `"npm:opencode-ai" = "1.15.10";`, `"pipx:ipython" = "latest";`
- **Never** add dev runtimes/languages to `home.packages`. 
  - Use Nix packages **only** for the few custom derivations at top of `nix/home.nix` (toggl-cli, clipman, xremap) or true system/OS tools.
- After **any** change to `nix/home.nix`:
  ```bash
  ./bin/apply-nix.sh
  ```
  (runs `home-manager switch --flake . && mise install`, clones private repos, sets up joplin symlink, etc.)

- See `NIX.md` for full architecture: Arch Linux (pacman for host) → Nix (user packages via home-manager) → mise (all dev toolchains/runtimes).

## Workflow

- Edit declarative config in `nix/home.nix` and `home/` (never edit generated files in `~/.config/` or Nix store).
- `home-manager switch --flake .` after Nix edits.
- `mise install` (or `mise use -g`) activates declared tools.
- Dotfiles in `home/` are symlinked via `home.file` and `xdg.configFile` blocks in `nix/home.nix`.
- Test changes: `nix flake check`.
- Run `./bin/apply-*.sh` scripts for full idempotent setup (`apply-nix.sh`, `apply-etc.sh`, `apply-aur.sh`).

## Key Gotchas

- Mise config lives in `nix/home.nix:131` — `~/.config/mise/config.toml` is a Nix-managed symlink.
- Fish shell activates mise via `~/.config/fish/config.fish`.
- Preserve exact structure of `tools` map and custom derivations.
- All future tool additions (including opencode skills/agents) must follow the mise pattern unless they require custom Nix packaging.

This file is the highest-priority context for OpenCode sessions in this repo.
