## Quick Reference

### Where does a new thing go? (critical)

Decide in this order:

1. **Dev runtime or pinned dev CLI** (`node`, `python`, `uv`, npm/pipx CLIs, `pinact`)
   → `programs.mise.globalConfig.tools` in `nix/home.nix`.
   Examples: `node = ["24" "22"];`, `"npm:opencode-ai" = "1.17.8";`, `"pipx:ipython" = "latest";`
2. **In the Arch repos or the AUR** (check with `pacman -Si <pkg>` / `paru -Si <pkg>`)
   → `bin/packages.sh`: `SYSTEM_PACKAGES` if it needs root / hardware / a system
   service, `USER_PACKAGES` otherwise, `AUR_PACKAGES` if it is AUR-only.
   This is the default for GUI apps, fonts, and anything that talks to the
   compositor, dbus, xdg-portals, or the GPU — nixpkgs integrates poorly with
   those on a non-NixOS host.
3. **Not packaged by Arch at all** → `home.packages` in `nix/home.nix`.
   Keep this list small; today it is `google-cloud-sdk` and `transcrypt`.
4. **Configuration** (dotfiles, XDG files, `.desktop` entries, user systemd
   units) → always `nix/home.nix`. pacman cannot express any of this, and it is
   the main reason Nix is here at all.

- **Never** add dev runtimes/languages to `home.packages`.
- After **any** change to `nix/home.nix`:

  ```bash
  ./bin/apply-nix.sh
  ```

  (runs `home-manager switch --flake . && mise install`, clones private repos, sets up joplin symlink, etc.)

- After **any** change to `bin/packages.sh`:

  ```bash
  ./bin/apply-etc.sh   # SYSTEM_PACKAGES + USER_PACKAGES
  ./bin/apply-aur.sh   # AUR_PACKAGES
  ```

### Workflow

- Edit declarative config in `nix/home.nix` and `home/` (never edit generated files in `~/.config/` or Nix store).
- Edit package lists in `bin/packages.sh` (never `pacman -S` a package without declaring it there).
- Run `./bin/apply-*.sh` scripts for full idempotent setup (`apply-nix.sh`, `apply-etc.sh`, `apply-aur.sh`).
- On a fresh machine run `apply-etc.sh` before `apply-nix.sh`, so pacman owns the
  binaries before home-manager builds its profile.

### Key Gotchas

- Mise config lives in `nix/home.nix` — `~/.config/mise/config.toml` is a Nix-managed symlink.
- Fish shell activates mise via `~/.config/fish/config.fish`.
- Preserve exact structure of `tools` map and custom derivations.
- All future tool additions (including opencode skills/agents) must follow the mise pattern unless they require custom Nix packaging.
- Deleting a line from `bin/packages.sh` does **not** uninstall the package.
  `apply-etc.sh` diffs against `~/.local/state/dotfiles/pacman-managed.txt` and
  prints the `pacman -Rns` command for anything you dropped; run it yourself.
- `neovim` is a deliberate exception: it stays on Nix because
  `programs.neovim` supplies `defaultEditor` and the `vi`/`vim` aliases, and it
  is a terminal app with no session integration to get wrong.

---

## Architecture & Philosophy (formerly `NIX.md`)

### Overview

This repository documents and implements the personal Linux environment design. The focus is **clarity, stability, and intentional trade-offs**, not maximal automation. The setup is optimized for **long-term daily use**, not experimentation for its own sake.

```
Hardware
↓
Arch Linux (host OS, minimal)
↓
User Environment
├── Nix   → user-level tools
├── mise  → development runtimes
└── dotfiles / scripts
```

### Goals

- Keep the host OS simple and reliable
- Avoid unnecessary abstraction
- Minimize cognitive overhead
- Make failures easy to debug and recover from
- Separate responsibilities clearly

**Non-Goals:**

- Fully declarative system configuration on Arch
- Managing `/etc` with Nix
- Using Nix to install what Arch already packages well
- "One tool to manage everything"

### 1. Host OS: Arch Linux

Arch Linux is the **base system** and is intentionally kept minimal.

**Why Arch**

- Excellent hardware support
- `pacman` is fast, predictable, and well-designed
- Clear separation between OS and user space
- No hidden automation

Arch is treated as **infrastructure**, not a convenience layer.

**What Lives Here**

- Kernel, firmware, bootloader
- `systemd`
- Networking (`iwd`)
- Bluetooth (`bluez`)
- GPU, sound, input devices

**pacman Policy**

- `pacman` is the default package source, for system *and* user packages
- `paru` handles the AUR; it is bootstrapped by `bin/apply-aur.sh` and must be a
  system package, since it builds AUR packages against system libraries
- Everything installed is declared in `bin/packages.sh`

### 2. User Environment: home-manager

Nix is used strictly in **user space**, and primarily as a *configuration*
manager rather than a package manager.

**Why Nix Here**

- Declarative dotfile linking (`home.file`, `xdg.configFile`)
- Generated `.desktop` entries and user systemd units
- Atomic `switch` with generations to roll back to
- No root access required, no interference with `/etc`

pacman can express none of the above, which is the whole reason Nix is in this
repo.

**Why Nix is *not* the package source**

Arch already packages essentially everything this machine needs — every package
that used to sit in `home.packages` turned out to be in the official repos or
the AUR. Installing them from nixpkgs instead meant:

- A second, duplicated dependency graph (the store had grown to ~7 GB)
- Packages drifting into both `packages.sh` and `home.packages` (`lynis`,
  `pavucontrol-qt` were installed twice)
- The known non-NixOS failure classes: OpenGL (`nixGL`), fontconfig, icon
  themes, and xdg-portal/dbus integration

So `home.packages` is now the exception list, not the rule.

**Explicitly Not Using Nix For**

- System services
- Kernel modules
- User/group management
- `/etc` configuration
- Anything the Arch repos or the AUR already carry

If Nix needs to control `/etc`, the correct answer is **NixOS**, not Arch. That
trade is deliberately declined here: the `/etc` surface is a handful of files,
and it is not worth giving up the AUR and Arch's hardware support for.

### 3. Development Toolchains: mise

All development runtimes are managed with **mise**.

**Why mise**

- Fast startup
- Simple version switching
- Minimal abstraction
- Low coupling with OS and Nix
- Easy recovery when something breaks

**Managed via mise**

- Node.js
- Python
- Deno / Bun
- Claude Code
- Project-specific tool versions

Language runtimes are intentionally **not** managed by Nix to avoid unnecessary complexity.

### 4. System Configuration (`/etc`)

System configuration is handled with simple files and scripts.

**Philosophy**

- `/etc` belongs to the OS
- Configuration is simple and explicit
- Root access is used intentionally
- No attempt at full idempotency
- No declarative system state

**Examples**

Files live under `etc/` in this repository and are copied into place via scripts:

- `/etc/modules-load.d/`
- `/etc/modprobe.d/`
- `/etc/sysctl.d/`
- `/etc/iwd/`
- udev rules

### 5. Automation Scripts

A small set of shell scripts serve as executable documentation.

- `./bin/packages.sh`: the pacman/AUR package lists (sourced, not executed)
- `./bin/apply-nix.sh`: apply Nix and mise config
- `./bin/apply-aur.sh`: bootstrap `paru` and install `AUR_PACKAGES`
- `./bin/apply-etc.sh`: install `SYSTEM_PACKAGES` + `USER_PACKAGES`, apply
  system-wide config, and report packages dropped from the lists (uses sudo)

**Purpose**

- Describe setup steps clearly
- Provide repeatable commands
- Avoid hidden logic or magic
