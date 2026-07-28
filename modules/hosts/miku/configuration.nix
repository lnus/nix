{self, ...}: {
  flake.nixosModules.mikuConfiguration = {
    pkgs,
    lib,
    ...
  }: {
    imports =
      [self.nixosModules.mikuHardware]
      ++ (with self.nixosModules; [
        coreBoot
        coreLocale
        coreUser
        coreNixSettings
        network
        audio
        driversNvidia

        helix
        niri
        sddm
        sddm-autologin
        noctalia
        firefox
        kitty
        fonts

        # these lean modules are mostly flat package lists —
        # worth revisiting as attrs/ or roles/ later
        ai

        video
        steam
        vesktop
        boltLauncher
      ]);

    networking.hostName = "miku";

    environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/linus/.steam/root/compatibilitytools.d";

    environment.systemPackages = with pkgs; [
      git
    ];

    powerManagement.cpuFreqGovernor = "performance";
    services.udisks2.enable = true;

    programs._1password-gui.enable = true;
    programs._1password.enable = true;

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

    system.stateVersion = "26.05";
  };
}
