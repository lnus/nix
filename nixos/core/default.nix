{pkgs, ...}: {
  imports = [
    ./networking.nix
    ./audio.nix
    ./locale.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/linus/nix"; # TEMP
  };

  system.stateVersion = "25.05";
}
