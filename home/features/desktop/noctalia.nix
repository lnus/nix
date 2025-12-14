{
  inputs,
  config,
  lib,
  stylixLib,
  ...
}: let
  cfg = config.features.desktop.noctalia;
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.features.desktop.noctalia.enable = lib.mkEnableOption "enable noctalia shell";

  config = lib.mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true; # systemd startup service, consider making option

      settings = let
        pictures = "${config.home.homeDirectory}/Pictures";
      in {
        sessionMenu.countdownDuration = 2000;

        bar = {
          position = "bottom";
          density = "compact";
          showCapsule = false;
          outerCorners = false;

          widgets.left = [
            {id = "ControlCenter";}
            {id = "SystemMonitor";}
            {id = "ActiveWindow";}
          ];
        };

        audio.visualizerType = "none";

        calendar.cards = [
          {
            enabled = true;
            id = "calendar-header-card";
          }
          {
            enabled = true;
            id = "calendar-month-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "timer-card";
          }
        ];

        controlCenter = {
          cards = [
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
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
        };

        dock = {
          enabled = false;
        };

        general = {
          radiusRatio = 0.2;
          animationDisabled = true;
          enableShadows = false;

          avatarImage = "${pictures}/pfp.jpg";
        };

        wallpaper = let
          wallpapers = "${pictures}/Wallpapers";
        in {
          enabled = true;
          overviewEnabled = true;

          directory = "${wallpapers}";
          setWallpaperOnAllMonitors = false;
        };

        colorSchemes = {
          useWallpaperColors = false;
          generateTemplatesForPredefined = false;
        };

        location = {
          name = "Stockholm";
          showWeekNumberInCalendar = true;
          weatherShowEffects = false;
          firstDayOfWeek = 1;
        };

        nightLight = {
          enabled = true;
          nightTemp = "3000";
        };
      };
    };
  };
}
