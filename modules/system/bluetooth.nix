{ ... }: {
  flake.nixosModules.bluetooth = { ... }: {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      # exposes headset battery levels over D-Bus
      settings.General.Experimental = true;
    };
  };
}
