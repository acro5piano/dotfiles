## Quick Reference

### Nix + mise (critical)

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

### Workflow

- Edit declarative config in `nix/home.nix` and `home/` (never edit generated files in `~/.config/` or Nix store).
- Run `./bin/apply-*.sh` scripts for full idempotent setup (`apply-nix.sh`, `apply-etc.sh`, `apply-aur.sh`).

### Key Gotchas

- Mise config lives in `nix/home.nix:131` — `~/.config/mise/config.toml` is a Nix-managed symlink.
- Fish shell activates mise via `~/.config/fish/config.fish`.
- Preserve exact structure of `tools` map and custom derivations.
- All future tool additions (including opencode skills/agents) must follow the mise pattern unless they require custom Nix packaging.

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
- Replacing pacman entirely
- Using AUR helpers
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

- `pacman` is used only for what the OS needs to function
- No AUR helpers (`yay`, `paru`, etc.)
- No user tooling unless required for boot or hardware

### 2. User-Level Packages: Nix

Nix is used strictly in **user space**.

**Why Nix Here**

- Replaces AUR usage cleanly
- No root access required
- No interference with `/etc`
- Predictable installs
- Easy to remove or reset

Nix is **not** used to manage the system itself.

**Examples**

- CLI tools: `fzf`, `ripgrep`, `fd`, `bat`, `jq`
- Editors: `neovim`
- Other daily tools that do not require root and should not touch system state

**Explicitly Not Using Nix For**

- System services
- Kernel modules
- User/group management
- `/etc` configuration

If Nix needs to control `/etc`, the correct answer is **NixOS**, not Arch.

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

- `./bin/apply-nix.sh`: apply Nix and mise config
- `./bin/apply-aur.sh`: apply AUR package installation
- `./bin/apply-etc.sh`: apply system-wide config and pacman (uses sudo)

**Purpose**

- Describe setup steps clearly
- Provide repeatable commands
- Avoid hidden logic or magic
