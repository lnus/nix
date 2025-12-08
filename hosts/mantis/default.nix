{pkgs, ...}: {
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
      kdePackages.enable = true;
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
      memorySize = 4096;
      cores = 4;
      qemu.options = [
        "-vga none"
        "-device virtio-vga-gl"
        "-display gtk,gl=on"
      ];
    };
  };

  hardware.graphics.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # This driver conflicts and borks my trackpad
  boot.blacklistedKernelModules = ["elan_i2c"];

  networking.hostName = "mantis";
  networking.networkmanager.enable = true;

  services.tailscale = {
    enable = true;
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  hardware.bluetooth.enable = true;
  services.tuned.enable = true;
  services.upower.enable = true;

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

  system.stateVersion = "25.05";
}
