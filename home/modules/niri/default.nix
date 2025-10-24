{pkgs, ...}: {
  # FIX: use stylix probably
  # yanked from old hm config, just using random colors now
  # https://www.nordtheme.com/
  home.file.".config/niri/config.kdl".text = builtins.readFile (
    pkgs.substitute {
      src = ./niri.kdl;
      substitutions = [
        "--subst-var-by"
        "backdrop_color"
        "#2e3440"

        "--subst-var-by"
        "shadow_color"
        "#2e344050"

        "--subst-var-by"
        "active_color"
        "#8fbcbb"

        "--subst-var-by"
        "inactive_color"
        "#4c566a"

        "--subst-var-by"
        "urgent_color"
        "#b48ead"
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
