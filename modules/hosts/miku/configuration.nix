{ self, ... }: {
  flake.nixosModules.mikuConfiguration =
    { lib, ... }:
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
        fcitx5
        zk
        udiskie
        easyeffects
        jujutsu
        git
        mangohud
        gpu-log

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

      services.pipewire.wireplumber.extraConfig = {
        alsa-disable."monitor.alsa.rules" =
          map
            (name: {
              matches = [ { "node.name" = name; } ];
              actions.update-props."node.disabled" = true;
            })
            [
              "alsa_output.pci-0000_01_00.1.hdmi-stereo"
              "alsa_output.usb-BurrBrown_from_Texas_Instruments_USB_AUDIO_CODEC-00.analog-stereo"
              "alsa_input.pci-0000_00_1f.3.analog-stereo"
            ];

        device-rename."monitor.alsa.rules" =
          lib.mapAttrsToList
            (name: description: {
              matches = [ { "node.name" = name; } ];
              actions.update-props."node.description" = description;
            })
            {
              "alsa_output.usb-Apple__Inc._USB-C_to_3.5mm_Headphone_Jack_Adapter_DWH428500U9L1MQA8-00.analog-stereo" =
                "IEM";
              "alsa_output.pci-0000_00_1f.3.analog-stereo" = "Speakers";
              "alsa_input.usb-BurrBrown_from_Texas_Instruments_USB_AUDIO_CODEC-00.analog-stereo" =
                "M-Audio M-Track Solo";
            };
      };

      powerManagement.cpuFreqGovernor = "performance";

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
