{ self, ... }: {
  flake.nixosModules.mangohud =
    { pkgs, lib, ... }:
    let
      color = name: lib.removePrefix "#" self.theme.colors.${name};
      config = pkgs.writeText "MangoHud.conf" ''
        horizontal
        hud_compact
        position=top-left
        round_corners=0
        background_alpha=0.6
        font_size=18
        background_color=${color "base00"}
        text_color=${color "base05"}
        gpu_color=${color "base0B"}
        cpu_color=${color "base0D"}
        vram_color=${color "base0E"}
        ram_color=${color "base0C"}
        frametime_color=${color "base0A"}

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
      systemd.user.tmpfiles.rules = [ "d %h/.local/share/mangohud/logs - - - -" ];
    };
}
