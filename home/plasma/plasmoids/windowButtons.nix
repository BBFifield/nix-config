{ lib, stdenv, fetchgit, cmake, extra-cmake-modules, kcolorscheme, kconfig
, kcoreaddons, kdecoration, ki18n, kirigami, kitemmodels, ksvg, libplasma
, plasma-workspace, qt6 }:

stdenv.mkDerivation rec {
  pname = "applet-window-buttons6";
  version = "0.13.0";

  src = fetchgit {
    #owner = "moodyhunter";
    #repo = "applet-window-buttons";
    url = "https://github.com/moodyhunter/applet-window-buttons6.git";
    rev = "326382805641d340c9902689b549e4488682f553";
    hash = "sha256-POr56g3zqs10tmCbKN+QcF6P6OL84tQNkA+Jtk1LUfY=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kcolorscheme
    kconfig
    kcoreaddons
    kdecoration
    ki18n
    kirigami
    kitemmodels
    ksvg
    libplasma
    plasma-workspace
    qt6.qtbase
    qt6.qtdeclarative
  ];

  meta = with lib; {
    description =
      "Plasma 6 applet in order to show window buttons in your panels";
    homepage = "https://github.com/psifidotos/applet-window-buttons";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
