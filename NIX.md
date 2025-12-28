# Arch + Nix + mise Linux Environment

This repository documents and implements my personal Linux environment design.

The focus is **clarity, stability, and intentional trade-offs**, not maximal automation.

This is both:

- a working setup
- a record of _why_ these choices were made

---

## Goals

- Keep the host OS simple and reliable
- Avoid unnecessary abstraction
- Minimize cognitive overhead
- Make failures easy to debug and recover from
- Separate responsibilities clearly

This setup is optimized for **long-term daily use**, not experimentation for its own sake.

---

## Non-Goals

- Fully declarative system configuration on Arch
- Managing `/etc` with Nix
- Replacing pacman entirely
- Using AUR helpers
- One tool to manage everything

---

## High-Level Design

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

Each layer has a **single responsibility**.

---

## 1. Host OS: Arch Linux

Arch Linux is the **base system** and is intentionally kept minimal.

### Why Arch

- Excellent hardware support
- pacman is fast, predictable, and well-designed
- Clear separation between OS and user space
- No hidden automation

Arch is treated as **infrastructure**, not a convenience layer.

### What Lives Here

- Kernel, firmware, bootloader
- systemd
- Networking (`iwd`)
- Bluetooth (`bluez`)
- GPU, sound, input devices

### pacman Policy

- `pacman` is used **only** for what the OS needs to function
- No AUR helpers (`yay`, `paru`, etc.)
- No user tooling unless required for boot or hardware

---

## 2. User-Level Packages: Nix

Nix is used strictly in **user space**.

### Why Nix Here

- Replaces AUR usage cleanly
- No root access required
- No interference with `/etc`
- Predictable installs
- Easy to remove or reset

Nix is **not** used to manage the system itself.

### Examples

- CLI tools:
  - `fzf`
  - `ripgrep`
  - `fd`
  - `bat`
  - `jq`
- Editors:
  - `neovim`
- Other daily tools that:
  - do not require root
  - should not touch system state

### Explicitly Not Using Nix For

- System services
- Kernel modules
- User/group management
- `/etc` configuration

If Nix needs to control `/etc`, the correct answer is **NixOS**, not Arch.

---

## 3. Development Toolchains: mise

All development runtimes are managed with **mise**.

### Why mise

- Fast startup
- Simple version switching
- Minimal abstraction
- Low coupling with OS and Nix
- Easy recovery when something breaks

### Managed via mise

- Node.js
- Python
- Deno / Bun
- Claude Code
- Project-specific tool versions

Language runtimes are intentionally **not managed by Nix**.

---

## 4. System Configuration (`/etc`)

System configuration is handled with **simple files and scripts**.

### Philosophy

- `/etc` belongs to the OS
- Configuration is simple and explicit
- Root access is used intentionally
- No attempt at full idempotency
- No declarative system state

### Examples

- `/etc/modules-load.d/`
- `/etc/modprobe.d/`
- `/etc/sysctl.d/`
- `/etc/iwd/`
- udev rules

Files live under `etc/` in this repository and are copied into place via scripts.

This is deliberate.

> If configuration is simple enough to understand,
> it is simple enough to apply manually.

---

## 5. Automation: shellscript

A simple shellscript is used as **executable documentation**.

### Purpose

- Describe setup steps clearly
- Provide repeatable commands
- Avoid hidden logic or magic

### Typical Targets

- `scripts/arch` – minimal host setup
- `scripts/nix` – install user tools via Nix
- `scripts/mise` – install development runtimes
- `scripts/etc` – copy system configuration files

### Guiding Rules

- Readable first, executable second
- Explicit output
- Failures are visible
- Easy to modify

---

## 6. Dotfiles

Dotfiles are managed with **simple placement**.

- Symlinks or direct copies
- No heavy templating unless required
- No complex dependency on tooling

The goal is always:

- know where a file lives
- know why it exists
- know how to remove it

---

## What This Setup Avoids (Intentionally)

- AUR helpers
- System-wide Nix on Arch
- Managing `/etc` declaratively
- Mixing root and user concerns
- Over-engineered “one tool to rule them all” solutions

These are conscious trade-offs, not limitations.

---

## Rationale

This environment favors:

- Predictability over cleverness
- Explicit steps over abstraction
- Isolation over partial integration
- Understandability over novelty

It is designed so that:

- breakage is localized
- recovery is obvious
- decisions are explainable months later

---

## Future Direction

If full declarative system management is needed,
it will be done via **NixOS in a virtual machine**.

Arch remains the stable host.
NixOS remains a fully controlled environment.

Mixing the two at the system level is intentionally avoided.

---

## Summary

| Layer      | Tool        | Responsibility                    |
| ---------- | ----------- | --------------------------------- |
| OS         | Arch        | Hardware & base system            |
| User tools | Nix         | CLI tools & editors               |
| Dev tools  | mise        | Language runtimes & dev utilities |
| System cfg | Scripts     | `/etc` placement                  |
| Automation | shellscript | Human-readable procedures         |

This separation is intentional and stable.
