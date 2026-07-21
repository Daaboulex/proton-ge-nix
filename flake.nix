{
  description = "GE-Proton packaged for NixOS - prebuilt Steam compatibility tool tracking upstream daily";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    std = {
      url = "github:Daaboulex/nix-packaging-standard?ref=v2.12.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.git-hooks.follows = "git-hooks";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [ inputs.std.flakeModules.base ];

      perSystem =
        { pkgs, self', ... }:
        {
          packages.default = pkgs.callPackage ./package.nix {
            variant = if pkgs.stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64";
          };

          checks.compat-tool-shape = pkgs.runCommand "proton-ge-shape" { } ''
            test -f "${self'.packages.default.steamcompattool}/compatibilitytool.vdf"
            test -e "${self'.packages.default.steamcompattool}/proton"
            grep -q '"GE-Proton"' "${self'.packages.default.steamcompattool}/compatibilitytool.vdf"
            if grep -qF "${self'.packages.default.version}" "${self'.packages.default.steamcompattool}/compatibilitytool.vdf"; then
              echo "versioned identity leaked into the vdf" >&2
              exit 1
            fi
            touch "$out"
          '';
        };

      flake.overlays.default = final: _prev: {
        proton-ge = inputs.self.packages.${final.system}.default;
      };
    };
}
