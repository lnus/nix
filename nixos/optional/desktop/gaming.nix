{pkgs, ...}: {
  programs.steam = {
    enable = true;

    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    gamescope
    itch
    lutris
    wine
    bolt-launcher
  ];
}
