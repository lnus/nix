{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./home.nix
    ../features/cli
    ../features/desktop
  ];

  features = {
    cli = {
      nushell.enable = true;
      helix.enable = true;
    };

    desktop = {
      noctalia.enable = true;
      ui.enable = true; # icons + cursor

      bolt.enable = true;

      browsers = {
        helium.enable = true;
        firefox.enable = true;
        qutebrowser.enable = false;
        default = "firefox";
      };

      idle = {
        enable = true;
        timeout = 600;
        lock_cmd = "noctalia-shell ipc call lockScreen lock";
        monitor_off_cmd = "niri msg action power-off-monitors";
      };
    };
  };

  # Prefer Vesktop for discord:// URLs.
  xdg.mimeApps.defaultApplications."x-scheme-handler/discord" = "vesktop.desktop";

  home.packages = with pkgs; [
    # misc
    thunar

    # password manager
    _1password-gui
    _1password-cli

    # unlimited bacon (games)
    itch
    lutris

    # media
    chatterino2
    spotify
    mpv
    qbittorrent

    # ai st00f
    claude-code
    codex
  ];

  services = {
    udiskie = {
      enable = true;
      settings = {
        program_options = {
          file_manager = "${lib.getExe pkgs.thunar}";
        };
      };
    };

    hyprpaper = {
      enable = true;

      settings = let
        wall = pkgs.liLib.wallhaven.fetch {
          id = "vpy573";
          ext = "jpg";
          hash = "sha256-aKeMXlmAW2uo73NXkU5QY4Ym6ZQ9dZj+YyznMCNsisI=";
        };
      in {
        preload = ["${wall}"];
        wallpaper = [
          {
            monitor = "eDP-1";
            path = "${wall}";
          }
        ];
      };
    };
  };

  programs = {
    mpv.enable = true;
    vesktop.enable = true;

    retroarch = {
      enable = true;

      cores = {
        desmume.enable = true;
      };
    };

    foot = {
      enable = true;
      server.enable = true;
    };

    vicinae = {
      enable = true;
      systemd.enable = true;
    };
  };

  programs.noctalia-shell.settings = {
    appLauncher.terminalCommand = "footclient -e";

    bar.widgets.right = [
      {id = "Tray";}
      {id = "NotificationHistory";}
      {id = "Volume";}
      {id = "Network";}
      {id = "Battery";}
      {id = "Brightness";}
    ];
  };
}
