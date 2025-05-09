{
  description = "monologique's flake templates";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dune-template.url = "github:monologique/dune-flake-template";
    flake-template.url = "github:monologique/nix-flake-template";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      eachSystem =
        fn:
        (nixpkgs.lib.genAttrs (import inputs.systems) (
          system:
          fn {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        ));

      systems = [
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];
    in
    {
      templates = {
        flake = {
          path = inputs.flake-template;
          description = "Simple Nix Flake template";
        };
        dune = {
          path = inputs.dune-template;
          description = "Simple Nix Flake template for OCaml/Dune projects";
        };
      };

      checks = eachSystem (
        { pkgs, system }:
        {
          pre-commit = inputs.pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              deadnix.enable = true;
              flake-checker.enable = true;
              treefmt = {
                enable = true;
                settings.formatters = with pkgs; [
                  nixfmt-rfc-style
                  taplo
                  nodePackages.prettier
                ];
              };
            };
          };
        }
      );

      devShells = eachSystem (
        { pkgs, system }:
        {
          default = pkgs.mkShell {
            buildInputs =
              with pkgs;
              [
                nixd
              ]
              ++ self.checks.${system}.pre-commit.enabledPackages;
          };
        }
      );
      formatter = eachSystem ({ pkgs, ... }: pkgs.treefmt);
    };
}
