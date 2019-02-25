{ stdenv, fetchFromGitHub, zlib, libarchive, openssl }: 

stdenv.mkDerivation rec { 
  version = "1.1";
  name = "makerpm-${version}";

  installPhase = ''
    mkdir -p $out/bin
    cp makerpm $out/bin
  '';

  buildInputs = [ zlib libarchive openssl ];

  src = fetchFromGitHub {
    owner = "ivan-tkatchev";
    repo = "makerpm";
    rev = "${version}";
    sha256 = "1qjvd1fbf5gvbq5r1qksk7y8a8qfj0rhjc5al93cs5ralsl515bh";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/ivan-tkatchev/makerpm/;
    description = "A clean, simple RPM packager reimplemented completely from scratch";
    license = licenses.free;
    platforms = platforms.all;
    maintainers = [ maintainers.ivan-tkatchev ];
  };
}
