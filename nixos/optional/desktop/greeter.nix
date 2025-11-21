{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.my.greeter;
in {
  options.my.greeter = {
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

  config = lib.mkMerge [
    (lib.mkIf (cfg.type == "none") {
      assertions = [
        {
          assertion = cfg.session != null;
          message = "my.greeter.type = \"none\" requires my.greeter.session to be set.";
        }
        {
          assertion = cfg.user != null;
          message = "my.greeter.type = \"none\" requires my.greeter.user to be set.";
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
          message = "my.greeter.type = \"tuigreet\" requires my.greeter.session to be set.";
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
  ];
}
