{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
}:
stdenv.mkDerivation {
  pname = "applet-window-buttons6";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "moodyhunter";
    repo = "applet-window-buttons6";
    rev = "3263828";
    hash = "sha256-POr56g3zqs10tmCbKN+QcF6P6OL84tQNkA+Jtk1LUfY=";
  };

  nativeBuildInputs = with kdePackages; [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = with kdePackages; [
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
    qtbase
    qtdeclarative
  ];

  meta = with lib; {
    description = "Plasma 6 applet in order to show window buttons in your panels";
    homepage = "https://github.com/psifidotos/applet-window-buttons";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [dotlambda];
  };
}
