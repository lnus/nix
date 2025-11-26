{
  pkgs,
  config,
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
      firefox.enable = true;
      noctalia.enable = true;

      idle = {
        enable = true;
        timeout = 600;
        lock_cmd = "noctalia-shell ipc call lockScreen lock";
        monitor_off_cmd = "niri msg action power-off-monitors";
      };
    };
  };

  home.packages = with pkgs; [
    # password manager
    _1password-gui
    _1password-cli

    # unlimited bacon (games)
    mangohud
    bolt-launcher
    lutris

    # media
    qbittorrent
    spotify
  ];

  programs = {
    mpv.enable = true;
    vesktop.enable = true;

    foot = {
      enable = true;
      server.enable = true;
    };
  };

  programs.noctalia-shell.settings = let
    pictures = "${config.home.homeDirectory}/Pictures";
  in {
    appLauncher.terminalCommand = "footclient -e";
    general.avatarImage = "${pictures}/pfp.jpg";
    network.wifiEnabled = false;

    wallpaper = let
      wallpapers = "${pictures}/Wallpapers";
    in {
      enabled = true;
      directory = "${wallpapers}";
      setWallpaperOnAllMonitors = false;

      monitors = [
        {
          directory = "${wallpapers}";
          name = "DP-3";
          wallpaper = "${wallpapers}/long.png";
        }
        {
          directory = "${wallpapers}";
          name = "DP-4";
          wallpaper = "${wallpapers}/wide.png";
        }
      ];
    };

    bar.widgets.right = [
      {id = "Tray";}
      {id = "NotificationHistory";}
      {id = "ScreenRecorder";}
      {id = "Volume";}
      {id = "Clock";}
    ];
  };
}
