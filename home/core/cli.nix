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
    };
  };

  programs.fd.enable = true;
  programs.carapace.enable = true;
  programs.direnv.enable = true;
  programs.yazi.enable = true;
  programs.zoxide.enable = true;
  programs.skim.enable = true;
}
