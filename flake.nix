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
      packages.${system}.default = pkgs.buildDotnetModule {
        pname = "marksman";
        name = "marksman";
        version = "2026-08-09";

        src = ./.;

        dotnet-sdk = pkgs.dotnetCorePackages.sdk_9_0;
        dotnet-runtime = pkgs.dotnetCorePackages.runtime_9_0;
        nugetDeps = ./deps.json;

        nativeBuildInputs = [
          pkgs.git
        ];

        projectFile = "Marksman/Marksman.fsproj";
      };
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
