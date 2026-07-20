{
  self,
  ...
}: {
  flake.nixosModules.sddm-autologin = {...}: {
    services.displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "linus";
      defaultSession = "niri";
    };
  };
}
