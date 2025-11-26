{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.features.desktop.kdePackages;
in {
  options.features.desktop.kdePackages = {
    # TODO extend
    enable = lib.mkEnableOption "enable kdePackages";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs.kdePackages; [
      okular
      dolphin
    ];
  };
}
