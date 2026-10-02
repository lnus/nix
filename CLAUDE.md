# CLAUDE.md

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
nix fmt                                         # format everything with nixfmt (nixpkgs style)
```

The formatter is set in `flake.nix` itself, not under `modules/`.

## Architecture: the Dendritic Pattern

Everything under `modules/` is auto-imported by `inputs.import-tree ./modules` in
`flake.nix` — **adding a file is enough to wire it in; never add it to a manual
`imports` list.** `import-tree` skips any path containing `/_`, so prefixing a file
or directory with `_` disables it without deleting it (e.g. `_experimental.nix`).

The rules this repo aims for. A few modules still break 1 and 4; fix those rather
than copying them.

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
  parts.nix              # systems list only
  theme.nix              # flake.theme = { colors (Gruvbox base00..base0F); fonts; cursor; }, read as self.theme.<part>
  features/              # one wrapped user program per file/dir: niri/, helix/, nushell/, kitty/, ...
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
and an extra package under `flake.nixosModules.video`. Use the NixOS module's own
`pkgs` arg; only reach for `moduleWithSystem` when you need `self'`/`inputs'`
(`attrs/video` and `obs-studio` still use it for `pkgs` and shouldn't).

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
as `self.theme.colors.base00`..`base0F`, font family names as `self.theme.fonts`
(`sans`/`serif`/`mono`; the packages stay in `features/fonts`), and the cursor as `self.theme.cursor`
(`name`, `size`, `package` — a `pkgs -> drv` function, since the flake attr has no
`pkgs`). Add further parts (e.g. icons) as siblings there once more than one module needs them.
Wrapped programs reference it directly for inline settings (e.g. niri's
`layout.border.active-color = self.theme.colors.base0D`); use a program's own
`themeFile`/built-in theme instead when one already matches.

## Where home-manager things go

There is no home-manager here; the usual shapes map to:

| Home-manager                   | Here                                                                                    |
| ------------------------------ | --------------------------------------------------------------------------------------- |
| `home.packages`                | `runtimePkgs` on the wrapped package, or `environment.systemPackages` on the host       |
| `home.sessionVariables`        | `environment.variables` in a system module                                              |
| `programs.<x>` settings        | Settings passed to that feature's `wrap { settings = ...; }` call                       |
| `home.file` / `xdg.configFile` | Adjacent files in the feature directory, referenced via `path = ./...` in the wrap call |
| `home.shellAliases`            | `environment.shellAliases` in a system module, or config inside the wrapped shell       |

If a program has no `nix-wrapper-modules` wrapper yet, write one with
`wlib.modules.default` (options like `package`, `flags`, `env`, `runtimePkgs`)
following the
[getting-started guide](https://nix-community.github.io/nix-wrapper-modules/md/getting-started.html),
not raw `symlinkJoin` + `wrapProgram` (bolt still does this and shouldn't).

## Gotchas

- **Flakes only see git-tracked files.** A new file under `modules/` won't appear in
  `self.nixosModules`/`self.packages` until it's `git add`ed (check `git status`).
- Binaries in a wrapped config's settings are sometimes named differently from the
  nixpkgs package (e.g. helix references `codebook-lsp`, the package is `codebook`).
  Check the package's `mainProgram` when a wrapped binary can't be found.
- **Wrapped packages ignore the host's `nixpkgs.config`.** They're built from the
  flake's own nixpkgs, so settings like `allowUnfree` or `cudaSupport` on the host
  don't reach them. Set those on the package itself.
- **Put a program's runtime deps on its wrapper** (`runtimePkgs`), so
  `nix run .#<name>` works on its own. helix and nushell still pull theirs in via
  `environment.systemPackages`.

## VCS

Conventional commits, scope optional (usually the feature name):
`feat(helix): add mapfile grammar`, `refactor!: start converting to dendritic pattern`.

| type       | use for                                          |
| ---------- | ------------------------------------------------ |
| `feat`     | new feature/program, or new behaviour in one     |
| `fix`      | something was broken, now it isn't               |
| `refactor` | same result, different structure                 |
| `chore`    | flake input bumps, cleanup, unused args, renames |
| `docs`     | CLAUDE.md, comments                              |

Keep messages concise and lowercase, a quick note to future me. Skip the body if
the subject says it all.

Commit only when asked for that change. Pushing is left to me.
