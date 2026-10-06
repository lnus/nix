{ self, ... }: {
  flake.nixosModules.mikuConfiguration =
    {
      pkgs,
      lib,
      ...
    }:
    let
      main = "HP Inc. HP X27q 6CM2050MSP";
      side = "Acer Technologies Acer XB270H T1BEE0084200";
    in
    {
      imports = [
        self.nixosModules.mikuHardware
      ]
      ++ (with self.nixosModules; [
        coreBoot
        coreLocale
        coreUser
        coreNixSettings
        network
        audio
        driversNvidia
        theming
        quiet-boot

        helix
        zed
        niri
        noctalia-greeter
        noctalia
        firefox
        kitty
        fonts
        zk

        # these lean modules are mostly flat package lists —
        # worth revisiting as attrs/ or roles/ later
        ai

        video
        steam
        vesktop
        boltLauncher
      ]);

      networking.hostName = "miku";

      programs.niri.wrapper.settings.outputs = {
        ${main} = {
          mode = "2560x1440@164.834";
          focus-at-startup = _: { };
          variable-refresh-rate = _: { };
          scale = 1.0;
        };
        ${side} = {
          mode = "1920x1080@144.001";
          transform = "90";
          scale = 1.0;
          layout.default-column-width.proportion = 1.0;
        };
      };

      # otherwise the greeter mirrors to all outputs and focus lands on the rotated side monitor
      services.displayManager.noctalia-greeter.settings.output.name = main;

      environment.systemPackages = with pkgs; [
        git
      ];

      powerManagement.cpuFreqGovernor = "performance";
      services.udisks2.enable = true;

      programs._1password-gui.enable = true;
      programs._1password.enable = true;
      programs.localsend.enable = true;

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

        services.xserver.videoDrivers = lib.mkForce [ ];
        hardware.nvidia.package = lib.mkForce null;
      };

      system.stateVersion = "26.05";
    };
}
