# Working in this repo

Personal NixOS config. Work in progress. Rewritten to the **Dendritic Pattern**.

## The pattern (read this first)

Everything lives under `modules/` and is a **flake-parts** module.

- `flake.nix` uses `inputs.flake-parts.lib.mkFlake` with `inputs.import-tree ./modules`,
  so **every `.nix` file under `modules/` is automatically imported**. Adding a file is
  enough; do not wire it into any `imports` list. (`import-tree` skips paths containing `/_`
  — prefix a file/dir with `_` to disable it.)
- Each module contributes to the flake via the standard flake-parts attrs:
  `flake.nixosModules.<name>`, `flake.nixosConfigurations.<name>`, `perSystem.packages.<name>`, etc.
- `modules/parts.nix` sets the supported `systems` list.

### Shell/CLI/editors: nix-wrapper-modules, NOT home-manager

User-facing programs (editor, shell, bar, …) are configured as **wrapped derivations** via
`inputs.wrapper-modules.wrappers.<program>.wrap { inherit pkgs; settings = …; }`, exposed as
`perSystem.packages.my<Thing>`. The same call also yields a `self.nixosModules.<name>` you can
import on a host to install the wrapped binary + any runtime helpers (LSPs, formatters).

Reference for how the wrapper exposes options: the upstream
`wrapperModules/<letter>/<program>/module.nix`, e.g. `…/h/helix/module.nix` defines
`settings`, `languages`, `themes`, `ignores`, `extraSettings` (all TOML-rendered into the
wrapped binary's XDG_CONFIG_HOME). When porting an old home-manager `programs.<x>` block,
map its keys onto the matching `wrap { … }` settings and move LSP/formatter packages into the
host-config's `environment.systemPackages` (or the matching NixOS module).

### Layout

```
modules/
  parts.nix              # flake-parts systems list
  features/              # cross-host features, each one file (or dir)
    niri.nix  helix.nix  noctalia/
  hosts/
    miku/                # one host dir: default.nix wires the nixosSystem,
                         # configuration.nix is the real config, hardware.nix is HW
```

To add a feature: drop a `modules/features/<name>.nix` exporting
`flake.nixosModules.<name>` (+ optional `perSystem.packages.my<Name>`).
To use it on a host, add `self.nixosModules.<name>` to the host's `imports`.

## Gotchas that cost time before

- **Flakes only see git-tracked files.** A newly created `modules/features/foo.nix` won't
  show up in `self.nixosModules` until it's tracked in the git index. This repo uses
  **jujutsu (`jj`)** as the primary VCS (see `.jj/`); jj auto-tracks new files in the working
  copy and, in its colocated git repo, syncs them into git's index — so a `jj st` (or `jj log`)
  that reflects the file is enough, no explicit add needed. With plain `git` you'd `git add` it.
  If a new module appears missing during eval/build, confirm it's tracked (`jj st` / `git st`)
  and re-check.
- **`nix flake check` fails on `nvidia-x11` unfree licence** — this is pre-existing noise
  from `mikuHardware`, unrelated to most changes. Set `NIXPKGS_ALLOW_UNFREE=1` and pass
  `--impure` if you actually need the check to pass, otherwise ignore that specific error.
- **`old/` is git-ignored** (kept for reference only). Don't edit it; copy *out* of it into
  the new structure when porting. Note also `home.packages`, `home.sessionVariables`, and
  `programs.<x>` blocks from the home-manager layout have no direct equivalent — map them to
  `environment.systemPackages` / `environment.variables` on the NixOS host, or into the
  wrapped package's settings.
- **Runner binaries named differently from the config key.** The helix config references
  `codebook-lsp`; the nixpkgs package is `codebook` (its `mainProgram`). Set `e = "hx"` /
  `EDITOR=hx`-style aliases via `environment.variables` or shell config, not `home.shellAliases`.

## Commit messages

Write `jj` commit descriptions in the lowercase `<scope>: <subject>` style
already used in `jj log` (e.g. `features: add helix and nushell wrapper-modules`,
`miku: add sunshine`, `infra!: start converting to dendritic pattern`). The `!`
suffix marks breaking changes.

Keep the body to a **one- or two-sentence broad summary** of the change's intent,
written to be read alongside the diff (which already shows the file-level detail).
Do **not** recount file by file or restate the diff.

```sh
jj show           # see the diff you're describing
jj log            # match the existing scope/subject style
jj desc -m '...'  # set the description; -m may be repeated for subject + body
```

## Commands

```sh
nix build .#myHelix          # build a wrapped perSystem package (system-suffixed path
                             # like .#x86_64-linux.myHelix also works)
nix build .#nixosConfigurations.miku --no-link   # build the VM host
nix flake check --no-build    # see the gotchas above re: nvidia unfree noise
nix fmt   # formatter (alejandra / nixpkgs-fmt depending on flake)
```

Whenever you add a file under `modules/`, make sure it's tracked (under jj this happens
automatically; `jj st` to confirm) so flake discovery sees it.