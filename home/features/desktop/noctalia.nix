{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.desktop.noctalia;
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.features.desktop.noctalia = {
    enable = lib.mkEnableOption "enable noctalia shell";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      adw-gtk3
      nwg-look
    ];

    programs.noctalia-shell = {
      enable = true;

      settings = let
        pictures = "${config.home.homeDirectory}/Pictures";
      in {
        sessionMenu.countdownDuration = 2000;

        bar = {
          density = "compact";
          showCapsule = false;
          enableExclusionZoneInset = false;

          widgets = {
            left = [
              {id = "Workspace";}
              {id = "ActiveWindow";}
              {id = "SystemMonitor";}
            ];

            center = [
              {id = "Clock";}
            ];
          };
        };

        dock = {
          enabled = false;
        };

        general = {
          radiusRatio = 0.2;
          lockScreenBlur = 0.4;
          lockScreenTint = 0.7;
          animationDisabled = true;
          enableShadows = false;
          avatarImage = "${pictures}/pfp.jpg";
        };
        controlCenter.shortcuts = {
          left = [
            {id = "WallpaperSelector";}
            {id = "NoctaliaPerformance";}
            {id = "DarkMode";}
          ];

          right = [
            {id = "Notifications";}
            {id = "KeepAwake";}
            {id = "NightLight";}
          ];
        };

        controlCenter.cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = false;
            id = "brightness-card";
          }
          {
            enabled = false;
            id = "weather-card";
          }
          {
            enabled = false;
            id = "media-sysmon-card";
          }
        ];

        notifications = {
          density = "compact";
        };

        wallpaper = {
          enabled = true;
          directory = "${pictures}/Wallpapers";

          overviewEnabled = true;
          setWallpaperOnAllMonitors = true;

          skipStartupTransition = true;
        };

        colorSchemes.useWallpaperColors = true;

        templates.activeTemplates = [
          {
            id = "discord";
            enabled = true;
          }
          {
            id = "foot";
            enabled = true;
          }
          {
            id = "gtk";
            enabled = true;
          }
          {
            id = "niri";
            enabled = true;
          }
          {
            id = "qt";
            enabled = true;
          }
          {
            id = "vicinae";
            enabled = true;
          }
          {
            id = "yazi";
            enabled = true;
          }
          {
            id = "helix";
            enabled = true;
          }
        ];

        location = {
          name = "Falun";
          showWeekNumberInCalendar = true;
          weatherShowEffects = false;
          firstDayOfWeek = 1;
        };

        nightLight = {
          enabled = true;
          nightTemp = "2500";
        };
      };
    };
  };
}
