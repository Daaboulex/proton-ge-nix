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

A Nix flake that fetches the prebuilt GE-Proton release tarballs and exposes them as two-output packages (`out` + `steamcompattool`) in the nixpkgs `proton-ge-bin` shape, so they drop straight into `programs.steam.extraCompatPackages`. It exists alongside nixpkgs' own `proton-ge-bin` for one reason: the daily update tracker here follows upstream releases directly, with no nixpkgs maintainer-merge lag. The packages are built by the fleet standard's `steamCompatTool`, so this flake carries only upstream's facts: the tag, the asset hashes, the brand and the major line.

| Attribute | What it is | System |
|---|---|---|
| `proton-ge` (`packages.default`, `pkgs.proton-ge`) | the host's own build: `GE-ProtonX-Y.tar.gz` on `x86_64-linux`, `GE-ProtonX-Y-aarch64.tar.gz` on `aarch64-linux` | both |
| `proton-ge-x86_64` | the x86_64 tarball on a host of either architecture, for an x86 Steam client running under FEX on aarch64; on `x86_64-linux` it is the same derivation as `proton-ge` | both |

- **Package integrity** - SRI source hashes, verified on every build
- **CI security** - pinned GitHub Actions (full SHA, not tags), minimal permissions, build-gated PRs
- **Upstream trust** - daily automated release detection, hash recomputation, and a verified test build, auto-committed to `main`
- **Stale cleanup** - weekly `flake.lock` refresh (pushed only if it still builds); orphaned update branches older than 30 days are deleted

## Channels

Every channel is a passthru of the tool attribute (`pkgs.proton-ge.v10`), never a top-level package. `latest` follows upstream's newest release; each `v<major>` is the last release of a closed line. When upstream opens a new major, the daily updater pins the outgoing release by itself (`majorPattern` in `.github/update.json`), so no channel vanishes and nobody edits a hash by hand.

Each channel's `compatibilitytool.vdf` carries two names. The key, what Steam saves for a game's choice, is the attribute and the channel and never moves, so a choice survives every update and is the same for the aarch64 build and the x86_64 payload on one Steam root. The display name, what the dropdown shows, is `GE-Proton <major> (<release>, latest)` for the rolling channel and `GE-Proton <major> (<release>)` for a pin, so it says which release runs.

Pins as of 2026-11-08; the live truth is `sources.nix` (updated daily).

| Channel | Key Steam saves | Dropdown | Release |
|---|---|---|---|
| `latest` | `proton-ge-latest` | `GE-Proton 11 (12, latest)` | GE-Proton11-12 |
| `v10` | `proton-ge-v10` | `GE-Proton 10 (34)` | GE-Proton10-34 |
| `v9` | `proton-ge-v9` | `GE-Proton 9 (27)` | GE-Proton9-27 |
| `v8` | `proton-ge-v8` | `GE-Proton 8 (32)` | GE-Proton8-32 |
| `v7` | `proton-ge-v7` | `GE-Proton 7 (55)` | GE-Proton7-55 |

Upstream ships an aarch64 tarball since GE-Proton11-1, so on `aarch64-linux` the pins exist on `proton-ge-x86_64` alone. The pre-2022 `Proton-X.Y-GE-N` tags (4.x to 7.3) are a different tag and asset scheme and stay out.

The keys replaced the versioned identities of earlier builds (`GE-Proton-latest`, `GE-Proton-latest-aarch64`, `GE-Proton 10-34`): a game mapped to one of those shows no tool until it is picked again, once.

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
  extraCompatPackages = [
    pkgs.proton-ge
    pkgs.proton-ge.v10
  ];
};
```

Steam lists `GE-Proton 11 (12, latest)` and `GE-Proton 10 (34)` in each game's Compatibility dropdown. `checks.compat-tool-shape` builds every channel of every variant and reads each vdf for the key and display formats.

## License

The packaging is MIT. GE-Proton itself is upstream's license (Valve Proton BSD-3-Clause lineage plus bundled components); this flake redistributes nothing - tarballs are fetched from upstream's GitHub releases at build time.

<!-- BEGIN generated:footer -->
<!-- END generated:footer -->
