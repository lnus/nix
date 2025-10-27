{...}: {
  imports = [
    ./hardware-configuration.nix

    ../common
    ../common/niri.nix
    ../common/noctalia.nix
    ../common/gaming.nix
  ];

  networking.hostName = "mantis";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # This drive conflicts and ruins my trackpad
  boot.blacklistedKernelModules = ["elan_i2c"];

  users.users.linus = {
    isNormalUser = true;
    description = "linus";
    extraGroups = ["wheel" "networkmanager"];
  };
}
