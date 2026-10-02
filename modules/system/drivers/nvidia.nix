{ ... }: {
  flake.nixosModules.driversNvidia = { ... }: {
    hardware.graphics = {
      enable = true;
    };
    hardware.nvidia = {
      modesetting.enable = true;
      open = false;
    };
    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
