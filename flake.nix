{
  description = "GE-Proton packaged for NixOS - rolling latest plus a pinned channel per major, tracking upstream daily";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    std = {
      url = "github:Daaboulex/nix-packaging-standard/release";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.git-hooks.follows = "git-hooks";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      toolsFor =
        pkgs:
        inputs.std.lib.steamCompatTool {
          inherit pkgs;
          attribute = "proton-ge";
          brand = "GE-Proton";
          homepage = "https://github.com/GloriousEggroll/proton-ge-custom";
          description = "GE-Proton prebuilt Steam Play compatibility tool";
          license = pkgs.lib.licenses.bsd3;
          sources = import ./sources.nix;
          inherit (pkgs.lib.importJSON ./.github/update.json) majorPattern;
          buildOf = tag: pkgs.lib.head (builtins.match "GE-Proton[0-9]+-(.*)" tag);
          assetUrl =
            tag: token:
            "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${tag}/${tag}${
              if token == "x86_64" then "" else "-${token}"
            }.tar.gz";
          variantsOf = release: release.variants;
          tokens = {
            x86_64 = {
              system = "x86_64-linux";
              suffix = "";
              qualifier = null;
            };
            aarch64 = {
              system = "aarch64-linux";
              suffix = "";
              qualifier = null;
            };
          };
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [ inputs.std.flakeModules.base ];

      perSystem =
        { pkgs, ... }:
        let
          ge = toolsFor pkgs;
        in
        {
          packages = ge.tools // {
            default = ge.tools.proton-ge;
          };
          checks.compat-tool-shape = ge.checks.compat-tool-shape;
        };

      flake.overlays.default = final: _prev: (toolsFor final).tools;
    };
}
