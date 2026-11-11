{ self, ... }: {
  flake.nixosModules.mangohud =
    { pkgs, lib, ... }:
    let
      ui = self.theme.ui.dark;
      rp = self.theme.terminal.dark;
      color = lib.removePrefix "#";
      config = pkgs.writeText "MangoHud.conf" ''
        horizontal
        hud_compact
        position=top-left
        round_corners=${toString self.theme.radius}
        background_alpha=0.6
        font_size=18
        background_color=${color ui.background}
        text_color=${color ui.text}
        gpu_color=${color rp.foam}
        cpu_color=${color rp.iris}
        vram_color=${color rp.rose}
        ram_color=${color rp.pine}
        frametime_color=${color rp.gold}

        fps
        frametime
        frame_timing=0
        gpu_stats
        gpu_temp
        cpu_stats
        cpu_temp
        vram
        ram

        toggle_hud=Shift_R+F12
        toggle_logging=Shift_L+F2
        output_folder=~/.local/share/mangohud/logs
      '';
    in
    {
      environment.systemPackages = [ pkgs.mangohud ];
      environment.sessionVariables.MANGOHUD_CONFIGFILE = "${config}";
      systemd.user.tmpfiles.rules = [ "d %h/.local/share/mangohud/logs - - - 30d" ];
    };
}
