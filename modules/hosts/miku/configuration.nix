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
      ])
      ++ (with self.nixosModules; [
        helix
        niri
        noctalia
      ]);

    networking.hostName = "miku";

    environment.systemPackages = with pkgs; [
      git
    ];

    powerManagement.cpuFreqGovernor = "performance";
    services.udisks2.enable = true;

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
