{ lib, stdenv, fetchFromGitHub, ...}:

{

  breezeChameleon = stdenv.mkDerivation {
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
        cp -rf * $out/share/icons;
    '';
  };

}
