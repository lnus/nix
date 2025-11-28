{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./nushell
    ./helix.nix
  ];

  # Consider moving
  home.packages = with pkgs; [
    tree
    gh
  ];

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
  home.shell.enableBashIntegration = true;

  programs.zellij = {
    enable = true;

    settings = {
      show_startup_tips = false;

      simplified_ui = true;
      pane_frames = false;
      default_layout = "compact";
      copy_on_select = false;

      plugins = {
        compact-bar = {
          location = "zellij:compact-bar";
          tooltip = "F1";
        };
      };
    };
  };

  programs.direnv = {
    enable = true;
    silent = true;
  };

  programs.jujutsu.enable = true;
  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  programs.carapace.enable = true;
  programs.yazi.enable = true;
  programs.zoxide.enable = true;
  programs.skim.enable = true;
}
