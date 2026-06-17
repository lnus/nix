{
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.features.desktop.plasma;
in {
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  options.features.desktop.plasma = {
    enable = lib.mkEnableOption "enable plasma sane defaults";
  };

  config = lib.mkIf cfg.enable {
    programs.plasma = {
      enable = true;

      kwin = {
        titlebarButtons.left = ["close" "minimize" "maximize"];
      };

      panels = [
        {
          location = "bottom";
          widgets = ["org.kde.plasma.kickoff" "org.kde.plasma.taskmanager"];
        }
      ];
    };
  };
}
