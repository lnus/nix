# TODO: use niri flake
# https://github.com/sodiboo/niri-flake
{
  config,
  pkgs,
  ...
}: let
  colors =
    if (config.lib.stylix.colors or null) != null
    then config.lib.stylix.colors
    else {
      base00 = "1e1e2e"; # fallback backdrop
      base01 = "313244"; # fallback inactive
      base03 = "45475a"; # fallback shadow
      base08 = "f38ba8"; # fallback urgent
      base0D = "89b4fa"; # fallback active
    };
in {
  home.file.".config/niri/config.kdl".text = builtins.readFile (
    pkgs.substitute {
      src = ./niri.kdl;
      substitutions = [
        "--subst-var-by"
        "backdrop_color"
        "#${colors.base00}"

        "--subst-var-by"
        "shadow_color"
        "#${colors.base03}50"

        "--subst-var-by"
        "active_color"
        "#${colors.base0D}"

        "--subst-var-by"
        "inactive_color"
        "#${colors.base01}"

        "--subst-var-by"
        "urgent_color"
        "#${colors.base08}"
      ];
    }
  );

  # FIX wl-clip, pavucontrol, and nm-applet should not be here
  home.packages = with pkgs; [
    wl-clipboard
    networkmanagerapplet
    pavucontrol
  ];
}
