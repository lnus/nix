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

## VCS: Jujutsu (`jj`)

This repo uses `jj` (jujutsu), not plain git. Use `jj` for all VCS actions.

- View current change: `jj show`
- Set commit message: `jj desc -m "<scope>: <subject>"`
- Multi-line messages are always required, even for small changes.

## Commit Message Convention

Format: `<scope>: <subject>` with a required body.

**Scopes:**
- `pkgs`, `overlays`, `infra`, `doc` — canonical fixed scopes
- `<hostname>` (e.g. `miku`, `mantis`) — entire host
- `<hostname>/<user>` (e.g. `miku/linus`) — host + user
- `<user>` (e.g. `linus`) — user only (rare)
- Multiple hosts → use `infra` scope, list hosts in body
- If `pkgs` or `overlays` is touched, prefer that scope over host/user

**Subject rules:**
- Version updates: `old -> new` (e.g. `pkgs: helium 0.9.4.1 -> helium 0.10.8.1`)
- First pin: `overlays: foot -> foot 1.25.0`; re-pin: `overlays: foot 1.25.0 -> foot 1.26.0`
- `flake.lock` updates: `flake.lock: update <inputs>` (or just `flake.lock: update` for 3+); body must include verbatim diff from `nix flake update`
- Treewide format runs: subject `infra: format nix files`, body `run nix fmt across repo to normalize formatting`

**Body format:** one short summary line, then host bullets when more than one change or host is involved.

```
pkgs: +helium 0.9.2.1

add helium package + hm feature
miku/linus:
  - enable helium browser
mantis/linus:
  - enable helium browser
```
