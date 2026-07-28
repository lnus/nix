{moduleWithSystem, ...}: {
  flake.nixosModules.obs-studio = moduleWithSystem ({pkgs, ...}: {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;

      package = (
        pkgs.obs-studio.override {
          cudaSupport = true;
        }
      );
    };
  });
}
