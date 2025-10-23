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

  system.stateVersion = "25.05";
}
