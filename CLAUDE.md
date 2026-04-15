# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a NixOS flake-based system configuration managing two hosts (`miku`, `mantis`) with Home Manager for user-level configuration. Formatter is `alejandra` (`nix fmt`).

## Commands

Do not run builds, checks, tests, or formatting as part of agent work. Ask before running any commands that change system state.

For reference:
- Format: `nix fmt`
- Build/switch (via `nh`): `nh os switch` / `nh home switch`

## Architecture

```
flake.nix              # Inputs, overlays, nixosConfigurations (miku, mantis)
hosts/
  common/              # Shared NixOS config: HM wiring, overlays, nix settings, nh
  features/
    desktop/           # Host-level desktop features (niri, gaming, ime, greeter, media)
    stylix/            # Stylix theming integration + lib.nix helper
  miku/                # miku-specific: hardware, nvidia, networking, services
  mantis/              # mantis-specific config
home/
  linus/
    home.nix           # Shared base HM config for linus
    miku.nix           # miku profile: feature toggles + host-specific packages/services
    mantis.nix         # mantis profile
  features/
    cli/               # nushell, helix, zellij, jujutsu, direnv, zoxide, yazi, etc.
    desktop/           # HM-level: noctalia-shell, browsers, zed, bolt, idle, niri, ui
pkgs/                  # Custom packages (e.g. helium browser)
overlays/              # additions (pkgs), stable (nixpkgs-stable), modifications, liLib
lib/                   # Custom lib exposed as pkgs.liLib — currently wallhaven.fetch
```

**Overlay wiring:** `outputs.overlays` are applied in `hosts/common/default.nix`. The `liLib` overlay exposes `pkgs.liLib` (e.g. `pkgs.liLib.wallhaven.fetch { id; ext; hash; }`).

**Feature toggles:** Host-level toggles live under `hosts/features` and are set in `hosts/<hostname>/default.nix`. Home Manager feature toggles live under `home/features` and are set in `home/linus/<hostname>.nix` via `features.cli.*` and `features.desktop.*`.

**Home Manager specialArgs:** HM modules receive `inputs`, `outputs`, `stylixLib`, and `osConfig` (the NixOS config) via `extraSpecialArgs` in `hosts/common/default.nix`.

## Style

- Keep modules small and composable; use `features` modules for shared toggles.
- Option names follow the pattern `features.desktop.niri.enable`.

## VCS: Jujutsu (`jj`)

This repo uses `jj` (jujutsu), not plain git. Use `jj` for all VCS actions.

- View current change: `jj show`
- Set commit message: `jj desc -m "<scope>: <subject>"`
- Multi-line messages are always required, even for small changes.

## Commit Message Convention

Format: `<scope>: <subject>` with a required body.

**Scopes:**
- `pkgs`, `overlays`, `infra`, `doc` — canonical fixed scopes; use `overlays` (not `overlay`)
- `home/<module>` (e.g. `home/niri`, `home/cli`) — HM feature module changes
- `hosts/<module>` (e.g. `hosts/media`) — host feature module changes
- `<hostname>` (e.g. `miku`, `mantis`) — entire host system config
- `<hostname>/<user>` (e.g. `miku/linus`) — host + user profile changes
- `<user>` (e.g. `linus`) — user only (rare)
- Multiple hosts → use `infra` scope, list hosts in body
- If `pkgs` or `overlays` is touched, prefer that scope over host/user

**Subject rules:**
- Version updates: `old -> new` (e.g. `pkgs: helium 0.9.4.1 -> helium 0.10.8.1`)
- First pin: `overlays: foot -> foot 1.25.0`; re-pin: `overlays: foot 1.25.0 -> foot 1.26.0`
- `flake.lock` bulk updates (3+ inputs): `flake.lock: update`; body must include verbatim diff from `nix flake update`
- `flake.lock` single notable input: `flake.lock: noctalia v4.6.6 -> v4.7.2-git (e41c78e)` — version + short hash in subject, no body needed
- `flake.lock` 2 inputs: `flake.lock: update <input1> <input2>`; body with diff
- Treewide format runs: subject `infra: format nix files`, body `run nix fmt across repo to normalize formatting`

**Body:** include only what the diff doesn't tell you — motivation, trade-offs, or cross-host scope. Skip it entirely for self-evident changes. When multiple hosts are affected, list them briefly.

```
pkgs: +helium 0.9.2.1

replaces chromium; enables on both hosts
```
