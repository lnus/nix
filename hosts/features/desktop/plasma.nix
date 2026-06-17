{
  config,
  lib,
  ...
}: let
  cfg = config.features.desktop.plasma;
in {
  options.features.desktop.plasma.enable = lib.mkEnableOption "enable plasma6 desktop environment";

  config = lib.mkIf cfg.enable {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.plasma-login-manager.enable = true;
    };
  };
}
