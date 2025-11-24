{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.features.desktop.greeter;
in {
  options.features.desktop.greeter = {
    enable = lib.mkEnableOption "enable greeter";

    type = lib.mkOption {
      type = lib.types.enum ["none" "gdm" "regreet" "tuigreet"];
      default = "gdm";
      description = "Which greeter to use";
    };

    session = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Session for greeter to use with tuigreet (ex. niri-session)";
    };

    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "User to autologin with for type = none";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf (cfg.type == "none") {
      assertions = [
        {
          assertion = cfg.session != null;
          message = "features.desktop.greeter.type = \"none\" requires features.desktop.greeter.session to be set.";
        }
        {
          assertion = cfg.user != null;
          message = "features.desktop.greeter.type = \"none\" requires features.desktop.greeter.user to be set.";
        }
      ];

      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = cfg.session;
            user = cfg.user;
          };
        };
      };
    })

    (lib.mkIf (cfg.type == "gdm") {
      services.displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    })

    (lib.mkIf (cfg.type == "regreet") {
      programs.regreet.enable = true;
    })

    (lib.mkIf (cfg.type == "tuigreet") {
      assertions = [
        {
          assertion = cfg.session != null;
          message = "features.desktop.greeter.type = \"tuigreet\" requires features.desktop.greeter.session to be set.";
        }
      ];

      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${lib.getExe pkgs.tuigreet} --time --cmd ${cfg.session}";
          user = "greeter";
        };
      };
    })
  ]);
}
