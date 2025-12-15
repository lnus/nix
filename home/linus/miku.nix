{pkgs, ...}: {
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

    # media
    chatterino2
    qbittorrent
    spotify
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/linus/.steam/root/compatibilitytools.d";
  };

  programs = {
    mpv.enable = true;
    vesktop.enable = true;

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
