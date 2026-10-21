{ ... }: {
  flake.nixosModules.librepods = { lib, pkgs, ... }: {
    environment.systemPackages = [ pkgs.librepods ];

    systemd.user.services.librepods = {
      description = "LibrePods AirPods tray";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "${lib.getExe pkgs.librepods} --hide";
    };

    # needed for stem tap gestures
    services.pipewire.wireplumber.extraConfig.bluez-avrcp."monitor.bluez.properties" = {
      "bluez5.dummy-avrcp-player" = true;
    };
  };
}
