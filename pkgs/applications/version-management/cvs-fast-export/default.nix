{lib, stdenv, fetchurl, makeWrapper, flex, bison,
 asciidoc, docbook_xml_dtd_45, docbook_xsl,
 libxml2, libxslt,
 python3, rcs, cvs, git,
 coreutils, rsync}:
with stdenv; with lib;
mkDerivation rec {
  name = "cvs-fast-export-${meta.version}";
  meta = {
    version = "1.56";
    description = "Export an RCS or CVS history as a fast-import stream";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dfoxfranke ];
    homepage = "http://www.catb.org/esr/cvs-fast-export/";
    platforms = platforms.all;
  };

  src = fetchurl {
    url = "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-1.56.tar.gz";
    sha256 = "sha256-TB/m7kd91+PyAkGdFCCgeb9pQh0kacq0QuTZa8f9CxU=";
  };

  buildInputs = [
    flex bison asciidoc docbook_xml_dtd_45 docbook_xsl libxml2 libxslt
    python3 rcs cvs git makeWrapper
  ];

  postPatch = "patchShebangs .";

  preBuild = ''
    makeFlagsArray=(
      XML_CATALOG_FILES="${docbook_xml_dtd_45}/xml/dtd/docbook/catalog.xml ${docbook_xsl}/xml/xsl/docbook/catalog.xml"
      LIBS=""
      prefix="$out"
    )
  '';

  doCheck = true;

  postInstall =
    let
      binpath = makeBinPath [ out rcs cvs git coreutils rsync ];
    in ''
      for prog in cvs-fast-export cvsconvert cvssync; do
        wrapProgram $out/bin/$prog \
          --prefix PATH : ${binpath}
      done
    ''
  ;
}
