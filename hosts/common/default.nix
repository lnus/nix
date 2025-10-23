{pkgs, ...}: {
  imports = [
    ./networking.nix
    ./audio.nix
    # Add more common modules here
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Europe/Stockholm";

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  system.stateVersion = "25.05";
}
