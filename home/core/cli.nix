{
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    pkgs.tree
    pkgs.gh # easy auth while working
  ];

  programs.atuin = {
    enable = true;
    flags = ["--disable-up-arrow"];
  };

  programs.zellij = {
    enable = true;

    settings = {
      default_shell = "${lib.getExe pkgs.nushell}";
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

  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  programs.carapace.enable = true;
  programs.yazi.enable = true;
  programs.zoxide.enable = true;
  programs.skim.enable = true;
}
