{ pkgs ? import <nixpkgs> {} }: with pkgs;
let
  ghc = haskellPackages.ghcWithPackages (pkgs: [ pkgs.X11 ]);
in
stdenv.mkDerivation rec {
  version = "0.1";
  pname = "xmonadctl";
  src = ./.;
  buildInputs = [
    ghc
  ];
  buildPhase = "ghc --make xmonadctl.hs";
  installPhase = ''
    mkdir -p $out/bin
    cp xmonadctl $out/bin/
    chmod +x $out/bin/xmonadctl
  '';
}
