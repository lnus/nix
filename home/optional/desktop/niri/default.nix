{
  config,
  pkgs,
  ...
}: {
  # FIX: more dynamic stylix stuff, all of it is very
  # interlinked right now. will break if stylix is not
  # enabled for a user
  home.file.".config/niri/config.kdl".text = builtins.readFile (
    pkgs.substitute {
      src = ./niri.kdl;
      substitutions = [
        "--subst-var-by"
        "backdrop_color"
        "#${config.lib.stylix.colors.base00}"

        "--subst-var-by"
        "shadow_color"
        "#${config.lib.stylix.colors.base03}50"

        "--subst-var-by"
        "active_color"
        "#${config.lib.stylix.colors.base0D}"

        "--subst-var-by"
        "inactive_color"
        "#${config.lib.stylix.colors.base01}"

        "--subst-var-by"
        "urgent_color"
        "#${config.lib.stylix.colors.base08}"
      ];
    }
  );

  home.packages = with pkgs; [
    firefox
    fuzzel
    mako
    waybar
    swaylock
    swayidle
    grim
    slurp
    wl-clipboard
    networkmanagerapplet
    pavucontrol
  ];
}
