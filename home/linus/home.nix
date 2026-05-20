{
  config,
  lib,
  ...
}: {
  home.username = lib.mkDefault "linus";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
