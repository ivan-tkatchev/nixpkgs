{ stdenv, fetchurl, darwin, disablePosixThreads ? false }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libmcrypt-2.5.8";
  
  src = fetchurl {
    url = mirror://sourceforge/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz;
    sha256 = "0gipgb939vy9m66d3k8il98rvvwczyaw2ixr8yn6icds9c3nrsz4";
  };

  buildInputs = optional stdenv.isDarwin darwin.cctools;

  dontDisableStatic = true;
  setOutputFlags = false;
  configureFlags = [ "--enable-static" ] ++ optional disablePosixThreads [ "--disable-posix-threads" ];

  outputs = [ "out" "static" ];

  postInstall = ''
    mkdir -p $static/lib
    mv $out/lib/*.a $static/lib
  '';

  meta = {
    description = "Replacement for the old crypt() package and crypt(1) command, with extensions";
    homepage = http://mcrypt.sourceforge.net;
    license = "GPL";
    platforms = platforms.all;
  };
}
