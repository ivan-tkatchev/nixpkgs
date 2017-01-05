{ stdenv, fetchurl }:

stdenv.lib.overrideDerivation
(import ./default.nix { inherit stdenv fetchurl; })
(attrs: rec {
  name = "luajit-${version}";
  version = "2.0.4";

  src = fetchurl {
    url    = "http://luajit.org/download/LuaJIT-${version}.tar.gz";
    sha256 = "0zc0y7p6nx1c0pp4nhgbdgjljpfxsb5kgwp4ysz22l1p2bms83v2";
  };

  installPhase   = ''
    make install INSTALL_INC=$out/include PREFIX=$out
  '';
})


