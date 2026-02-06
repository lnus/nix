{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../common
    ../features/desktop
    ../features/stylix
  ];

  features = {
    stylix.enable = true;

    desktop = {
      niri.enable = true;
      gaming.enable = true;
      ime.enable = true;
      greeter = {
        enable = true;
        type = "tuigreet";
        user = "linus";
        session = "niri-session";
      };
    };
  };

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 8;
      qemu.options = [
        "-vga none"
        "-device virtio-vga-gl"
        "-display gtk,gl=on"
      ];
    };

    services.xserver.videoDrivers = lib.mkForce [];
    hardware.nvidia.package = lib.mkForce null;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
  };

  services.xserver.videoDrivers = ["nvidia"];
  powerManagement.cpuFreqGovernor = "performance";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "miku";
  networking.networkmanager.enable = true;

  services.tailscale = {
    enable = true;
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Media + Jellyfin
  systemd.tmpfiles.rules = [
    "d /srv/media 0775 linus media - -"
  ];

  users.groups.media = {
    members = ["linus" "jellyfin"];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  system.stateVersion = "25.05";
}
