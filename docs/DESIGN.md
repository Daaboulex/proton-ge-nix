# Design

Why the packaging is built the way it is. The [README](../README.md) says how
to use it.

## Upstream

| | |
|---|---|
| Project | [GloriousEggroll/proton-ge-custom](https://github.com/GloriousEggroll/proton-ge-custom) |
| License | BSD-3-Clause (Valve Proton lineage) |
| Tracked | GitHub releases (`GE-Proton*` tags, daily) |

## Why it exists beside nixpkgs

A Nix flake that fetches the prebuilt GE-Proton release tarballs and exposes
them as two-output packages (`out` + `steamcompattool`) in the nixpkgs
`proton-ge-bin` shape, so they drop straight into
`programs.steam.extraCompatPackages`. It exists alongside nixpkgs' own
`proton-ge-bin` for one reason: the daily update tracker here follows upstream
releases directly, with no nixpkgs maintainer-merge lag.

## What this flake carries

The packages are built by the fleet standard's `steamCompatTool`, which
[flake.nix](../flake.nix) reaches through its `std` input. So this flake
carries only upstream's facts: the tag, the asset hashes, the brand and the
major line.

## The two attributes

| Attribute | What it is | System |
|---|---|---|
| `proton-ge` (`packages.default`, `pkgs.proton-ge`) | the host's own build: `GE-ProtonX-Y.tar.gz` on `x86_64-linux`, `GE-ProtonX-Y-aarch64.tar.gz` on `aarch64-linux` | both |
| `proton-ge-x86_64` | the x86_64 tarball on a host of either architecture, for an x86 Steam client running under FEX on aarch64; on `x86_64-linux` it is the same derivation as `proton-ge` | both |

## Channels

Every channel is a passthru of the tool attribute (`pkgs.proton-ge.v10`),
never a top-level package. `latest` follows upstream's newest release. Each
`v<major>` is a line: the rolling line's channel follows its newest release and
shows as a pin, a closed line's channel is its last release.

When upstream opens a new major, the daily updater pins the outgoing release by
itself (`majorPattern` in [`.github/update.json`](../.github/update.json)), so
no channel vanishes and nobody edits a hash by hand.

The rolling release, the pinned releases and the assets of each are in
[`sources.nix`](../sources.nix), which the daily updater moves.

## The two names in the vdf

Each channel's `compatibilitytool.vdf` carries two names.

The key, what Steam saves for a game's choice, is the attribute and the
channel, for example `proton-ge-v10`, and never moves. So a choice survives
every update and is the same for the aarch64 build and the x86_64 payload on
one Steam root.

The display name, what the dropdown shows, is
`GE-Proton <major> (<release>, latest)` for the rolling channel and
`GE-Proton <major> (<release>)` for a pin, so it says which release runs.

## What stays out

Upstream ships an aarch64 tarball since GE-Proton11-1, so on `aarch64-linux`
`proton-ge` carries `latest` and `v11` and the older pins exist on
`proton-ge-x86_64` alone.

The pre-2022 `Proton-X.Y-GE-N` tags (4.x to 7.3) are a different tag and asset
scheme and stay out.
