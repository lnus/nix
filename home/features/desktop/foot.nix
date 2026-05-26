{
  config,
  lib,
  ...
}: let
  cfg = config.features.desktop.foot;
in {
  options.features.desktop.foot = {
    enable = lib.mkEnableOption "enable foot terminal emulator";
    server = lib.mkEnableOption "start systemd server";
  };

  config = lib.mkIf cfg.enable {
    programs.foot = {
      enable = true;
      server.enable = cfg.server;

      settings = {
        main = {
          font = "monospace:size=11";
          include = "~/.config/foot/themes/noctalia";
        };

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
  };
}
