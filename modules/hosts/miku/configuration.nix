{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.mikuConfiguration = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.mikuHardware

      self.nixosModules.niri
      self.nixosModules.helix
      self.nixosModules.nushell
    ];

    environment.systemPackages = with pkgs; [
      git
    ];

    users.users.linus = {
      initialPassword = "password";
      isNormalUser = true;
      description = "linus";
    };

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
    };

    nix.settings.experimental-features = ["nix-command" "flakes"];

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

    time.timeZone = "Europe/Stockholm";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.udisks2.enable = true;

    system.stateVersion = "26.05";
  };
}
