# TODO: use niri flake
# https://github.com/sodiboo/niri-flake
{
  config,
  pkgs,
  osConfig ? {},
  lib,
  stylixLib,
  ...
}: {
  config = lib.mkIf (osConfig.features.desktop.niri.enable or false) {
    home.file.".config/niri/config.kdl".text = let
      colors = stylixLib.mkBase16 config;
    in
      builtins.readFile (
        pkgs.substitute {
          src = ./niri.kdl;
          substitutions = [
            "--subst-var-by"
            "backdrop_color"
            colors.hex.base00

            "--subst-var-by"
            "shadow_color"
            "${colors.hex.base00}50"

            "--subst-var-by"
            "active_color"
            colors.hex.base04

            "--subst-var-by"
            "inactive_color"
            colors.hex.base00

            "--subst-var-by"
            "urgent_color"
            colors.hex.base0F
          ];
        }
      );

    # FIX wl-clip, pavucontrol, and nm-applet should not be here
    home.packages = with pkgs; [
      wl-clipboard
      networkmanagerapplet
      pavucontrol
    ];
  };
}
