# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal NixOS flake configuration (single host: `miku`), built on the **Dendritic
Pattern**: `flake-parts` + `import-tree` so that every `.nix` file under `modules/`
is auto-discovered as a top-level flake-parts module. There is no home-manager —
user-facing programs are configured as wrapped derivations via
`inputs.wrapper-modules` instead.

## Commands

```sh
nix build .#<name>                              # build a perSystem package, e.g. .#niri, .#kitty, .#nushell
nix build .#nixosConfigurations.miku --no-link  # build the miku host (NixOS system)
nix build .#nixosConfigurations.miku.config.system.build.vm  # build the VM variant (miku defines virtualisation.vmVariant)
nix flake check --no-build                      # eval-check all outputs
```

There is no `formatter` output wired up yet, so `nix fmt` does not work in this repo.

## Architecture: the Dendritic Pattern

Everything under `modules/` is auto-imported by `inputs.import-tree ./modules` in
`flake.nix` — **adding a file is enough to wire it in; never add it to a manual
`imports` list.** `import-tree` skips any path containing `/_`, so prefixing a file
or directory with `_` disables it without deleting it (e.g. `_experimental.nix`).

Non-negotiable rules that shape every module in this repo:

1. **One feature per file or directory.** The path _is_ the feature name; renaming
   the file renames the feature.
2. **No `enable` options.** Importing a module enables the feature — don't import
   what you don't want.
3. **No `specialArgs`.** Shared values (e.g. the color theme) flow through the
   top-level flake config as `self.<attr>` (e.g. `self.theme`), not injected args.
4. **Composition is explicit only at the host.** `modules/hosts/miku/configuration.nix`
   is the one place that decides which modules apply; everywhere else, discovery is
   automatic.

### Layout

```
modules/
  parts.nix              # systems list + wrapper-modules flakeModule wiring; thin, no config
  theme.nix              # flake.theme = { colors (Gruvbox base00..base0F); cursor; }, read as self.theme.<part>
  features/              # one wrapped user program per file/dir: niri.nix, helix/, nushell/, kitty/, ...
  attrs/                 # compositions of features/system modules, no new binaries (e.g. attrs/video)
  system/                # host-agnostic system config (boot, locale, user, audio, network, drivers) — no perSystem
  hosts/miku/            # default.nix wires nixosSystem; configuration.nix is the host's import list; hardware.nix
```

### Module anatomy

A **feature** module exports two things named identically after the feature:

```nix
# modules/features/kitty/default.nix
{self, inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.kitty = inputs.wrapper-modules.wrappers.kitty.wrap {
      inherit pkgs;
      settings = { background = self.theme.colors.base00; ... };
    };
  };
  flake.nixosModules.kitty = {pkgs, ...}: {
    environment.systemPackages = [self.packages.${pkgs.stdenv.hostPlatform.system}.kitty];
  };
}
```

A host opts in with one import: `self.nixosModules.kitty` in its `configuration.nix`.
Prefer a directory (`nushell/`, `helix/`) over a single file when the wrap call
references sibling files by path (e.g. `nushell/config.nu`, `nushell/env.nu`).

A **system** module (`modules/system/**`) only exports `flake.nixosModules.<name>` —
no `perSystem`, no wrapped binary, never builds a standalone output.

An **attrs** module (`modules/attrs/**`) composes other `flake.nixosModules` under one
name without defining new binaries — e.g. `attrs/video` bundles `obs-studio`, `mpv`,
and an extra package under `flake.nixosModules.video`. When a composed module needs
`self'`/`pkgs` from a specific system, wrap it in `moduleWithSystem` (see
`modules/attrs/video/default.nix`) rather than threading `specialArgs`.

A **host** (`modules/hosts/<name>/`) has three files: `default.nix` (calls
`inputs.nixpkgs.lib.nixosSystem { modules = [self.nixosModules.<name>Configuration]; }`),
`configuration.nix` (the actual `imports = with self.nixosModules; [...]` list — the
only place host composition is decided), and `hardware.nix`.

### Naming

| Thing                | Convention                  | Example                    |
| -------------------- | --------------------------- | -------------------------- |
| Wrapped package      | `<featureName>` (no prefix) | `perSystem.packages.kitty` |
| NixOS module         | `<featureName>`             | `flake.nixosModules.kitty` |
| Hardware module      | `<hostname>Hardware`        | `mikuHardware`             |
| Configuration module | `<hostname>Configuration`   | `mikuConfiguration`        |
| Disabled file/dir    | `_`-prefix                  | `_experimental.nix`        |

### Theme

`modules/theme.nix` exposes the shared look under `self.theme`: the Gruvbox palette
as `self.theme.colors.base00`..`base0F`, and the cursor as `self.theme.cursor`
(`name`, `size`, `package` — a `pkgs -> drv` function, since the flake attr has no
`pkgs`). Add further parts (icons, fonts, ...) as siblings there.
Wrapped programs reference it directly for inline settings (e.g. niri's
`layout.border.active-color = self.theme.colors.base0D`); use a program's own
`themeFile`/built-in theme instead when one already matches.

## Working with home-manager-shaped config (porting from `old/`)

`old/` is git-ignored, kept only for reference — never edit it, copy _out_ of it.
There is no home-manager equivalent here; map old `home-manager` shapes as:

| Home-manager                   | Here                                                                                    |
| ------------------------------ | --------------------------------------------------------------------------------------- |
| `home.packages`                | `environment.systemPackages` on the host, or `runtimeInputs` on the wrapped package     |
| `home.sessionVariables`        | `environment.variables` in a system module                                              |
| `programs.<x>` settings        | Settings passed to that feature's `wrap { settings = ...; }` call                       |
| `home.file` / `xdg.configFile` | Adjacent files in the feature directory, referenced via `path = ./...` in the wrap call |
| `home.shellAliases`            | `environment.shellAliases` in a system module, or config inside the wrapped shell       |

If a program has no `nix-wrapper-modules` wrapper yet, you're writing a new wrapper
module upstream rather than calling `wrap { settings = ...; }` on an existing one —
follow the current
[getting-started guide](https://nix-community.github.io/nix-wrapper-modules/md/getting-started.html)
(the module system there is `wlib.modules.default`/`makeWrapper`/`symlinkScript`
with options like `package`, `flags`, `env`, `runtimePkgs` — not raw
`pkgs.symlinkJoin`, which is what an older version of this doc said).

## Gotchas

- **Flakes only see git-tracked files.** A new file under `modules/` won't appear in
  `self.nixosModules`/`self.packages` until it's `git add`ed (check `git status`).
- Binaries in a wrapped config's settings are sometimes named differently from the
  nixpkgs package (e.g. helix references `codebook-lsp`, the package is `codebook`).
  Check the package's `mainProgram` when a wrapped binary can't be found.

## VCS

### Commit messages

Lowercase `<scope>: <subject>` style, matching `git log` (e.g. `nushell: add lazygit
alias`, `niri: add runelite opacity settings`). A `!` after the scope marks a
breaking change (e.g. `infra!: start converting to dendritic pattern`). Keep the
body, if any, to one or two sentences of intent — don't recount the diff file by file.

### Commits and pushes

Never commit without being asked to for that specific change, even if a commit
message has already been agreed on. Never push, under any circumstances, even if
explicitly told to — always leave that to the user.
