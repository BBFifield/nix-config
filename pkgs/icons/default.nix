{
  stdenvNoCC,
  fetchzip,
  fetchFromGitHub,
  ...
}: {
  breezeChameleon = stdenvNoCC.mkDerivation {
    pname = "breeze-chameleon";
    version = "1.0";

    src = fetchFromGitHub {
      owner = "L4ki";
      repo = "Breeze-Chameleon-Icons";
      rev = "66305f9";
      hash = "sha256-9167UmEytKhqjoZTqe9VOpGSdCW4fYymnZeytlYx29w=";
    };

    installPhase = ''
      mkdir -p $out/share/icons;
      cp -rf Breeze* $out/share/icons;
    '';
  };

  breezeXcursor = stdenvNoCC.mkDerivation {
    pname = "BreezeX";
    version = "2.0.1";

    src = fetchzip {
      url = "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.1/BreezeX.tar.xz";
      stripRoot = false;
      hash = "sha256-kq3Amh40QzLnLBzIC3kVMCtsB1ydUahnuY+Jounay4E=";
    };

    installPhase = ''
      mkdir -p $out/share/icons
      cp -rf BreezeX-* $out/share/icons
    '';
  };
}
