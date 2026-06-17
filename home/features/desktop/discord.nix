{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.features.desktop.discord;
in {
  options.features.desktop.discord = {
    enable = lib.mkEnableOption "enable discord";
    vesktop = lib.mkEnableOption "use vesktop over modified discord";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf (!cfg.vesktop) {
      programs.discord = {
        enable = true;

        package = pkgs.discord.override {
          withOpenASAR = true;
          withVencord = true;
        };

        settings = {
          SKIP_HOST_UPDATE = true;
        };
      };
    })

    (lib.mkIf (cfg.vesktop) {
      programs.vesktop.enable = true;

      # Prefer Vesktop for discord:// URLs.
      # xdg.mimeApps.defaultApplications."x-scheme-handler/discord" = "vesktop.desktop";
    })
  ]);
}
