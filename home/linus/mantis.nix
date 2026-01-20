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
  };

  programs.noctalia-shell.settings = {
    appLauncher.terminalCommand = "footclient -e";

    bar.widgets.right = [
      {id = "Tray";}
      {id = "NotificationHistory";}
      {id = "ScreenRecorder";}
      {id = "Volume";}
      {id = "Brightness";}
      {id = "Battery";}
      {id = "Clock";}
    ];
  };
}
