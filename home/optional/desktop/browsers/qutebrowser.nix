{pkgs, ...}: {
  home.packages = with pkgs; [
    python313Packages.adblock
  ];

  programs.qutebrowser = {
    enable = true;
  };
}
