{
  pkgs,
  inputs,
  config,
  outputs,
  ...
}: let
  stylixLib = import ../features/stylix/lib.nix {inherit pkgs;};
in {
  imports = [
    ./users
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit
        inputs
        outputs
        stylixLib
        ;
      osConfig = config;
    };
  };

  nixpkgs = {
    overlays = [
      # TODO add overlays, if any
    ];

    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };

    optimise.automatic = true;
  };

  services.speechd.enable = false;

  environment.systemPackages = with pkgs; [
    git
    helix
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  users.defaultUserShell = pkgs.nushell;
}
