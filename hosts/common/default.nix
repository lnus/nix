{
  pkgs,
  inputs,
  config,
  outputs,
  ...
}: let
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
        ;
      osConfig = config;
    };
  };

  nixpkgs = {
    overlays = [
      # See `../../overlays/default.nix` for reference
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable
      outputs.overlays.liLib # TODO: Wire this properly!!!
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

  # FIXME: Conflicts with plasma.
  # Also not sure why I disable this other than file size but it is... kinda useful?
  # services.speechd.enable = false;

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
