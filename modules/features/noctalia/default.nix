{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, lib, ... }:
    {
      # TODO: switch to `inputs.wrapper-modules.wrappers.noctalia.wrap` once
      # nix-community/nix-wrapper-modules#598 merges, and delete ./_module.nix
      packages.noctalia = (inputs.wrapper-modules.lib.wrapModule ./_module.nix).wrap {
        inherit pkgs;

        # 5.4.1's shell only reads format-1 keys and rejects a mode without `terminal`;
        # the snake_case format from the docs only works in the `noctalia theme` CLI
        colors = builtins.mapAttrs (
          mode: c:
          let
            t = self.theme.terminal.${mode};
            ansi = black: {
              inherit black;
              red = t.love;
              green = t.pine;
              yellow = t.gold;
              blue = t.foam;
              magenta = t.iris;
              cyan = t.rose;
              white = t.text;
            };
          in
          {
            mPrimary = c.accent;
            mOnPrimary = c.on-accent;
            mSecondary = c.accent;
            mOnSecondary = c.on-accent;
            mTertiary = c.accent;
            mOnTertiary = c.on-accent;
            mError = c.error;
            mOnError = c.on-accent;
            mSurface = c.surface;
            mOnSurface = c.text;
            mSurfaceVariant = c.raised;
            mOnSurfaceVariant = c.muted;
            mOutline = c.border;
            mShadow = "#000000";
            mHover = c.raised;
            mOnHover = c.text;
            terminal = {
              foreground = t.text;
              background = t.base;
              cursor = t.text;
              cursorText = t.base;
              selectionFg = t.text;
              selectionBg = t.overlay;
              normal = ansi t.overlay;
              bright = ansi t.muted;
            };
          }
        ) self.theme.ui;

        settings =
          let
            pictures = "$HOME/Pictures"; # noctalia expands $VARS in path fields
            glassOpacity = 0.55;
            mono = self.theme.fonts.mono;
            muted = "on_surface_variant";

            labelStyle = {
              font_scale = 0.75;
              font_weight = 600;
              color = muted;
            };
            statLabel =
              text:
              labelStyle
              // {
                type = "text";
                inherit text;
                interactive = false;
              };
            statValue = stat: {
              type = "sysmon";
              inherit stat;
              visualization = "none";
              show_glyph = false;
              font_family = mono;
            };
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
              widget_spacing = 4;
              hover_highlight = false;
              start = [
                "workspaces"
                "gap"
                "active_window"
              ];
              center = [ "media" ];
              # hosts slot extra stats (e.g. battery) in between at the default order
              end = lib.mkMerge [
                (lib.mkOrder 500 [
                  "tray"
                  "gap"
                  "bluetooth"
                  "gap"
                  "volume_label"
                  "volume"
                  "gap"
                  "cpu_label"
                  "cpu"
                  "gap"
                  "ram_label"
                  "ram"
                  "gap"
                ])
                (lib.mkOrder 1500 [
                  "date"
                  "clock"
                ])
              ];
            };

            widget = {
              workspaces = {
                style = "minimal";
                font_family = mono;
                focused_color = "primary";
                occupied_color = "on_surface";
                empty_color = muted;
              };
              active_window = {
                display = "text_only";
                max_length = 480;
              };
              tray.drawer = true;
              media = {
                hide_when_no_media = true;
                max_length = 360;
              };
              volume_label = statLabel "VOL";
              volume = {
                show_glyph = false;
                font_family = mono;
              };
              gap = {
                type = "spacer";
                length = 10;
              };
              cpu_label = statLabel "CPU";
              cpu = statValue "cpu_usage";
              ram_label = statLabel "RAM";
              ram = statValue "ram_used";
              bat_label = statLabel "BAT";
              battery = {
                display_mode = "none";
                font_family = mono;
              };
              date = labelStyle // {
                type = "clock";
                format = "{:%d %^b}";
              };
              clock = {
                format = "{:%H:%M}";
                font_family = mono;
                font_weight = 600;
              };
            };

            notification = {
              background_opacity = glassOpacity;
              border = false;
            };
            osd = {
              background_opacity = glassOpacity;
              border = false;
            };

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

  flake.nixosModules.noctalia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.programs.noctalia.wrapper = lib.mkOption {
        type = lib.types.deferredModule;
        default = { };
        description = "wrapper-modules config layered onto `packages.noctalia`, e.g. a host's bar widgets.";
      };

      config.programs.noctalia = {
        enable = true;
        package =
          self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia.wrap
            config.programs.noctalia.wrapper;
      };
    };
}
