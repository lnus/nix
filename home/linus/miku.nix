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
      zed = {
        enable = true;
        nvidia = true;
      };

      browsers = {
        firefox.enable = true;
        qutebrowser.enable = true;
      };

      idle = {
        enable = true;
        timeout = 600;
        lock_cmd = "noctalia-shell ipc call lockScreen lock";
        monitor_off_cmd = "niri msg action power-off-monitors";
      };
    };
  };

  home.packages = with pkgs; [
    # misc
    xfce.thunar
    kdePackages.okular

    # password manager
    _1password-gui
    _1password-cli

    # unlimited bacon (games)
    protonup-ng
    bolt-launcher
    lutris
    prismlauncher
    dolphin-emu
    shipwright

    # media
    chatterino2
    qbittorrent
    spotify
    obs-studio

    # ai st00f
    claude-code
    codex
  ];

  # Semi-jank patch to make wrapper behave in Niri
  # Noctalia calls Quickshell.execDetached(["niri", "msg", "action", "spawn", "--"].concat(command));
  # TODO Properly fix; probably issue with compositor spawning
  # TODO Move out to module?
  xdg.desktopEntries."Bolt" = let
    bolt-wrap = pkgs.writeShellScriptBin "bolt-wrap" ''
      sh -c bolt-launcher "$@"
    '';
  in {
    categories = ["Game"];
    comment = "An alternative launcher for RuneScape";
    exec = "${lib.getExe bolt-wrap}";
    genericName = "bolt-launcher";
    icon = "bolt-launcher";
    name = "Bolt Launcher";
    terminal = false;
    type = "Application";
  };

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/linus/.steam/root/compatibilitytools.d";
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
