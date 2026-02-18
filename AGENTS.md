# Repository Guidelines

## Project Structure & Module Organization

- `flake.nix` defines inputs, formatter, overlays, and host outputs.
- `hosts/` contains NixOS host configurations (`miku`, `mantis`) plus shared modules in `hosts/common` and `hosts/features`.
- `home/` contains Home Manager modules and feature sets (CLI/desktop) plus user profiles (e.g., `home/linus`).
- `pkgs/` holds custom packages; `overlays/` hosts overlay definitions.

## Build, Test, and Development Commands

- Do not run builds, checks, tests, or formatting as part of agent work.
- Ask before running any commands that change system state.

## Coding Style & Naming Conventions

- Follow standard Nix formatting (Alejandra via `nix fmt`).
- Keep modules small and composable; prefer `features` modules for shared toggles.
- Name host modules after the machine (`hosts/miku`, `hosts/mantis`).
- Use clear option names like `features.desktop.niri.enable`.

## Testing Guidelines

- No automated test suite is defined.
- Validation is handled manually by the user.

## Commit & Pull Request Guidelines

- Prefer `jj` for VCS actions; use `jj desc -m "<scope>: <subject>"` to set commit messages.
- To see information about current change, use `jj show`.
- Commit messages: `<scope>: <subject>` with domain-based scopes; keep scopes stable over time.
  - Always use multi-line commit messages (subject + body), even for small changes.
  - Prefer brief, concrete phrasing; lowercase is fine; avoid parenthetical notes in the subject.
  - Avoid vague verbs like "tweak"; state what changed. Put rationale in the body.
  - Examples: `flake.lock: update noctalia`, `nixvim: update treesitter grammars`, `linux-xanmod: 6.18.8 -> 6.18.10`
- Scope set should stay small (e.g., `pkgs`, `overlay`, `doc`, `infra`), but module/host namespaces are allowed.
  - Host/user scoping:
    - Single host + single user: `<hostname>/<user>` (e.g., `mantis/linus`).
    - Entire host system: `<hostname>` (e.g., `mantis`).
    - Single user only (rare): `<user>` (e.g., `linus`).
  - Multiple hosts: use `infra` as the scope and list hosts in the body.
  - Examples: `nixos/nvidia`, `mantis/linus`, `mantis`, `linus`, `infra`.
- Version updates: use `old -> new` in the subject.
- Lockfile updates: subject must be `flake.lock: update <inputs>` on fewer than 3 inputs updated, else, `flake.lock: update`.
  - Body is required and must include a diff of input updates, ideally verbatim from `nix flake update`.
  - Example body:
    - Updated input 'noctalia':
      - github:noctalia-dev/noctalia-shell/a6283d2962cde6a397da5f197dcceaa586505dd3?narHash=sha256-DgxfTDv3swv/bc2J2AxINf5XpVHjVlycQj17x5vjGHA%3D' (2026-02-06)
      - → 'github:noctalia-dev/noctalia-shell/cb77a08243a5956ebed2d0960f161d0644295f83?narHash=sha256-li7Pd9wOtiYuFq%2Bu%2BlMbbaoNySBz7fVTeYTxOSLcBTI%3D' (2026-02-18)
- For mixed changes, pick the highest-impact scope and mention secondary areas in the body.
  - If `pkgs` or `overlay` is touched, prefer that scope over host/user scopes.
  - Example: `pkgs: +helium 0.9.2.1` (body lists host/user enablement).
- Body format: one short summary line, then host bullets when relevant.
  - Use host bullets when more than one host or more than one change is involved.
  - Use single-line `host: change` when there is only one change for that host.
  - Prefer per-host bullet lists for multiple changes; avoid comma-separated host lines.
  - Example:
    - Subject: `pkgs: +helium 0.9.2.1`
    - Summary: `add helium package + hm feature; update agent commit guidance`
    - `miku/linus:`
      - enable helium browser
    - `mantis/linus:`
      - enable helium browser
- PRs should include a brief summary, affected hosts, and any required rebuild steps.

## Configuration Tips

- Host feature toggles live under `hosts/features`; shared Home Manager features live under `home/features`.
- When adding new inputs or overlays, update `flake.nix` and document usage in the relevant module.
