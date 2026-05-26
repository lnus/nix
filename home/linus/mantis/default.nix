{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../home.nix
    ../../features/cli
    ../../features/desktop
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

      foot = {
        enable = true;
        server = false;
      };

      discord = {
        enable = true;
        vesktop = false;
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
    stable.stremio-linux-shell

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
  };

  programs = {
    mpv.enable = true;

    retroarch = {
      enable = true;

      cores = {
        desmume.enable = true;
      };
    };

    vicinae = {
      enable = true;
      systemd.enable = true;
    };
  };

  programs.noctalia-shell.settings = {
    controlCenter.shortcuts = {
      left = [
        {id = "Network";}
        {id = "Bluetooth";}
      ];

      right = [
        {id = "PowerProfile";}
      ];
    };

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
