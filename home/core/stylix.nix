# QUESTION: Should this be in hosts/common?
# It does affect system as well, but also home.
# Here might be nicer, since it can be defined per-user.
# (It still can, no matter the location, but... ykwim)
{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.stylix.homeModules.stylix];

  # FIX: Make theme adjustable
  # FIX: user based firefox profile
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/embers.yaml";
    polarity = "dark";
    targets.firefox.profileNames = ["linus"];

    fonts = {
      serif = {
        package = pkgs.nerd-fonts.go-mono;
        name = "GoMono Nerd Font";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.go-mono;
        name = "GoMono Nerd Font";
      };

      monospace = {
        package = pkgs.nerd-fonts.go-mono;
        name = "GoMono Nerd Font";
      };
    };
  };
}
