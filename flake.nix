{
  description = "xmonadctl - simple commandline controler for xmonad-luca";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    flake-utils = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = github:numtide/flake-utils;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        myghc = pkgs.haskellPackages.ghcWithPackages (pkgs: [ pkgs.X11 ]);
      in
      rec {
        defaultApp = apps.xmonadctl;
        defaultPackage = packages.xmonadctl;

        apps.xmonadctl = {
          type = "app";
          program = "${defaultPackage}/bin/xmonadctl";
        };
        packages.xmonadctl = pkgs.stdenv.mkDerivation {
          name = "xmonadctl";
          pname = "xmonadctl";
          version = "1.0";
          src = ./.;

          buildInputs = with pkgs; [
            myghc
          ];
          buildPhase = ''
            ghc --make xmonadctl.hs
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp xmonadctl $out/bin/
            chmod +x $out/bin/xmonadctl
          '';
        };
      }
    );
}
