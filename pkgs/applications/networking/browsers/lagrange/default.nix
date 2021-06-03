{ stdenv
, lib
, fetchFromGitHub
, nix-update-script
, cmake
, pkg-config
, libunistring
, mpg123
, openssl
, pcre
, SDL2
, AppKit
, zlib
}:

stdenv.mkDerivation rec {
  pname = "lagrange";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "skyjake";
    repo = "lagrange";
    rev = "v${version}";
    sha256 = "sha256-W7uSyApTKBTE7bgprgCd8T5dKQ/nLYKIzFxjDMCRmZQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libunistring mpg123 openssl pcre SDL2 zlib ]
    ++ lib.optional stdenv.isDarwin AppKit;

  hardeningDisable = lib.optional (!stdenv.cc.isClang) "format";

  installPhase = if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    mv Lagrange.app $out/Applications
  '' else null;

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "A Beautiful Gemini Client";
    homepage = "https://gmi.skyjake.fi/lagrange/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
