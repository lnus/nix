{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.linus = {
    initialPassword = "password";
    isNormalUser = true;
    description = "linus";
    extraGroups = ["wheel" "networkmanager" "video" "render"];

    packages = [inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default];
  };

  home-manager.users.linus = import ../../../home/linus/${config.networking.hostName}.nix;
}
