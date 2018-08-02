n{ stdenv, jdk, jre, coursier, makeWrapper }:

let
  baseName = "metap";
  version = "4.0.0-M7";
  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      coursier bootstrap org.scalameta:metap_native0.3_2.11:3.7.4 -o metap -f --native --main scala.meta.cli.Metap
      ${coursier}/bin/coursier fetch com.geirsson:scalafmt-cli_2.12:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "12hsix3b7qnyr9x2v7i6jgqljdqxpfj4bfvhjdl99ijr793g3lnp";
  };
in
stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  buildInputs = [ jdk makeWrapper deps ];

  doCheck = true;

  phases = [ "installPhase" "checkPhase" ];

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/${baseName} \
      --add-flags "-cp $CLASSPATH org.scalafmt.cli.Cli"
  '';

  checkPhase = ''
    $out/bin/${baseName} --version | grep -q "${version}"
  '';

  meta = with stdenv.lib; {
    description = "Opinionated code formatter for Scala";
    homepage = http://scalafmt.org;
    license = licenses.asl20;
  };
}
