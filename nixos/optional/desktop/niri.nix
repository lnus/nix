{pkgs, ...}: {
  programs.niri.enable = true;

  services.displayManager.sddm = {
    wayland.enable = true;
    enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];

    config.common.default = "gnome";
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    playerctl
    nautilus
  ];
}
