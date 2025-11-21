{
  imports = [
    ../home/core
    ../home/optional
  ];

  home.username = "linus";
  home.homeDirectory = "/home/linus";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "hx";
  };
}
