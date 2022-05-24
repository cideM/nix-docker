{
  description = "Nix Flake template using the 'nixpkgs-unstable' branch and 'flake-utils'";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      rec {
        packages = {
          container = pkgs.dockerTools.buildImage {
            name = "foobar";
            tag = "latest";
            created = "now";
            config = {
              Cmd = [ "${pkgs.hello}/bin/hello" ];
            };
          };
        };
        defaultPackage = packages.container;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            coreutils
            moreutils
            jq
          ];
        };
      }
    );
}
