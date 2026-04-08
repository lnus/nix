{
  pkgs,
  lib,
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

      zed = {
        enable = true;
        nvidia = true;
      };

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
    kdePackages.okular

    # password manager
    _1password-gui
    _1password-cli

    # unlimited bacon (games)
    protonup-ng
    lutris
    prismlauncher
    dolphin-emu
    # add back eventually...
    # shipwright

    # media
    chatterino2
    qbittorrent
    spotify
    nicotine-plus
    fooyin
    stable.stremio-linux-shell

    # ai st00f
    claude-code
    codex
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/linus/.steam/root/compatibilitytools.d";
  };

  services.udiskie = {
    enable = true;
    settings = {
      program_options = {
        file_manager = "${lib.getExe pkgs.thunar}";
      };
    };
  };

  programs = {
    mpv.enable = true;
    vesktop.enable = true;

    retroarch = {
      enable = true;

      cores = {
        melonds.enable = true;
        dolphin.enable = true; # This is... okay, not great though
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
    network.wifiEnabled = false;

    bar.widgets.right = [
      {id = "Tray";}
      {id = "NotificationHistory";}
      {id = "ScreenRecorder";}
      {id = "Volume";}
      {id = "Clock";}
    ];
  };
}
