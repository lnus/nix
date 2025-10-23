{pkgs, ...}: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.appindicator
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
  ];
}
