{...}: {
  imports = [
    ./hardware-configuration.nix
    ../common/desktop.nix
  ];

  networking.hostName = "nixvm";

  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    useOSProber = true;
  };

  users.users.linus = {
    isNormalUser = true;
    description = "linus";
    extraGroups = ["wheel" "networkmanager"];
  };

  services.qemuGuest.enable = true;
}
