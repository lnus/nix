{pkgs, ...}: {
  programs.niri.enable = true;

  services.displayManager.sddm = {
    wayland.enable = true;
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    playerctl
  ];
}
