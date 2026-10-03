{
  self,
  inputs,
  ...
}:
{
  perSystem = { pkgs, ... }: {
    # TODO: switch to `inputs.wrapper-modules.wrappers.noctalia.wrap` once
    # nix-community/nix-wrapper-modules#598 merges, and delete ./_module.nix
    packages.noctalia = (inputs.wrapper-modules.lib.wrapModule ./_module.nix).wrap {
      inherit pkgs;
      settings =
        let
          pictures = "$HOME/Pictures"; # noctalia expands $VARS in path fields
        in
        {
          theme = {
            mode = "dark";
            source = "builtin";
            builtin = "Gruvbox";
          };

          bar.default = {
            thickness = 28;
            capsule = true;
            margin_ends = 0;
            radius = 0;
            shadow = false;
            start = [
              "workspaces"
              "active_window"
              "cpu"
              "ram"
            ];
            center = [ "clock" ];
          };

          dock.enabled = false;
          desktop_widgets.enabled = false;

          # blurred wallpaper copy placed in niri's overview backdrop (see niri's layer-rules)
          backdrop.enabled = true;

          shell = {
            corner_radius_scale = 0.0;
            font_family = self.theme.fonts.sans;
            avatar_path = "${pictures}/pfp.jpg";
            popup_shadows = false;
            animation.speed = 2.0;
            launcher.compact = true;
            niri_overview_type_to_launch_enabled = true;
            panel.shadow = false;
            # answers polkit auth requests (greeter sync, 1Password system auth, ...)
            polkit_agent = true;

            session.actions =
              pkgs.lib.imap1
                (i: action: {
                  inherit action;
                  shortcut = toString i;
                  countdown_seconds = 2.0;
                  variant = if action == "shutdown" then "destructive" else "default";
                })
                [
                  "lock"
                  "logout"
                  "lock_and_suspend"
                  "reboot"
                  "shutdown"
                ];
          };

          lockscreen = {
            blur_intensity = 0.4;
            tint_intensity = 0.7;
            transition = [ "zoom" ];
            transition_duration = 500;
          };

          control_center = {
            calendar.show_week_numbers = true;
            shortcuts = map (type: { inherit type; }) [
              "wallpaper"
              "power_profile"
              "dark_mode"
              "notification"
              "caffeine"
              "nightlight"
            ];
          };

          wallpaper = {
            enabled = true;
            directory = "${pictures}/Wallpapers";
            transition = [ "zoom" ];
            transition_on_startup = true;
          };

          location.address = "Falun";
          weather.effects = false;

          nightlight = {
            enabled = true;
            temperature_night = 2500;
          };
        };
    };
  };

  flake.nixosModules.noctalia = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia
    ];
  };
}
