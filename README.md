# proton-ge (Nix)

<!-- BEGIN generated:badges -->
[![CI](https://github.com/Daaboulex/proton-ge-nix/actions/workflows/ci.yml/badge.svg)](https://github.com/Daaboulex/proton-ge-nix/actions/workflows/ci.yml)
[![NixOS unstable](https://img.shields.io/badge/NixOS-unstable-78C0E8?logo=nixos&logoColor=white)](https://nixos.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
<!-- END generated:badges -->

Nix flake packaging for [GE-Proton](https://github.com/GloriousEggroll/proton-ge-custom) by [GloriousEggroll](https://github.com/GloriousEggroll) - Valve Proton with additional patches for games Valve's builds do not cover yet.

<!-- BEGIN generated:upstream -->
## Upstream

| | |
|---|---|
| **Project** | [GloriousEggroll/proton-ge-custom](https://github.com/GloriousEggroll/proton-ge-custom) |
| **License** | BSD-3-Clause (Valve Proton lineage) |
| **Tracked** | GitHub releases (`GE-Proton*` tags, daily) |

<!-- END generated:upstream -->

## What Is This?

A Nix flake that fetches the prebuilt GE-Proton release tarballs and exposes them as two-output packages (`out` + `steamcompattool`) in the nixpkgs `proton-ge-bin` shape, so they drop straight into `programs.steam.extraCompatPackages`. It exists alongside nixpkgs' own `proton-ge-bin` for one reason: the daily update tracker here follows upstream releases directly, with no nixpkgs maintainer-merge lag.

Every variant upstream publishes is packaged:

| Attribute | Upstream asset | System |
|---|---|---|
| `proton-ge` (`packages.default`) | `GE-ProtonX-Y.tar.gz` | `x86_64-linux` |
| `proton-ge` (`packages.default`) | `GE-ProtonX-Y-aarch64.tar.gz` | `aarch64-linux` |

The `compatibilitytool.vdf` identity is normalized to the stable name `GE-Proton` (the same normalization nixpkgs applies), so Steam's per-game Compatibility mapping survives every version bump - games mapped to `GE-Proton` transparently ride each update.

- **Package integrity** - SRI source hashes, verified on every build
- **CI security** - pinned GitHub Actions (full SHA, not tags), minimal permissions, build-gated PRs
- **Upstream trust** - daily automated release detection, hash recomputation, and a verified test build, auto-committed to `main`
- **Stale cleanup** - weekly `flake.lock` refresh (pushed only if it still builds); orphaned update branches older than 30 days are deleted

## Channels

Current pins as of 2026-07-23; the live truth is `sources.nix` (updated daily).

| Attribute | Steam identity | Version |
|---|---|---|
| `latest` (`packages.default`, `pkgs.proton-ge`) | `GE-Proton` | GE-Proton11-1 |
| `v11` | `GE-Proton 11` | GE-Proton11-1 |
| `v10` | `GE-Proton 10` | GE-Proton10-34 |
| `v9` | `GE-Proton 9` | GE-Proton9-21 |

`latest` rolls with every upstream release; each `v<major>` stays on the newest
pinned release of that major, so a game mapped to `GE-Proton 10` never silently
changes wine major.

<!-- BEGIN generated:installation -->
## Installation

Add as a flake input:

```nix
{
  inputs.proton-ge = {
    url = "github:Daaboulex/proton-ge-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Then either take the package directly:

```nix
programs.steam.extraCompatPackages = [
  inputs.proton-ge.packages.${pkgs.system}.default
];
```

or apply `inputs.proton-ge.overlays.default` and use `pkgs.proton-ge`.

<!-- END generated:installation -->

## Usage

```nix
programs.steam = {
  enable = true;
  extraCompatPackages = [ pkgs.proton-ge ];
};
```

Steam lists `GE-Proton` in each game's Compatibility dropdown. Pinning an older GE release is nix-native: pin this input to the flake revision that carried it (`git log` on this repo maps revisions to `GE-Proton*` versions).

## License

The packaging is MIT. GE-Proton itself is upstream's license (Valve Proton BSD-3-Clause lineage plus bundled components); this flake redistributes nothing - tarballs are fetched from upstream's GitHub releases at build time.

<!-- BEGIN generated:footer -->
---

*Maintained as part of the [Daaboulex](https://github.com/Daaboulex) NixOS ecosystem.*
<!-- END generated:footer -->
