# See https://code.m3ta.dev/m3tam3re/nixcfg/src/branch/video18/overlays/default.nix for reference
{...}: {
  additions = final: _prev: import ../pkgs {pkgs = final;};

  modifications = final: prev: {
    foot = prev.foot.overrideAttrs (_old: {
      version = "1.25.0";
      src = prev.fetchFromCodeberg {
        owner = "dnkl";
        repo = "foot";
        rev = "1.25.0";
        hash = "sha256-s7SwIdkWhBKcq9u4V0FLKW6CA36MBvDyB9ELB0V52O0=";
      };
    });
  };
}
