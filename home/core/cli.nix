{pkgs, ...}: {
  home.packages = [
    pkgs.tree
    pkgs.gh # easy auth while working
  ];

  programs.atuin = {
    enable = true;
    flags = ["--disable-up-arrow"];
  };

  programs.fd.enable = true;
  programs.carapace.enable = true;
  programs.direnv.enable = true;
  programs.yazi.enable = true;
  programs.zoxide.enable = true;
  programs.skim.enable = true;
}
