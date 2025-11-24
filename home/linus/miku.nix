{pkgs, ...}: {
  imports = [
    ./home.nix
    ../features/cli
    ../features/desktop
  ];

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
}
