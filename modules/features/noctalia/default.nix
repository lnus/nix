{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      settings = let
        # pictures = "${config.home.homeDirectory}/Pictures";
        pictures = "/home/linus/Pictures"; # FIXME TEMP
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

  flake.nixosModules.noctalia = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia
    ];
  };
}
