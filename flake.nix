{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      devShells.${system}.default =
        let
          libs = with pkgs; [ ];
        in
        pkgs.mkShell {
          name = "devenv";
          buildInputs = libs;
          nativeBuildInputs = (
            with pkgs;
            [
              pkg-config
              dotnetCorePackages.sdk_9_0
              nuget-to-json
            ]
          );

          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath libs}:$LD_LIBRARY_PATH";

          shellHook = ''
            echo "Devshell activated."
          '';
        };
    };
}
