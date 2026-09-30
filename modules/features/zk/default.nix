{...}: {
  flake.nixosModules.zk = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      zk
    ];
  };
}
