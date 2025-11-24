# TODO: extract into lib properly. messy!
# slop but werks (if it breaks it's not my fault i promise)
{pkgs}: let
  fallbackColors = {
    base00 = "#0f0b05";
    base01 = "#231b0e";
    base02 = "#2a2012";
    base03 = "#57462c";
    base04 = "#a88c62";
    base05 = "#c3a983";
    base06 = "#dec8a7";
    base07 = "#231b0e";
    base08 = "#b07878";
    base09 = "#c4956a";
    base0A = "#c9b87a";
    base0B = "#a4a878";
    base0C = "#98a090";
    base0D = "#a0988f";
    base0E = "#a89080";
    base0F = "#876e48";
  };

  stripHash = color:
    if builtins.hasPrefix "#" color
    then builtins.substring 1 (builtins.stringLength color - 1) color
    else color;

  mkBase16 = cfg: let
    isStylix = cfg ? stylix && cfg.stylix.enable;

    # "RRGGBB" (no #)
    raw =
      if isStylix
      then cfg.lib.stylix.colors
      else builtins.mapAttrs (_: c: stripHash c) fallbackColors;

    # "#RRGGBB"
    hex =
      builtins.mapAttrs (_: c: "#${raw.${_}}") raw;
  in {
    inherit raw hex;

    # convenience: c.base08 → "RRGGBB"
    __functor = _: raw;
  };

  fallbackFont = {
    monospace = {
      package = pkgs.nerd-fonts.go-mono;
      name = "GoMono Nerd Font";
    };
  };
in {
  mkBase16 = mkBase16;

  isStylix = cfg:
    cfg ? stylix && cfg.stylix.enable;

  getFont = cfg:
    if cfg ? stylix && cfg.stylix.enable
    then cfg.stylix.fonts.monospace
    else fallbackFont.monospace;
}
