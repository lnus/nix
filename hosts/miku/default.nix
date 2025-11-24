{lib, ...}: {
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
      greeter = {
        enable = true;
        type = "none";
        user = "linus";
        session = "niri-session";
      };
    };
  };

  # VM/Qemu
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

  # GPU
  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  # CPU
  powerManagement.cpuFreqGovernor = "performance";

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "miku";
  networking.networkmanager.enable = true;

  # Locale
  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Audio
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
