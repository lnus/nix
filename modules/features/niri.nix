{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.niri = {pkgs, ...}: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
    };

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];
  };

  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: let
    noctalia = cmd:
      ["noctalia-shell" "ipc" "call"]
      ++ (lib.splitString " " cmd);
  in {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.noctalia)
        ];

        hotkey-overlay.skip-at-startup = _: {};

        input = {
          keyboard = {
            xkb = {
              layout = "us";
              options = "ctrl:nocaps";
              variant = "altgr-intl";
            };
            numlock = _: {};
          };
          mouse.accel-profile = "flat";
        };

        outputs = {
          "eDP-1" = {
            mode = "1920x1080";
            scale = 1.0;
          };
          "DP-4" = {
            mode = "2560x1440@164.834";
            focus-at-startup = _: {};
            scale = 1.0;
          };
          "DP-3" = {
            mode = "1920x1080@144.001";
            transform = "90";
            scale = 1.0;
            layout.default-column-width.proportion = 1.0;
          };
        };

        overview.workspace-shadow = {
          softness = 40;
          spread = 10;
          offset = _: {
            props = {
              x = 0;
              y = 10;
            };
          };
        };

        layer-rules = [
          {
            matches = [{namespace = "^noctalia-overview*";}];
            place-within-backdrop = true;
          }
        ];

        prefer-no-csd = _: {};
        animations.off = _: {};

        layout = {
          gaps = 0;
          focus-ring = {
            off = _: {};
            width = 1;
          };
          border = {
            width = 1;
            active-color = self.theme.base0D;
            inactive-color = self.theme.base03;
          };
        };

        binds = {
          "Mod+Shift+Slash".show-hotkey-overlay = _: {};
          "Mod+B" = _: {
            props.hotkey-overlay-title = "Browser";
            content.spawn = [(lib.getExe self'.packages.firefox)];
          };
          "Mod+D" = _: {
            props.hotkey-overlay-title = "Run Application: noctalia";
            content.spawn = noctalia "launcher toggle";
          };
          "Mod+Return" = _: {
            props.hotkey-overlay-title = "Open a Terminal: foot";
            content.spawn-sh = lib.getExe pkgs.foot;
          };

          "Mod+T" = _: {
            props.repeat = false;
            content.toggle-window-rule-opacity = _: {};
          };
          "Mod+O".toggle-overview = _: {};
          "Mod+Q".close-window = _: {};

          "Mod+Left".focus-column-left = _: {};
          "Mod+Down".focus-window-down = _: {};
          "Mod+Up".focus-window-up = _: {};
          "Mod+Right".focus-column-right = _: {};
          "Mod+H".focus-column-left = _: {};
          "Mod+J".focus-window-down = _: {};
          "Mod+K".focus-window-up = _: {};
          "Mod+L".focus-column-right = _: {};

          "Mod+Ctrl+Left".move-column-left = _: {};
          "Mod+Ctrl+Down".move-window-down = _: {};
          "Mod+Ctrl+Up".move-window-up = _: {};
          "Mod+Ctrl+Right".move-column-right = _: {};
          "Mod+Ctrl+H".move-column-left = _: {};
          "Mod+Ctrl+J".move-window-down = _: {};
          "Mod+Ctrl+K".move-window-up = _: {};
          "Mod+Ctrl+L".move-column-right = _: {};

          "Mod+Home".focus-column-first = _: {};
          "Mod+End".focus-column-last = _: {};
          "Mod+Ctrl+Home".move-column-to-first = _: {};
          "Mod+Ctrl+End".move-column-to-last = _: {};

          "Mod+Shift+Left".focus-monitor-left = _: {};
          "Mod+Shift+Down".focus-monitor-down = _: {};
          "Mod+Shift+Up".focus-monitor-up = _: {};
          "Mod+Shift+Right".focus-monitor-right = _: {};
          "Mod+Shift+H".focus-monitor-left = _: {};
          "Mod+Shift+J".focus-monitor-down = _: {};
          "Mod+Shift+K".focus-monitor-up = _: {};
          "Mod+Shift+L".focus-monitor-right = _: {};

          "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = _: {};
          "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = _: {};
          "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = _: {};
          "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = _: {};
          "Mod+Shift+Ctrl+H".move-column-to-monitor-left = _: {};
          "Mod+Shift+Ctrl+J".move-column-to-monitor-down = _: {};
          "Mod+Shift+Ctrl+K".move-column-to-monitor-up = _: {};
          "Mod+Shift+Ctrl+L".move-column-to-monitor-right = _: {};

          "Mod+Page_Down".focus-workspace-down = _: {};
          "Mod+Page_Up".focus-workspace-up = _: {};
          "Mod+U".focus-workspace-down = _: {};
          "Mod+I".focus-workspace-up = _: {};
          "Mod+Ctrl+Page_Down".move-column-to-workspace-down = _: {};
          "Mod+Ctrl+Page_Up".move-column-to-workspace-up = _: {};
          "Mod+Ctrl+U".move-column-to-workspace-down = _: {};
          "Mod+Ctrl+I".move-column-to-workspace-up = _: {};

          "Mod+Shift+Page_Down".move-workspace-down = _: {};
          "Mod+Shift+Page_Up".move-workspace-up = _: {};
          "Mod+Shift+U".move-workspace-down = _: {};
          "Mod+Shift+I".move-workspace-up = _: {};

          "Mod+WheelScrollDown" = _: {
            props.cooldown-ms = 150;
            content.focus-workspace-down = _: {};
          };
          "Mod+WheelScrollUp" = _: {
            props.cooldown-ms = 150;
            content.focus-workspace-up = _: {};
          };
          "Mod+Ctrl+WheelScrollDown" = _: {
            props.cooldown-ms = 150;
            content.move-column-to-workspace-down = _: {};
          };
          "Mod+Ctrl+WheelScrollUp" = _: {
            props.cooldown-ms = 150;
            content.move-column-to-workspace-up = _: {};
          };

          "Mod+WheelScrollRight".focus-column-right = _: {};
          "Mod+WheelScrollLeft".focus-column-left = _: {};
          "Mod+Ctrl+WheelScrollRight".move-column-right = _: {};
          "Mod+Ctrl+WheelScrollLeft".move-column-left = _: {};

          "Mod+Shift+WheelScrollDown".focus-column-right = _: {};
          "Mod+Shift+WheelScrollUp".focus-column-left = _: {};
          "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = _: {};
          "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = _: {};

          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;
          "Mod+Ctrl+1".move-column-to-workspace = 1;
          "Mod+Ctrl+2".move-column-to-workspace = 2;
          "Mod+Ctrl+3".move-column-to-workspace = 3;
          "Mod+Ctrl+4".move-column-to-workspace = 4;
          "Mod+Ctrl+5".move-column-to-workspace = 5;
          "Mod+Ctrl+6".move-column-to-workspace = 6;
          "Mod+Ctrl+7".move-column-to-workspace = 7;
          "Mod+Ctrl+8".move-column-to-workspace = 8;
          "Mod+Ctrl+9".move-column-to-workspace = 9;

          "Mod+BracketLeft".consume-or-expel-window-left = _: {};
          "Mod+BracketRight".consume-or-expel-window-right = _: {};

          "Mod+Comma".consume-window-into-column = _: {};
          "Mod+Period".expel-window-from-column = _: {};

          "Mod+R".switch-preset-column-width = _: {};
          "Mod+Shift+R".switch-preset-window-height = _: {};
          "Mod+Ctrl+R".reset-window-height = _: {};

          "Mod+F".maximize-column = _: {};
          "Mod+Shift+F".fullscreen-window = _: {};
          "Mod+Ctrl+F".expand-column-to-available-width = _: {};

          "Mod+C".center-column = _: {};
          "Mod+Ctrl+C".center-visible-columns = _: {};

          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";
          "Mod+Shift+Minus".set-window-height = "-10%";
          "Mod+Shift+Equal".set-window-height = "+10%";

          "Mod+V".toggle-window-floating = _: {};
          "Mod+Shift+V".switch-focus-between-floating-and-tiling = _: {};

          "Mod+W".toggle-column-tabbed-display = _: {};

          "Print".screenshot = _: {};
          "Ctrl+Print".screenshot-screen = _: {};
          "Alt+Print".screenshot-window = _: {};

          "Mod+Escape" = _: {
            props.allow-inhibiting = false;
            content.toggle-keyboard-shortcuts-inhibit = _: {};
          };

          "Mod+Shift+E" = _: {
            props.hotkey-overlay-title = "Run Application: noctalia-shell";
            content.spawn = noctalia "sessionMenu toggle";
          };

          "Ctrl+Alt+Delete".quit = _: {};

          "Super+Alt+L" = _: {
            props.allow-when-locked = true;
            props.hotkey-overlay-title = "Lock the Screen: noctalia";
            content.spawn = noctalia "lockScreen lock";
          };

          "XF86AudioRaiseVolume" = _: {
            props.allow-when-locked = true;
            content.spawn = noctalia "volume increase";
          };
          "XF86AudioLowerVolume" = _: {
            props.allow-when-locked = true;
            content.spawn = noctalia "volume decrease";
          };
          "XF86AudioMute" = _: {
            props.allow-when-locked = true;
            content.spawn = noctalia "volume muteOutput";
          };
          "XF86AudioMicMute" = _: {
            props.allow-when-locked = true;
            content.spawn = noctalia "volume muteInput";
          };
          "XF86AudioPlay" = _: {
            props.allow-when-locked = true;
            content.spawn = noctalia "media playPause";
          };
          "XF86AudioNext" = _: {
            props.allow-when-locked = true;
            content.spawn = noctalia "media next";
          };
          "XF86AudioPrev" = _: {
            props.allow-when-locked = true;
            content.spawn = noctalia "media previous";
          };
          "XF86MonBrightnessUp" = _: {
            props.allow-when-locked = true;
            content.spawn = noctalia "brightness increase";
          };
          "XF86MonBrightnessDown" = _: {
            props.allow-when-locked = true;
            content.spawn = noctalia "brightness decrease";
          };
        };
      };
    };
  };
}
