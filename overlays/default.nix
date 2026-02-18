# See https://code.m3ta.dev/m3tam3re/nixcfg/src/branch/video18/overlays/default.nix for reference
{...}: {
  # NOTE: Leaving this as default, might change to `additions` later.
  default = final: _prev: import ../pkgs {pkgs = final;};
}
