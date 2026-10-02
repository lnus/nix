{ ... }: {
  flake.nixosModules.driversNvidia = { ... }: {
    hardware.graphics = {
      enable = true;
    };
    hardware.nvidia = {
      modesetting.enable = true;
      open = true;
    };
    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
