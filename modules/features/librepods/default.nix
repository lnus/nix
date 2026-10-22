{ ... }: {
  flake.nixosModules.librepods = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.librepods ];

    # needed for stem tap gestures
    services.pipewire.wireplumber.extraConfig.bluez-avrcp."monitor.bluez.properties" = {
      "bluez5.dummy-avrcp-player" = true;
    };
  };
}
