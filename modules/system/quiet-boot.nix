{ ... }: {
  flake.nixosModules.quiet-boot = { ... }: {
    boot = {
      plymouth.enable = true;
      consoleLogLevel = 3;
      initrd.verbose = false;
      initrd.systemd.enable = true;
      kernelParams = [
        "quiet"
        "splash"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];
      # hold space at boot for the menu
      loader.timeout = 0;
    };
  };
}
