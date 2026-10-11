{ ... }: {
  # presets stay as state in ~/.local/share/easyeffects for now
  flake.nixosModules.easyeffects = { pkgs, lib, ... }: {
    environment.systemPackages = [ pkgs.easyeffects ];

    systemd.user.services.easyeffects = {
      description = "EasyEffects daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.easyeffects} --hide-window --service-mode";
        ExecStop = "${lib.getExe pkgs.easyeffects} --quit";
      };
    };
  };
}
