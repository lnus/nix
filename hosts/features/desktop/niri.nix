{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.features.desktop.niri;
in {
  options.features.desktop.niri.enable = lib.mkEnableOption "enable niri compositor";

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;

    # This is pre-set in nixpkgs
    # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/wayland/niri.nix
    # But I like being able to change
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];

      config.common.default = "gnome";
    };

    # TODO:
    # - xwayland-satellite as systemd
    # - file managers should be handled elsewhere
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      nautilus
    ];
  };
}
