{
  pkgs,
  lib,
  ...
}: {
  programs.niri.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --time --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # This is set in nixpkgs (along with gnome-keyring)
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/wayland/niri.nix
  #
  # ...buuuuut...
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];

    config.common.default = "gnome";
  };

  # TEMP
  # - TODO: xwayland-satellite as systemd
  # - TODO: file managers should be handled elsewhere
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    nautilus
  ];
}
