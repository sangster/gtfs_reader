{
  description = "Reads and parses zip files conforming to Google's GTFS spec";

  inputs = {
    flake-utils.url = github:numtide/flake-utils?rev=74f7e4319258e287b0f9cb95426c9853b282730b;
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      overlay = final: prev:
        let
          ruby = final.ruby_3_1;

          ruby-bundle = with final; prev.bundlerEnv {
            inherit ruby;
            name = "gtfs_reader";
            gemdir = ./.;
          };
        in rec {
          gtfs_reader = prev.stdenv.mkDerivation rec {
            pname = "gtfs_reader";
            version = "5.0.0";

            src = ./.;
            passthru.ruby-bundle = ruby-bundle;
          };
        };
    in
    { inherit overlay; } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ overlay ]; };
        inherit (pkgs.gtfs_reader.passthru) ruby-bundle;

        devShellPaths = pkgs.lib.makeBinPath (pkgs.lib.flatten [
          ruby-bundle.wrappedRuby
          (builtins.attrValues ruby-bundle.gems)
        ]);
      in rec {
        devShell = pkgs.mkShell {
          shellHook = ''
            export PATH="${devShellPaths}:$PATH"
          '';
        };

        defaultPackage = packages.gtfs_reader;
        packages = flake-utils.lib.flattenTree {
          gtfs_reader = pkgs.gtfs_reader;

          bundler = pkgs.gtfs_reader.passthru.ruby-bundle.bundler;
          ruby = pkgs.gtfs_reader.passthru.ruby-bundle.ruby;
        };
      }
    );
}
