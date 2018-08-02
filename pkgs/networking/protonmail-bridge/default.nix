{ stdenv, lib, fetchurl, undmg }:

assert stdenv.isDarwin;

let
  appName = "P";
in
stdenv.mkDerivation rec {
  name = "${lib.toLower appName}-darwin-${version}";
  version = "58.0.2";
  dlName = Bridge-Installer;

  src = fetchurl {
    url =  "https://protonmail.com/download/Bridge-Installer.dmg";
    sha256 = "0ivcid68wajhsb6siyd3bbycnh0dwnrzwys4iplj3p4a5a3aj2nk";
    name = "${ dlName }.dmg";
  };

  buildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/${appName}.app"
    cp -R . "$out/Applications/${appName}.app"
  '';

  postInstall = ''
    ln -f $out/Applications/${appName}.app ~/Applications/${appName}.app
  '';

  meta = with stdenv.lib; {
    description = "Mozilla Firefox, free web browser (binary package)";
    homepage = http://www.mozilla.org/firefox/;
    license = {
      free = false;
      url = http://www.mozilla.org/en-US/foundation/trademarks/policy/;
    };
    platforms = platforms.darwin;
  };
}
