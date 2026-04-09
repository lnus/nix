{pkgs, ...}: {
  wallhaven = import ./wallhaven.nix {inherit pkgs;};
}
