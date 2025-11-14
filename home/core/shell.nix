{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  home.packages = [
    inputs.conch.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.shell.enableNushellIntegration = true;
  home.shell.enableBashIntegration = true;

  home.shellAliases = {
    la = "ls --all";
    ll = "ls --long";
    lla = "ls --long --all";
    sl = "ls";
    e = "hx";
    v = "hx";
    mv = "mv --verbose";
    rm = "rm --verbose";
    cp = "cp --verbose --recursive --progress";
  };

  programs.bash.enable = true;

  programs.nushell = {
    enable = true;

    extraConfig = ''
      $env.PROMPT_COMMAND = {|| conch}
      $env.PROMPT_COMMAND_RIGHT = {||}
    '';

    settings = {
      buffer_editor = "hx";
      edit_mode = "vi";
      show_banner = false;
      cursor_shape = {
        vi_insert = "line";
        vi_normal = "block";
      };

      keybindings = [
        # TODO: write as nushell scripts? writeshellbin?
        # https://github.com/junegunn/fzf/issues/4122#issuecomment-2607368316
        {
          name = "skim_dirs";
          modifier = "Alt";
          keycode = "char_c";
          mode = ["vi_insert" "vi_normal"];
          event = {
            send = "executehostcommand";
            cmd = ''
              let res = ${lib.getExe pkgs.fd} -t d
              | ${lib.getExe pkgs.skim} --preview "${lib.getExe pkgs.eza} --tree -L 2 {}";
              commandline edit --append $res;
              commandline set-cursor --end
            '';
          };
        }
        {
          name = "zoxide_interactive";
          modifier = "Alt";
          keycode = "char_z";
          mode = ["vi_insert" "vi_normal"];
          event = {
            send = "executehostcommand";
            cmd = ''
              let res = ${lib.getExe pkgs.zoxide} query -i;
              commandline edit --append $res;
              commandline set-cursor --end
            '';
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
