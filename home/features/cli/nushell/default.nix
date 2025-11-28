{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.features.cli.nushell;
in {
  options.features.cli.nushell.enable = lib.mkEnableOption "enable nushell configuration";

  config = lib.mkIf cfg.enable {
    home.shell.enableNushellIntegration = true;

    home.packages = [
      inputs.conch.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    programs.nushell = {
      enable = true;

      configFile.source = ./config.nu;

      settings = {
        buffer_editor = "hx";
        edit_mode = "vi";
        show_banner = false;
        cursor_shape = {
          vi_insert = "line";
          vi_normal = "block";
        };
      };

      shellAliases =
        config.home.shellAliases
        // {
          fg = "job unfreeze";
        };
    };
  };
}
