{ ... }: {
  flake.nixosModules.zk = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      zk
      fzf # zk's --interactive pickers
    ];

    # one global notebook, so zk works from any directory
    environment.sessionVariables.ZK_NOTEBOOK_DIR = "$HOME/Notes";
  };
}
