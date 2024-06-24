{ lib, stdenv, fetchFromGitHub, cmake, kdePackages, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-panel-colorizer";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "plasma-panel-colorizer";
    rev = "4d7af2c";
    hash = "sha256-x7QKSKJNizCBhJjUbgNO45UqZ/7Yj9AK2UQ0qmtR3ao=";
  };

  nativeBuildInputs = with kdePackages; [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = with kdePackages; [
    libplasma
    plasma5support
    qtbase
    qtdeclarative
  ];

  # Install both the plasmoid and plugin
  cmakeFlags = [
    "-DINSTALL_PLASMOID=ON"
    "-DBUILD_PLUGIN=ON"
  ];

  # These two inclusions were needed, otherwise cmake would throw an error - Qt6Qml could not be found because dependency Qt6 could not be found.
  # Wasn't possible to execute 'install.sh' because we can't use sudo, so this was the only way I could see it working
  postPatch = ''
    substituteInPlace ./CMakeLists.txt \
    --replace-fail 'if(INSTALL_PLASMOID)' \ 'if(INSTALL_PLASMOID)''\n    include(KDEInstallDirs)''\n    include(KDECMakeSettings)' '';

  meta = with lib; {
    description = "Latte-Dock and WM status bar customization features for the default Plasma panel";
    homepage = "https://github.com/luisbocanegra/plasma-panel-colorizer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [luisbocanegra];
  };

})
