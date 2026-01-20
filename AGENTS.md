# Repository Guidelines

## Project Structure & Module Organization

- `flake.nix` defines inputs, formatter, overlays, and host outputs.
- `hosts/` contains NixOS host configurations (`miku`, `mantis`) plus shared modules in `hosts/common` and `hosts/features`.
- `home/` contains Home Manager modules and feature sets (CLI/desktop) plus user profiles (e.g., `home/linus`).
- `pkgs/` holds custom packages; `overlays/` hosts overlay definitions.

## Build, Test, and Development Commands

- `nix fmt` formats all Nix files with Alejandra (configured in `flake.nix`).
- `nix flake check` evaluates the flake and catches module errors early.
- `nixos-rebuild build --flake .#miku` builds the `miku` system without switching.
- Avoid `switch` inside AI agents; use `build` for validation and `nix flake check` for a fast repo-wide check.
- `nixos-rebuild switch --flake .#mantis` applies the `mantis` system locally (manual use only).
- `nh os build .#miku` is a shorter alternative if `nh` is installed.

## Coding Style & Naming Conventions

- Follow standard Nix formatting; use `nix fmt` before commits.
- Keep modules small and composable; prefer `features` modules for shared toggles.
- Name host modules after the machine (`hosts/miku`, `hosts/mantis`).
- Use clear option names like `features.desktop.niri.enable`.

## Testing Guidelines

- No automated test suite is defined. Validate by building the target host with:
  - `nixos-rebuild build --flake .#miku`
- Prefer `nix flake check` for a quick, repo-wide evaluation pass.

## Commit & Pull Request Guidelines

- Prefer `jj` for VCS actions; use `jj desc -m "<scope>: <subject>"` to set commit messages.
- To see information about current change, use `jj show`.
- Commit messages use domain-based scopes and short subjects; keep scopes stable over time.
  - Prefer brief, casual phrasing; lowercase is fine and longer explanations are usually overkill.
  - Examples: `home: add ai cli tools`, `host: update system fonts`, `pkgs: bump ripgrep`
- Scope set should stay small (e.g., `host`, `home`, `pkgs`, `overlay`, `doc`, `infra`); only add new scopes if they stay broadly useful.
- For mixed changes, pick the highest-impact scope and mention secondary areas in the body.
- Body format: one short summary line, then host bullets when relevant.
  - Use host bullets when more than one host or more than one change is involved.
  - Use single-line `host: change` when there is only one change for that host.
  - Prefer per-host bullet lists for multiple changes; avoid comma-separated host lines.
  - Example:
    - Summary: `enable media services`
    - `miku:`
      - enable jellyfin
      - enable navidrome
    - `mantis: tweak greeter`
- PRs should include a brief summary, affected hosts, and any required rebuild steps.

## Configuration Tips

- Host feature toggles live under `hosts/features`; shared Home Manager features live under `home/features`.
- When adding new inputs or overlays, update `flake.nix` and document usage in the relevant module.
