{lib, ...}: {
  flake.nixosModules.steam = {pkgs, ...}: {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;

    hardware.graphics.enable32Bit = lib.mkDefault true;

    environment.systemPackages = with pkgs; [
      mangohud
    ];
  };
}
