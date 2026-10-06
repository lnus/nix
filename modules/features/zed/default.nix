{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.zed = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.zed
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.zed = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.zed-editor;
      # nix files live outside devshells; project LSPs come from direnv
      runtimePkgs = with pkgs; [
        nixd
        nixfmt
        direnv
      ];
    };
  };
}
