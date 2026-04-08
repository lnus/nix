# See https://code.m3ta.dev/m3tam3re/nixcfg/src/branch/video18/overlays/default.nix for reference
{inputs, ...}: {
  additions = final: _prev: import ../pkgs {pkgs = final;};

  stable = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  modifications = final: prev: {};
}
