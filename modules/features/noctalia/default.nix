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

      colors = {
        version = 2;
      }
      // builtins.mapAttrs (_: c: {
        primary = c.accent;
        on_primary = c.on-accent;
        secondary = c.accent;
        on_secondary = c.on-accent;
        tertiary = c.accent;
        on_tertiary = c.on-accent;
        error = c.error;
        on_error = c.on-accent;
        surface = c.surface;
        on_surface = c.text;
        surface_container = c.raised;
        on_surface_variant = c.muted;
        outline_variant = c.border;
        shadow = "#000000";
        hover = c.raised;
        on_hover = c.text;
      }) self.theme.ui;

      settings =
        let
          pictures = "$HOME/Pictures"; # noctalia expands $VARS in path fields
          glassOpacity = 0.55;
        in
        {
          theme = {
            mode = "dark";
            source = "custom";
            custom_palette = "custom";
          };

          bar.default = {
            thickness = 28;
            capsule = false;
            margin_edge = 6;
            margin_ends = 6;
            radius = self.theme.radius - 2;
            background_opacity = glassOpacity;
            compositor_blur = true;
            shadow = true;
            start = [
              "workspaces"
              "active_window"
              "cpu"
              "ram"
            ];
            center = [ "clock" ];
          };

          notification.background_opacity = glassOpacity;
          osd.background_opacity = glassOpacity;

          dock.enabled = false;
          desktop_widgets.enabled = false;

          backdrop.enabled = true;

          shell = {
            corner_radius_scale = 0.6;
            font_family = self.theme.fonts.sans;
            avatar_path = "${pictures}/pfp.jpg";
            popup_shadows = true;
            animation.speed = 2.0;
            launcher.compact = true;
            niri_overview_type_to_launch_enabled = true;
            panel = {
              shadow = true;
              transparency_mode = "glass";
            };
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

          idle = {
            behavior_order = [
              "lock"
              "screen-off"
            ];
            behavior.lock = {
              action = "lock";
              timeout = 600;
            };
            behavior.screen-off = {
              action = "screen_off";
              timeout = 601;
            };
          };

          lockscreen = {
            lock_before_suspend = true;
            blur_intensity = 0.4;
            tint_intensity = 0.7;
            transition = [ "zoom" ];
            transition_duration = 500;
          };

          control_center = {
            calendar = {
              show_week_numbers = true;
              show_events_card = false;
            };
            shortcuts = map (type: { inherit type; }) [
              "wallpaper"
              "bluetooth"
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
