{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.features.desktop.browsers.helium;
in {
  options.features.desktop.browsers.helium.enable = lib.mkEnableOption "enable helium browser";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      helium
    ];
  };
}
