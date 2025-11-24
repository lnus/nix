{
  config,
  lib,
  ...
}: let
  cfg = config.features.desktop.idle;
in {
  options.features.desktop.idle = {
    enable = lib.mkEnableOption "enable idle daemon (hypridle)";

    timeout = lib.mkOption {
      type = lib.types.int;
      default = 600;
      description = "Seconds before triggering idle actions";
    };

    lock_cmd = lib.mkOption {
      type = lib.types.str;
      description = "Command to lock the screen";
      example = "hyprlock";
    };

    monitor_off_cmd = lib.mkOption {
      type = lib.types.str;
      description = "Command to turn off monitors";
      example = "hyprctl dispatch dpms off";
    };
  };

  config = {
    services.hypridle = {
      enable = cfg.enable;
      settings = {
        general = {
          lock_cmd = cfg.lock_cmd;
          before_sleep_cmd = cfg.lock_cmd;
        };

        listener = [
          {
            timeout = cfg.timeout;
            on-timeout = cfg.lock_cmd;
          }
          {
            timeout = cfg.timeout + 1;
            on-timeout = cfg.monitor_off_cmd;
          }
        ];
      };
    };
  };
}
