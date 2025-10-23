{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
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
