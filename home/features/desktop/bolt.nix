{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.desktop.bolt;
in {
  options.features.desktop.bolt = {
    enable = lib.mkEnableOption "enable bolt launcher";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bolt-launcher
    ];

    # Semi-jank patch to make wrapper behave in Niri
    # Noctalia calls Quickshell.execDetached(["niri", "msg", "action", "spawn", "--"].concat(command));
    # TODO Properly fix; issue with compositor spawning
    xdg.desktopEntries."Bolt" = let
      bolt-wrap = let
        timezone = ":${osConfig.time.timeZone}";
        xre_path = "/home/${config.home.username}/.mozilla/firefox/${config.home.username}"; # firefox profile
      in
        pkgs.writeShellScriptBin "bolt-wrap" ''
          export TZ="${timezone}"
          export XRE_PROFILE_PATH="${xre_path}"
          sh -c bolt-launcher "$@"
        '';
    in {
      categories = ["Game"];
      comment = "An alternative launcher for RuneScape";
      exec = "${lib.getExe bolt-wrap}";
      genericName = "bolt-launcher";
      icon = "bolt-launcher";
      name = "Bolt Launcher";
      terminal = false;
      type = "Application";
    };
  };
}
