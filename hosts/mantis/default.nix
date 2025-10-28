{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../common # hmm...
    ../common/niri.nix
    ../common/noctalia.nix
    ../common/gaming.nix
  ];

  networking.hostName = "mantis";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # This drive conflicts and ruins my trackpad
  boot.blacklistedKernelModules = ["elan_i2c"];

  # TODO: move this into common
  # temp fix for some stuff
  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    _1password-cli
    _1password-gui
  ];

  users.users.linus = {
    isNormalUser = true;
    description = "linus";
    extraGroups = ["wheel" "networkmanager"];
  };
}
