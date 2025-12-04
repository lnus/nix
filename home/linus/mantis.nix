{
  config,
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
      firefox.enable = true;
      noctalia.enable = true;
      ui.enable = true; # icons + cursor

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
    itch
    lutris

    # media
    spotify
    mpv
    qbittorrent
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

    wallpaper = let
      wallpapers = "${pictures}/Wallpapers";
    in {
      enabled = true;
      directory = "${wallpapers}";
      defaultWallpaper = "${wallpapers}/default.png";
    };
  };
}
