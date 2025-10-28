{
  imports = [
    ../home/core
    ../home/optional
  ];

  # TODO: make these options do something
  optional.desktop = {
    enable = true;
    environment = "niri";
  };

  home.username = "linus";
  home.homeDirectory = "/home/linus";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "hx";
  };
}
