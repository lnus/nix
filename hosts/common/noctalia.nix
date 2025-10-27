{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.noctalia.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${system}.default
  ];

  services.noctalia-shell.enable = true;
}
