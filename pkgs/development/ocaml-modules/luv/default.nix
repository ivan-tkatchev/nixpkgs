{ lib, buildDunePackage, fetchurl
, ctypes, result
, alcotest
, file
}:

buildDunePackage rec {
  pname = "luv";
  version = "0.5.8";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/aantron/luv/releases/download/${version}/luv-${version}.tar.gz";
    sha256 = "1y3g7jvb72frckjl92zyn7hzmzjy1fy4a48992jdk80vphsdzgmk";
  };

  postConfigure = ''
    for f in src/c/vendor/configure/{ltmain.sh,configure}; do
      substituteInPlace "$f" --replace /usr/bin/file file
    done
  '';

  nativeBuildInputs = [ file ];
  propagatedBuildInputs = [ ctypes result ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/aantron/luv";
    description = "Binding to libuv: cross-platform asynchronous I/O";
    # MIT-licensed, extra licenses apply partially to libuv vendor
    license = with licenses; [ mit bsd2 bsd3 cc-by-sa-40 ];
    maintainers = with maintainers; [ locallycompact sternenseemann ];
  };
}
