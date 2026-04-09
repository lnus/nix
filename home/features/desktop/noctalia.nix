{
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.features.desktop.noctalia;
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.features.desktop.noctalia = {
    enable = lib.mkEnableOption "enable noctalia shell";
    wallpaper = lib.mkEnableOption "let noctalia manage wallpapers";
  };

  config = lib.mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true;

      settings = let
        pictures = "${config.home.homeDirectory}/Pictures";
      in {
        sessionMenu.countdownDuration = 1200;

        bar = {
          density = "compact";
          showCapsule = false;
          enableExclusionZoneInset = false;

          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
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
          enabled = cfg.wallpaper;
          overviewEnabled = true;

          directory = "${pictures}/Wallpapers";
          setWallpaperOnAllMonitors = false;
        };

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
