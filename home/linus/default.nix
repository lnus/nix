{...}: {
  imports = [
    ../modules/shells.nix
    ../modules/editors.nix
    ../modules/cli-tools.nix
    ../modules/terminals.nix
    ../modules/browsers.nix
    ../modules/niri
    ../modules/noctalia.nix
    ../modules/vesktop.nix
    ../modules/stylix.nix
  ];

  home.username = "linus";
  home.homeDirectory = "/home/linus";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "hx";
  };
}
