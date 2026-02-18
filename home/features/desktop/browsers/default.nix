{ lib, pkgs, config, ... }: let
  cfg = config.features.desktop.browsers;
  desktopFileFor = name: cfg.desktopFiles.${name};
in {
  imports = [
    ./firefox.nix
    ./qutebrowser.nix
    ./helium.nix
  ];

  options.features.desktop.browsers = {
    default = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum ["firefox" "qutebrowser" "helium"]);
      default = null;
      description = "Default browser to use for XDG MIME handlers.";
    };

    desktopFiles = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        firefox = "firefox.desktop";
        qutebrowser = "org.qutebrowser.qutebrowser.desktop";
        helium = "helium.desktop";
      };
      description = "Desktop file names used for XDG MIME handlers.";
    };
  };

  config = lib.mkIf (cfg.default != null) {
    assertions = [
      {
        assertion = cfg.${cfg.default}.enable or false;
        message = "features.desktop.browsers.default is set to ${cfg.default}, but that browser is not enabled.";
      }
    ];

    home.sessionVariables.BROWSER = cfg.default;

    home.packages = [
      (pkgs.writeShellScriptBin "browser-new-window" ''
        set -euo pipefail

        case "${cfg.default}" in
          firefox)
            exec firefox --new-window about:blank
            ;;
          qutebrowser)
            exec qutebrowser --target window about:blank
            ;;
          helium)
            exec helium --new-window helium://newtab
            ;;
          *)
            exec xdg-open about:blank
            ;;
        esac
      '')
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = let
        desktopFile = desktopFileFor cfg.default;
      in {
        "x-scheme-handler/http" = desktopFile;
        "x-scheme-handler/https" = desktopFile;
        "text/html" = desktopFile;
        "application/xhtml+xml" = desktopFile;
      };
    };
  };
}
