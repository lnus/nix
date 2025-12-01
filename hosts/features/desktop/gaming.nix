{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.features.desktop.gaming;
in {
  options.features.desktop.gaming = {
    enable = lib.mkEnableOption "gaming support";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    programs.gamemode.enable = true;
    programs.steam.gamescopeSession.enable = true;

    environment.systemPackages = with pkgs; [
      mangohud
    ];
  };
}
