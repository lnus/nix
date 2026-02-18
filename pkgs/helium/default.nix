# Thanks,
# https://github.com/fpletz/flake
# https://github.com/AlvaroParker/helium-nix
{
  stdenv,
  lib,
  appimageTools,
  fetchurl,
}: let
  pname = "helium";
  version = "0.9.2.1";

  architectures = {
    "x86_64-linux" = {
      arch = "x86_64";
      hash = "sha256-guDBIr8NOD0GtjWznsVXlvb6llvdWHxREfDvXeP4m/w=";
    };
  };

  src = let
    inherit (architectures.${stdenv.hostPlatform.system}) arch hash;
  in
    fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/${pname}-${version}-${arch}.AppImage";
      inherit hash;
    };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = let
      contents = appimageTools.extractType2 {
        inherit pname version src;
      };
    in ''
      # Install upstream desktop file
      install -Dm444 ${contents}/${pname}.desktop \
        $out/share/applications/${pname}.desktop

      # Fix Exec to use the wrapped binary instead of AppRun
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'

      # Copy icons shipped inside the AppImage
      if [ -d "${contents}/usr/share/icons" ]; then
        cp -r ${contents}/usr/share/icons $out/share/
      fi
    '';

    meta = {
      platforms = lib.attrNames architectures;
    };
  }
