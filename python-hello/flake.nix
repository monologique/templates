{
  description = "Simple flake boilter plate";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      forAllSystems =
        fn:
        nixpkgs.lib.genAttrs systems (
          system:
          fn (
            import nixpkgs {
              inherit system;
            }
          )
        );
    in
    {
      packages = forAllSystems (pkgs: {
        default = pkgs.writeScriptBin "flake-hello" ''
          #!${pkgs.bash}/bin/bash
          nix flake info
        '';
      });

      apps = forAllSystems (pkgs: {
        default = {
          type = "app";
          program = "${self.packages.${pkgs.system}.default}/bin/flake-hello";
        };
      });

      devShells = forAllSystems (pkgs: {

        default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            python312
            python312Packages.python-lsp-server
          ];
          packages = with pkgs; [
            ruff
            nil
            nixfmt-rfc-style
          ];

          shellHook = ''
            if [ ! -d ./.venv ]; then
              ${pkgs.python3}/bin/python -m venv .venv
            fi
            source ./.venv/bin/activate
          '';
        };

      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
