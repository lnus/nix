{
  pkgs,
  config,
  inputs,
  ...
}: {
  home.packages = [
    inputs.conch.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.shell.enableNushellIntegration = true;

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

      keybindings = [
        {
          name = "launch_yazi";
          modifier = "Alt";
          keycode = "char_z";
          mode = ["vi_insert" "vi_normal"];
          event = {
            send = "executehostcommand";
            cmd = "yy"; # yazi nushell integration
          };
        }
      ];
    };

    shellAliases =
      config.home.shellAliases
      // {
        fg = "job unfreeze";
      };
  };
}
