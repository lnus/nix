{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../../nixos/optional/desktop
    ../../nixos/optional/desktop/gaming.nix
    ../../nixos/optional/desktop/misc.nix
  ];

  networking.hostName = "mantis";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # This drive conflicts and borks my trackpad
  boot.blacklistedKernelModules = ["elan_i2c"];

  # TEMP TODO: move this into core
  services.tailscale.enable = true;

  # TEMP TODO: move into core or swap for keepassxc later
  environment.systemPackages = with pkgs; [
    _1password-cli
    _1password-gui
  ];

  # TODO: consider defining users elsewhere
  users.users.linus = {
    isNormalUser = true;
    description = "linus";
    extraGroups = ["wheel" "networkmanager"];
  };
}
