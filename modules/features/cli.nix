{...}: {
  flake.nixosModules.cli = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      yazi
      zoxide
      carapace
      direnv
      ripgrep
      fd
      jujutsu
      difftastic
      tree
      gh
    ];
  };
}
