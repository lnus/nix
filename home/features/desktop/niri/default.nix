{
  pkgs,
  osConfig ? {},
  lib,
  ...
}: {
  config = lib.mkIf (osConfig.features.desktop.niri.enable or false) {
    home.file.".config/niri/config.kdl".source = ./niri.kdl;

    # FIX wl-clip, pavucontrol, and nm-applet should not be here
    home.packages = with pkgs; [
      wl-clipboard
      networkmanagerapplet
      pavucontrol
    ];
  };
}
