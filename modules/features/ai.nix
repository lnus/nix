{...}: {
  flake.nixosModules.ai = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      pi-coding-agent
      opencode
      opencode-desktop
    ];
  };
}
